#!/usr/bin/env bash
# start-vms.sh — Start the pre-defined Harvester/Rancher domains and wait for
# the Harvester cluster to come up. Called by deploy.sh; env-driven.
#
# Env:
#   HARVESTER_VIP   Harvester floating VIP to poll (default 192.168.122.10)
#   MAX_WAIT        seconds to wait for first response (default 3600)
set -euo pipefail

HARVESTER_VIP="${HARVESTER_VIP:-192.168.122.10}"
MAX_WAIT="${MAX_WAIT:-3600}"
SERIAL_LOG_DIR="/var/log/libvirt/qemu"

log() { echo "[start-vms] $*"; }
die() { echo "[start-vms] ERROR: $*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || die "Must run as root"

start_vm() {
  local name="$1"
  if virsh domstate "$name" 2>/dev/null | grep -q "running"; then
    log "$name is already running."
  else
    virsh start "$name"
    log "Started $name."
  fi
}

log "Starting harvester1 (cluster bootstrap node)..."
start_vm harvester1

log "Monitor install progress: tail -f ${SERIAL_LOG_DIR}/harvester1_serial.log"
log "Waiting for Harvester to respond on ${HARVESTER_VIP} (20-40 minutes)..."

ELAPSED=0
while true; do
  if curl -sk --max-time 5 "https://${HARVESTER_VIP}" 2>&1 | grep -qiE "harvester|DOCTYPE|Found|301|Unauthorized"; then
    log "Harvester is responding."
    break
  fi
  ELAPSED=$((ELAPSED + 30))
  if [[ ${ELAPSED} -ge ${MAX_WAIT} ]]; then
    die "Timed out after ${MAX_WAIT}s. Check: tail -f ${SERIAL_LOG_DIR}/harvester1_serial.log"
  fi
  log "  ${ELAPSED}s / ${MAX_WAIT}s..."
  sleep 30
done

log "Starting harvester2..."
start_vm harvester2

log "Waiting 90s before starting harvester3 (reduces etcd join race)..."
sleep 90

log "Starting harvester3..."
start_vm harvester3

log "Starting rancher VM..."
start_vm rancher

log ""
virsh list --all
log "Harvester nodes are installing/joining in the background."
log "When all 3 nodes are Ready the deployer continues with Rancher setup."

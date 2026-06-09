#!/usr/bin/env bash
# deploy-vms.sh — Start pre-defined Harvester/Rancher VMs and wait for cluster bootstrap.
#
# Prerequisites (run once before this script):
#   cd /path/to/repo/ansible
#   ansible-galaxy collection install -r requirements.yml
#   ansible-playbook -i deployer/inventory.local ansible/playbook.yml
#
# The Ansible playbook now handles everything static:
#   - libvirt network (with static DHCP entries)
#   - storage pool
#   - disk image creation (270G harvester, 60G rancher)
#   - Harvester ISO download
#   - Harvester config seed ISOs (rendered from templates)
#   - Rancher cloud-init ISO
#   - VM domain definitions
#
# This script handles the dynamic part: start VMs in sequence, wait for install.
# Monitor install progress: tail -f /var/log/libvirt/qemu/harvester1_serial.log

set -euo pipefail

HARVESTER_VIP="192.168.122.10"   # floating kube-vip VIP (not a node IP)
SERIAL_LOG_DIR="/var/log/libvirt/qemu"

log() { echo "[deploy] $*"; }
die() { echo "[deploy] ERROR: $*" >&2; exit 1; }

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

# ---------------------------------------------------------------------------
# Start harvester1 (cluster bootstrap node)
# ---------------------------------------------------------------------------
log "Starting harvester1..."
start_vm harvester1

log ""
log "Monitor install progress:"
log "  tail -f ${SERIAL_LOG_DIR}/harvester1_serial.log"
log "  tail -f ${SERIAL_LOG_DIR}/harvester2_serial.log"
log "  tail -f ${SERIAL_LOG_DIR}/harvester3_serial.log"
log ""
log "Waiting for Harvester to respond on ${HARVESTER_VIP} (20-40 minutes)..."

ELAPSED=0
MAX_WAIT=3600
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

# ---------------------------------------------------------------------------
# Start harvester2, stagger harvester3 to avoid etcd join race
# ---------------------------------------------------------------------------
log "Starting harvester2..."
start_vm harvester2

log "Waiting 90s before starting harvester3 (reduces etcd join race)..."
sleep 90

log "Starting harvester3..."
start_vm harvester3

# ---------------------------------------------------------------------------
# Start rancher VM (can boot in parallel with harvester2/3 install)
# ---------------------------------------------------------------------------
log "Starting rancher VM..."
start_vm rancher

log ""
log "All VMs started."
virsh list --all
log ""
log "Harvester nodes are installing in the background."
log "When all 3 nodes show Ready, run: ./setup-rancher.sh"
log ""
log "Check node status (from inside harvester1 after install completes):"
log "  virsh console harvester1   # not available — serial is file-based"
log "  tail -f ${SERIAL_LOG_DIR}/harvester1_serial.log"

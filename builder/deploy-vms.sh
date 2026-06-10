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

# Wait for all 3 Harvester nodes to reach Ready before signalling done.
SSH_KEY="/root/.ssh/id_ed25519"
KUBECONFIG_TMP="/tmp/harvester-kubeconfig"

log "Fetching kubeconfig from Harvester VIP..."
FETCH_ELAPSED=0
FETCH_MAX=1800
while ! ssh -i "${SSH_KEY}" \
    -o StrictHostKeyChecking=no -o ConnectTimeout=10 -o BatchMode=yes \
    "rancher@${HARVESTER_VIP}" \
    "sudo cat /etc/rancher/rke2/rke2.yaml" \
    > "${KUBECONFIG_TMP}" 2>/dev/null; do
  FETCH_ELAPSED=$((FETCH_ELAPSED + 15))
  [[ ${FETCH_ELAPSED} -ge ${FETCH_MAX} ]] && die "Timed out (${FETCH_MAX}s) fetching kubeconfig"
  log "  SSH not ready yet — ${FETCH_ELAPSED}s / ${FETCH_MAX}s..."
  sleep 15
done
sed -i "s|127.0.0.1|${HARVESTER_VIP}|g" "${KUBECONFIG_TMP}"
log "Kubeconfig fetched."

log "Waiting for all 3 Harvester nodes to be Ready (up to 90 minutes)..."
NODE_ELAPSED=0
NODE_MAX=5400
until [[ "$(KUBECONFIG=${KUBECONFIG_TMP} kubectl get nodes --no-headers 2>/dev/null \
    | grep -c ' Ready' || echo 0)" -ge 3 ]]; do
  sleep 20
  NODE_ELAPSED=$((NODE_ELAPSED + 20))
  [[ ${NODE_ELAPSED} -ge ${NODE_MAX} ]] && die "Timed out (${NODE_MAX}s) waiting for 3 nodes Ready"
  if [[ $((NODE_ELAPSED % 120)) -eq 0 ]]; then
    READY=$(KUBECONFIG=${KUBECONFIG_TMP} kubectl get nodes --no-headers 2>/dev/null \
        | grep -c ' Ready' || echo 0)
    log "  ${NODE_ELAPSED}s elapsed — ${READY}/3 nodes Ready"
  fi
done
log "All 3 Harvester nodes Ready."
log ""
log "Run: ./setup-rancher.sh"

#!/usr/bin/env bash
# deploy.sh — Agnostic deployer for the SUSE Virtualization Rodeo stack.
#
# Deploys the same 3-node Harvester + Rancher Prime infrastructure on ANY
# SLES 16 / openSUSE Leap 16 KVM host: bare metal, a cloud VM, or an IaaS
# instance. No Instruqt assumptions — run it directly on the target host.
#
# What it does:
#   1. Installs the required Ansible collections.
#   2. Runs the shared Ansible playbook (kvm_host + vms roles) to configure the
#      host and stage all VM assets (disks, ISOs, libvirt domains).
#   3. Starts the VMs and waits for the Harvester cluster to form.
#   4. Installs K3s + Rancher Prime and imports the Harvester cluster.
#
# Usage:
#   cp deploy.env.example deploy.env   # then edit (passwords, network mode)
#   sudo ./deploy.sh
#
# For bridge networking or non-default node IPs, also copy deploy.vars.yml.example
# to deploy.vars.yml and edit it (Ansible overrides).
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "${HERE}/.." && pwd)"

log() { echo "[deploy] $*"; }
die() { echo "[deploy] ERROR: $*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || die "Must run as root (libvirt + firewalld changes need it)."

# ---------------------------------------------------------------------------
# Load config
# ---------------------------------------------------------------------------
ENV_FILE="${HERE}/deploy.env"
[[ -f "${ENV_FILE}" ]] || die "Missing ${ENV_FILE}. Copy deploy.env.example to deploy.env and edit it."
# shellcheck disable=SC1090
set -a; source "${ENV_FILE}"; set +a

NETWORK_MODE="${NETWORK_MODE:-nat}"
HOST_BRIDGE="${HOST_BRIDGE:-br0}"
HARVESTER_VIP="${HARVESTER_VIP:-192.168.122.10}"
RANCHER_IP="${RANCHER_IP:-192.168.122.9}"
RANCHER_VERSION="${RANCHER_VERSION:-2.13.1}"
K3S_VERSION="${K3S_VERSION:-v1.31.4+k3s1}"
SKIP_RANCHER="${SKIP_RANCHER:-false}"
ANSIBLE_INVENTORY="${ANSIBLE_INVENTORY:-${HERE}/inventory.local}"

[[ -n "${HARVESTER_OS_PASSWORD:-}" ]] || die "HARVESTER_OS_PASSWORD is unset in deploy.env."
[[ -n "${RANCHER_VM_PASSWORD:-}" ]]   || die "RANCHER_VM_PASSWORD is unset in deploy.env."

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------
log "Network mode: ${NETWORK_MODE}"
MISSING=()
for cmd in ansible-playbook ansible-galaxy virsh xorriso curl jq ssh kubectl; do
  command -v "${cmd}" >/dev/null 2>&1 || MISSING+=("${cmd}")
done
if (( ${#MISSING[@]} )); then
  die "Missing required commands: ${MISSING[*]}.
       Install with: zypper in ansible kubernetes-client xorriso jq openssh-clients"
fi

# ---------------------------------------------------------------------------
# 1. Ansible collections
# ---------------------------------------------------------------------------
log "Installing Ansible collections..."
ansible-galaxy collection install -r "${REPO}/ansible/requirements.yml"

# ---------------------------------------------------------------------------
# 2. Host + VM-asset configuration
# ---------------------------------------------------------------------------
log "Running Ansible playbook against ${ANSIBLE_INVENTORY}..."
# Precedence: deploy.vars.yml (advanced extras like vm_nodes / gateway) is read
# first, then the deploy.env knobs are passed last so deploy.env stays the single
# source of truth for network_mode / VIP / IPs / passwords. deploy.vars.yml must
# NOT redefine those keys — it only supplies what deploy.env does not carry.
EXTRA_VARS=()
[[ -f "${HERE}/deploy.vars.yml" ]] && EXTRA_VARS+=( -e "@${HERE}/deploy.vars.yml" )
EXTRA_VARS+=(
  -e "network_mode=${NETWORK_MODE}"
  -e "host_bridge=${HOST_BRIDGE}"
  -e "harvester_vip=${HARVESTER_VIP}"
  -e "rancher_ip=${RANCHER_IP}"
  -e "harvester_os_password=${HARVESTER_OS_PASSWORD}"
  -e "rancher_vm_password=${RANCHER_VM_PASSWORD}"
)

ansible-playbook -i "${ANSIBLE_INVENTORY}" "${REPO}/ansible/playbook.yml" "${EXTRA_VARS[@]}"

# ---------------------------------------------------------------------------
# 3. Start VMs and wait for the Harvester cluster
# ---------------------------------------------------------------------------
log "Starting VMs and waiting for Harvester..."
HARVESTER_VIP="${HARVESTER_VIP}" "${HERE}/lib/start-vms.sh"

# ---------------------------------------------------------------------------
# 4. K3s + Rancher Prime
# ---------------------------------------------------------------------------
if [[ "${SKIP_RANCHER}" == "true" ]]; then
  log "SKIP_RANCHER=true — stopping after the Harvester cluster. Done."
  exit 0
fi

log "Installing K3s + Rancher Prime and importing Harvester..."
RANCHER_VM_IP="${RANCHER_IP}" \
RANCHER_VERSION="${RANCHER_VERSION}" \
K3S_VERSION="${K3S_VERSION}" \
HARVESTER_VIP="${HARVESTER_VIP}" \
HARVESTER_OS_PASSWORD="${HARVESTER_OS_PASSWORD}" \
  "${HERE}/lib/setup-rancher.sh"

log ""
log "Deployment complete."
log "  Harvester VIP : ${HARVESTER_VIP}  (UI on :${HARVESTER_UI_PORT:-8443})"
log "  Rancher       : https://${RANCHER_IP}:30002  (NodePort; admin password in /root/rancher-password)"

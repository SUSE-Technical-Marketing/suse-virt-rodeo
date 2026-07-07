#!/usr/bin/env bash
# =============================================================================
# rodeo.sh — Interactive deployer for the SUSE Virtualization Rodeo
# =============================================================================
#
# Runs on any SLES 16 / Leap 16 KVM host, including the Instruqt builder.
# Each phase is idempotent where possible. State is tracked so you can
# resume from a failed phase without re-running completed ones.
#
# Usage:
#   sudo ./rodeo.sh                    interactive menu
#   sudo ./rodeo.sh --all              run all phases unattended
#   sudo ./rodeo.sh --interactive      run all phases, confirm between each
#   sudo ./rodeo.sh --phase N          run a single phase (1–5)
#   sudo ./rodeo.sh --from N           run phases N to 5
#   sudo ./rodeo.sh --status           show completed phases
#   sudo ./rodeo.sh --reset            clear state (full re-run on next invoke)
#   sudo ./rodeo.sh --clean            destroy VMs + disks, reset to before phase 2
#
# Phases:
#   1  Preflight     resource + tool checks
#   2  Ansible       install collections + run playbook (kvm_host + vms)
#   3  VMs           start VMs, tail serial logs, wait for 3-node cluster
#   4  Rancher       K3s + Rancher Prime + Harvester import + eject ISOs
#   5  Checklist     manual steps before saving the Instruqt image
# =============================================================================

# Persist in a tmux session so Instruqt terminal disconnects do not kill
# long-running phases (phase 3 takes 20-40 min). Re-exec inside "rodeo" session
# if not already in one; attach to an existing session if it is still running.
if [[ -z "${TMUX:-}" ]] && command -v tmux &>/dev/null; then
  session="rodeo"
  if tmux has-session -t "${session}" 2>/dev/null; then
    echo "Attaching to existing 'rodeo' tmux session (Ctrl-b d to detach safely)."
    exec tmux attach-session -t "${session}"
  fi
  exec tmux new-session -s "${session}" "$0" "$@"
fi

set -euo pipefail
trap '_on_error ${LINENO}' ERR

# =============================================================================
# Paths
# =============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOYER_DIR="${SCRIPT_DIR}/deployer"
ANSIBLE_DIR="${SCRIPT_DIR}/ansible"
LOG_DIR="${SCRIPT_DIR}/logs"
STATE_FILE="${SCRIPT_DIR}/.rodeo-state"
ENV_FILE="${DEPLOYER_DIR}/deploy.env"

# =============================================================================
# Logging: everything goes to stdout AND a timestamped log file via tee.
# After this exec, all output from this script and every child process is
# captured — including ansible, virsh, curl, ssh, and the serial tailers.
# =============================================================================
mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/rodeo-$(date +%Y%m%d-%H%M%S).log"
ln -sf "${LOG_FILE}" "${LOG_DIR}/rodeo-latest.log"
exec > >(tee -a "${LOG_FILE}") 2>&1

# =============================================================================
# Colours (disabled when stdout is not a terminal or when in a log file)
# =============================================================================
if [[ -t 1 ]]; then
  BOLD='\033[1m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
  RED='\033[0;31m' CYAN='\033[0;36m' RESET='\033[0m'
else
  BOLD='' GREEN='' YELLOW='' RED='' CYAN='' RESET=''
fi

# =============================================================================
# Helpers
# =============================================================================
CURRENT_PHASE="INIT"
declare -a SERIAL_PIDS=()
RUN_MODE="${RUN_MODE:-unattended}"

_ts()   { date +"%Y-%m-%d %H:%M:%S"; }
log()   { echo "[$(  _ts)] [${CURRENT_PHASE}] $*"; }
ok()    { echo -e "[$(_ts)] [${CURRENT_PHASE}] ${GREEN}✔  $*${RESET}"; }
warn()  { echo -e "[$(_ts)] [${CURRENT_PHASE}] ${YELLOW}⚠  $*${RESET}"; }
die()   { echo -e "[$(_ts)] [${CURRENT_PHASE}] ${RED}✖  ERROR: $*${RESET}" >&2; exit 1; }

_on_error() {
  local line="$1"
  echo ""
  echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${RED}  FAILED in phase [${CURRENT_PHASE}] at line ${line}${RESET}"
  echo -e "${RED}  Full log : ${LOG_FILE}${RESET}"
  local phase_num="${CURRENT_PHASE%%/*}"
  [[ "${phase_num}" =~ ^[0-9]+$ ]] && \
    echo -e "${RED}  Resume   : sudo ./rodeo.sh --from ${phase_num}${RESET}"
  echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  _stop_serial_tailers
  exit 1
}

_banner() {
  local label="$1" msg="$2"
  echo ""
  echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${CYAN}${BOLD}  PHASE ${label}: ${msg}${RESET}"
  echo -e "${CYAN}${BOLD}  $(_ts)${RESET}"
  echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo ""
}

_confirm() {
  [[ "${RUN_MODE}" == "interactive" ]] || return 0
  echo ""
  echo -e "${YELLOW}  ── Phase complete. Press Enter to continue or Ctrl+C to stop. ──${RESET}"
  read -r _
}

# --- State -------------------------------------------------------------------
mark_done() { grep -qxF "$1" "${STATE_FILE}" 2>/dev/null || echo "$1" >> "${STATE_FILE}"; }
is_done()   { grep -qxF "$1" "${STATE_FILE}" 2>/dev/null; }
reset_state(){ rm -f "${STATE_FILE}"; log "State cleared — all phases will re-run."; }
show_status() {
  echo ""
  echo -e "${BOLD}  Completed phases:${RESET}"
  if [[ -f "${STATE_FILE}" ]] && [[ -s "${STATE_FILE}" ]]; then
    while IFS= read -r p; do echo -e "    ${GREEN}✔  ${p}${RESET}"; done < "${STATE_FILE}"
  else
    echo "    (none)"
  fi
  echo ""
}

# --- Load env (safe to call multiple times) ----------------------------------
_load_env() {
  [[ -f "${ENV_FILE}" ]] || die "Missing ${ENV_FILE}. Copy deploy.env.example → deploy.env and set passwords."
  set -a; source "${ENV_FILE}"; set +a
  NETWORK_MODE="${NETWORK_MODE:-nat}"
  HOST_BRIDGE="${HOST_BRIDGE:-br0}"
  HARVESTER_VIP="${HARVESTER_VIP:-192.168.122.10}"
  RANCHER_IP="${RANCHER_IP:-192.168.122.9}"
  RANCHER_VERSION="${RANCHER_VERSION:-2.14.1}"
  K3S_VERSION="${K3S_VERSION:-v1.35.3+k3s1}"
  CERT_MANAGER_VERSION="${CERT_MANAGER_VERSION:-v1.20.1}"
  LAB_ADMIN_PASSWORD="${LAB_ADMIN_PASSWORD:-Foobar12345\$}"
  RANCHER_NODEPORT="${RANCHER_NODEPORT:-30002}"
  SSH_KEY="${SSH_KEY:-/root/.ssh/id_ed25519}"
  ANSIBLE_INVENTORY="${ANSIBLE_INVENTORY:-${DEPLOYER_DIR}/inventory.local}"
}

# =============================================================================
# Serial log tailers
# =============================================================================
_start_serial_tailers() {
  log "Starting serial log tailers for harvester1 / harvester2 / harvester3..."
  SERIAL_PIDS=()
  for vm in harvester1 harvester2 harvester3; do
    (
      logfile="/var/log/libvirt/qemu/${vm}_serial.log"
      until [[ -f "${logfile}" ]]; do sleep 3; done
      echo "[$(_ts)] [SERIAL:${vm}] Log file found — streaming"
      tail -F "${logfile}" 2>/dev/null | while IFS= read -r line; do
        echo "[$(_ts)] [SERIAL:${vm}] ${line}"
      done
    ) &
    SERIAL_PIDS+=($!)
  done
  log "Serial tailers running (PIDs: ${SERIAL_PIDS[*]:-none})"
}

_stop_serial_tailers() {
  if (( ${#SERIAL_PIDS[@]} > 0 )); then
    log "Stopping serial tailers..."
    for pid in "${SERIAL_PIDS[@]}"; do kill "${pid}" 2>/dev/null || true; done
    SERIAL_PIDS=()
  fi
}

# =============================================================================
# PHASE 1 — Preflight
# =============================================================================
phase_1_preflight() {
  CURRENT_PHASE="1/5 PREFLIGHT"
  _banner "1/5" "Preflight — resource and tool checks"

  if is_done "phase1"; then log "Already done — skipping. Use --reset to force."; return; fi

  [[ $EUID -eq 0 ]] || die "Must run as root."

  # Tools
  local missing_critical=0
  for cmd in ansible ansible-galaxy ansible-playbook; do
    if command -v "${cmd}" &>/dev/null; then ok "  ${cmd}: $(command -v "${cmd}")"
    else warn "  ${cmd}: NOT FOUND — install with: zypper in ansible"; (( missing_critical++ )); fi
  done
  for cmd in virsh ssh curl jq kubectl; do
    if command -v "${cmd}" &>/dev/null; then ok "  ${cmd}: found ($(command -v "${cmd}"))"
    else log "  ${cmd}: not found yet (the playbook installs most tools)"; fi
  done
  (( missing_critical > 0 )) && die "ansible is required before running this script."

  # Nested virtualisation
  local nested_file="" nested_val=""
  for f in /sys/module/kvm_intel/parameters/nested /sys/module/kvm_amd/parameters/nested; do
    [[ -f "$f" ]] && nested_file="$f" && break
  done
  if [[ -n "${nested_file}" ]]; then
    nested_val=$(tr '[:lower:]' '[:upper:]' < "${nested_file}")
    if [[ "${nested_val}" == "Y" || "${nested_val}" == "1" ]]; then
      ok "  Nested virtualisation: enabled (${nested_file})"
    else
      die "Nested virtualisation is OFF (${nested_file}=${nested_val}). Enable it on the hypervisor."
    fi
  else
    warn "  Nested virt sysfs not found — cannot confirm (may be ARM or HW without KVM module loaded yet)"
  fi

  # RAM
  local ram_gb
  ram_gb=$(awk '/MemTotal/{printf "%d", $2/1048576}' /proc/meminfo)
  if (( ram_gb >= 64 )); then ok "  RAM: ${ram_gb} GB"
  else warn "  RAM: ${ram_gb} GB — below 64 GB minimum (guests need 56 GiB). Guests may OOM."; fi

  # Disk
  local avail_gb
  avail_gb=$(df -BG /var/lib/libvirt/images 2>/dev/null | awk 'NR==2{gsub("G",""); print $4}' \
           || df -BG / | awk 'NR==2{gsub("G",""); print $4}')
  if (( avail_gb >= 600 )); then ok "  Disk (/var/lib/libvirt/images): ${avail_gb} GB free"
  else warn "  Disk: ${avail_gb} GB — may be tight (870 GB virtual, ~350 GB actual)"; fi

  # vCPU
  local vcpus; vcpus=$(nproc)
  if (( vcpus >= 28 )); then ok "  vCPU: ${vcpus}"
  else warn "  vCPU: ${vcpus} — guests need 28 total"; fi

  # deploy.env
  [[ -f "${ENV_FILE}" ]] || die "Missing ${ENV_FILE}. Copy deploy.env.example → deploy.env and set passwords."
  ok "  deploy.env: ${ENV_FILE}"
  [[ -n "${HARVESTER_OS_PASSWORD:-}" ]] || { _load_env; }
  [[ -n "${HARVESTER_OS_PASSWORD:-}" ]] || die "HARVESTER_OS_PASSWORD not set in deploy.env"
  [[ -n "${RANCHER_VM_PASSWORD:-}" ]]   || die "RANCHER_VM_PASSWORD not set in deploy.env"
  ok "  Passwords present in deploy.env"

  mark_done "phase1"
  ok "Preflight passed."
}

# =============================================================================
# PHASE 2 — Ansible
# =============================================================================
phase_2_ansible() {
  CURRENT_PHASE="2/5 ANSIBLE"
  _banner "2/5" "Ansible — install collections + run playbook"

  if is_done "phase2"; then log "Already done — skipping. Use --reset to force."; return; fi

  _load_env

  log "Installing Ansible collections (idempotent)..."
  ansible-galaxy collection install -r "${ANSIBLE_DIR}/requirements.yml"
  ok "Collections installed."

  log "Running Ansible playbook: kvm_host → vms → pxe_server"
  log "  Inventory : ${ANSIBLE_INVENTORY}"
  log "  Network   : ${NETWORK_MODE}"
  log "  VIP       : ${HARVESTER_VIP}"

  local extra_vars=()
  [[ -f "${DEPLOYER_DIR}/deploy.vars.yml" ]] && extra_vars+=("-e" "@${DEPLOYER_DIR}/deploy.vars.yml")
  extra_vars+=(
    "-e" "network_mode=${NETWORK_MODE}"
    "-e" "host_bridge=${HOST_BRIDGE}"
    "-e" "harvester_vip=${HARVESTER_VIP}"
    "-e" "rancher_ip=${RANCHER_IP}"
    "-e" "harvester_os_password=${HARVESTER_OS_PASSWORD}"
    "-e" "rancher_vm_password=${RANCHER_VM_PASSWORD}"
  )

  ansible-playbook -i "${ANSIBLE_INVENTORY}" "${ANSIBLE_DIR}/playbook.yml" "${extra_vars[@]}"

  mark_done "phase2"
  ok "Ansible complete — host configured, VM assets staged."
}

# =============================================================================
# PHASE 3 — Start VMs + wait for cluster
# =============================================================================
phase_3_vms() {
  CURRENT_PHASE="3/5 VMS"
  _banner "3/5" "VMs — start, tail serial logs, wait for 3-node cluster"

  if is_done "phase3"; then log "Already done — skipping. Use --reset to force."; return; fi

  _load_env

  # Ansible sets autostart: false on the default network to prevent virbr0 from
  # coming up at boot (before cloud-init finishes) during intermediate saves.
  # Enable autostart now and start it — VMs need dnsmasq on 192.168.122.1.
  log "Starting libvirt default network (virbr0)..."
  virsh net-start default 2>/dev/null || true
  virsh net-autostart default
  ok "virbr0 running — dnsmasq serving DHCP on 192.168.122.1."

  _start_serial_tailers

  log "Delegating VM start + cluster wait to deployer/lib/start-vms.sh..."
  HARVESTER_VIP="${HARVESTER_VIP}" MAX_WAIT="${MAX_WAIT:-3600}" \
    "${DEPLOYER_DIR}/lib/start-vms.sh"

  _stop_serial_tailers
  ok "All 3 Harvester nodes Ready."
  KUBECONFIG="/tmp/harvester-kubeconfig" kubectl get nodes -o wide 2>/dev/null || true

  mark_done "phase3"
}

# =============================================================================
# PHASE 4 — Rancher + import + eject + DNS
# =============================================================================
phase_4_rancher() {
  CURRENT_PHASE="4/5 RANCHER"
  _banner "4/5" "Rancher — K3s + Rancher Prime + Harvester import + post-install"

  if is_done "phase4"; then log "Already done — skipping. Use --reset to force."; return; fi

  _load_env
  local rancher_api="https://${RANCHER_IP}:${RANCHER_NODEPORT}"

  log "Delegating Rancher setup to deployer/lib/setup-rancher.sh..."
  RANCHER_VM_IP="${RANCHER_IP}" \
  RANCHER_VERSION="${RANCHER_VERSION}" \
  K3S_VERSION="${K3S_VERSION}" \
  HARVESTER_VIP="${HARVESTER_VIP}" \
  CERT_MANAGER_VERSION="${CERT_MANAGER_VERSION}" \
  LAB_ADMIN_PASSWORD="${LAB_ADMIN_PASSWORD}" \
  RANCHER_NODEPORT="${RANCHER_NODEPORT}" \
  SSH_KEY="${SSH_KEY}" \
    "${DEPLOYER_DIR}/lib/setup-rancher.sh"

  mark_done "phase4"
  ok "Phase 4 complete."
  echo ""
  log "  Harvester : https://${HARVESTER_VIP}   (admin / ${LAB_ADMIN_PASSWORD})"
  log "  Rancher   : ${rancher_api}  (admin / ${LAB_ADMIN_PASSWORD})"
  log "  Kubeconfig: /root/.kube/harvester.yaml"
}

# =============================================================================
# PHASE 5 — Manual checklist
# =============================================================================
phase_5_checklist() {
  CURRENT_PHASE="5/5 CHECKLIST"
  _banner "5/5" "Manual checklist — steps before saving the Instruqt image"

  _load_env

  # --- Start firewalld now (deferred from Ansible phase to avoid Instruqt
  #     connectivity issues: SLES 16 uses NetworkManager; when firewalld starts and
  #     integrates with NM via D-Bus, it can reassign eth0's zone in a way that drops
  #     the management connection on a mid-build save/reboot).
  log "Enabling and starting firewalld (deferred from Ansible phase)..."
  if systemctl is-active firewalld &>/dev/null; then
    log "  firewalld already running — reloading permanent rules."
    systemctl enable firewalld
    firewall-cmd --reload
  else
    systemctl enable --now firewalld
    firewall-cmd --reload
  fi
  ok "firewalld running. DNAT rules active for Harvester UI (:8443) and Rancher (:30002)."
  firewall-cmd --zone=public --list-all | grep -E "ports:|forward-ports:|masquerade:" || true

  # --- Enable graceful VM shutdown/restart on host stop/reboot.
  #     libvirt-guests was disabled during the build phase to prevent it from
  #     triggering libvirt before cloud-init finishes. Now that all VMs are running
  #     and the image is about to be saved, enable it so any subsequent host stop or
  #     reboot sends ACPI shutdown to all VMs instead of hard-killing them.
  log "Enabling libvirt-guests and setting VM autostart..."
  for vm in harvester1 harvester2 harvester3 rancher; do
    virsh autostart "${vm}"
  done
  systemctl enable libvirt-guests
  ok "libvirt-guests enabled — VMs will shut down cleanly on host stop and restart on boot."

  echo ""
  echo -e "${YELLOW}${BOLD}  These steps require the Harvester and Rancher UIs. Complete them manually.${RESET}"
  echo ""
  cat <<CHECKLIST
  [ ] 1. Disable Longhorn V2 data engine
         Harvester UI → Advanced → Settings → longhorn-v2-data-engine → false
         Reason: V2/SPDK requires NVMe — virtio-blk in nested KVM is not supported.

  [ ] 2. Install Harvester UI plugin v1.8.1 in Rancher
         Rancher UI → Extensions → enable Harvester repo → install v1.8.1
         Reason: plugin version must match the cluster version exactly.

  [ ] 3. Pre-load the openSUSE Leap 16 KVM image into Harvester (kvm-and-xen variant —
         virtio drivers built in; Cloud variant fails without a metadata endpoint).
         Name MUST be exactly 'leap16' — challenges reference default/leap16.

CHECKLIST
  echo "         curl -sk -X POST \\"
  echo "           -H \"Authorization: Bearer \$(cat /root/harvester-token)\" \\"
  echo "           -H \"Content-Type: application/json\" \\"
  echo "           -d '{\"metadata\":{\"name\":\"leap16\",\"namespace\":\"default\"},"
  echo "               \"spec\":{\"displayName\":\"openSUSE Leap 16\","
  echo "               \"url\":\"https://download.opensuse.org/distribution/leap/16.0/appliances/Leap-16.0-Minimal-VM.x86_64-kvm-and-xen.qcow2\","
  echo "               \"sourceType\":\"download\"}}' \\"
  echo "           https://${HARVESTER_VIP}/v1/harvesterhci.io.virtualmachineimages"
  echo ""
  cat <<CHECKLIST

  [ ] 4. Shut off all VMs and save the Instruqt image (builder only)

         for vm in harvester1 harvester2 harvester3 rancher; do
           virsh shutdown \$vm
         done
         sleep 120
         virsh list --all   # all must show "shut off"

         Then in the Instruqt console:
           geekohive → Save as image → name: suse-virt-rodeo-180 → owner: suse

CHECKLIST

  mark_done "phase5"
  ok "Checklist displayed. Complete the manual steps above before saving the image."
}

# =============================================================================
# CLEAN — Tear down phase 2 artifacts so Ansible can re-run cleanly
# =============================================================================
_clean_vms() {
  _banner "CLEAN" "Destroy VMs + disks so phase 2 can re-run from scratch"

  local images_dir="/var/lib/libvirt/images"

  echo -e "${YELLOW}  This destroys all VM definitions and their disk images."
  echo -e "  Kept (large downloads): Harvester ISO, Leap 16 base image.${RESET}"
  echo ""
  read -r -p "  Type 'yes' to continue: " _confirm_clean
  [[ "${_confirm_clean}" == "yes" ]] || { log "Aborted."; return; }

  log "Stopping and undefining VMs..."
  for vm in harvester1 harvester2 harvester3 rancher; do
    virsh destroy  "${vm}" 2>/dev/null && log "  ${vm}: destroyed" || true
    virsh undefine "${vm}" --nvram 2>/dev/null \
      || virsh undefine "${vm}" 2>/dev/null \
      || true
    log "  ${vm}: undefined"
  done

  log "Removing VM disk images..."
  for f in harvester1-vda harvester2-vda harvester3-vda rancher-vda; do
    local path="${images_dir}/${f}.qcow2"
    [[ -f "${path}" ]] && rm -f "${path}" && log "  removed ${f}.qcow2" || true
  done

  log "Removing seed / config ISOs..."
  rm -f "${images_dir}"/harvester-config-node{1,2,3}.iso \
        "${images_dir}"/rancher-cloud-init.iso 2>/dev/null || true

  log "Removing managed save and kubeconfig files..."
  rm -f /var/lib/libvirt/qemu/save/*.save \
        /tmp/harvester-kubeconfig \
        /root/.kube/harvester.yaml 2>/dev/null || true

  log "Destroying and undefining libvirt default network..."
  virsh net-destroy  default 2>/dev/null || true
  virsh net-undefine default 2>/dev/null || true

  log "Resetting phase state (2–5)..."
  sed -i '/^phase[2-5]$/d' "${STATE_FILE}" 2>/dev/null || true

  echo ""
  ok "Clean complete. Run './rodeo.sh --from 2' to rebuild."
}

# =============================================================================
# Run helpers
# =============================================================================
_run_phase() {
  case "$1" in
    1) phase_1_preflight ;;
    2) phase_2_ansible   ;;
    3) phase_3_vms       ;;
    4) phase_4_rancher   ;;
    5) phase_5_checklist ;;
    *) die "Unknown phase: $1 (valid: 1–5)" ;;
  esac
}

_run_all() {
  local start="${1:-1}"
  for n in $(seq "${start}" 5); do
    _run_phase "${n}"
    _confirm
  done
  echo ""
  ok "All phases complete."
  log "  Log file : ${LOG_FILE}"
  log "  Symlink  : ${LOG_DIR}/rodeo-latest.log"
}

# =============================================================================
# Menu
# =============================================================================
_print_menu() {
  clear 2>/dev/null || true
  echo ""
  echo -e "${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════╗${RESET}"
  echo -e "${CYAN}${BOLD}║        SUSE Virtualization Rodeo — Interactive Deployer               ║${RESET}"
  echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════╝${RESET}"
  echo ""
  echo -e "  Log: ${LOG_FILE}"
  echo -e "  Follow in another terminal:  ${YELLOW}tail -f ${LOG_DIR}/rodeo-latest.log${RESET}"
  show_status
  echo -e "  ${BOLD}[1]${RESET}  Run all phases — unattended"
  echo -e "  ${BOLD}[2]${RESET}  Run all phases — confirm between each"
  echo -e "  ${BOLD}[3]${RESET}  Run a specific phase (1–5)"
  echo -e "  ${BOLD}[4]${RESET}  Resume from a specific phase"
  echo -e "  ${BOLD}[5]${RESET}  Reset state (re-run everything)"
  echo -e "  ${BOLD}[6]${RESET}  Clean — destroy VMs + disks, reset to before phase 2"
  echo -e "  ${BOLD}[q]${RESET}  Quit"
  echo ""
}

# =============================================================================
# Entrypoint
# =============================================================================
[[ $EUID -eq 0 ]] || die "Must run as root."

log "rodeo.sh started — log: ${LOG_FILE}"

case "${1:-}" in
  --all)         RUN_MODE=unattended;  _run_all 1; exit 0 ;;
  --interactive) RUN_MODE=interactive; _run_all 1; exit 0 ;;
  --phase)       [[ -n "${2:-}" ]] || die "--phase requires a number (1–5)"
                 _run_phase "$2"; exit 0 ;;
  --from)        [[ -n "${2:-}" ]] || die "--from requires a number (1–5)"
                 _run_all "$2"; exit 0 ;;
  --status)      show_status; exit 0 ;;
  --reset)       reset_state; exit 0 ;;
  --clean)       _clean_vms; exit 0 ;;
  --help|-h)     grep "^# " "${BASH_SOURCE[0]}" | head -20 | sed 's/^# //'; exit 0 ;;
esac

# Interactive menu loop
while true; do
  _print_menu
  read -rp "  Choice: " _choice
  case "${_choice}" in
    1) RUN_MODE=unattended;  _run_all 1; break ;;
    2) RUN_MODE=interactive; _run_all 1; break ;;
    3)
      echo ""
      read -rp "  Phase number (1–5): " _pnum
      _run_phase "${_pnum}"
      echo ""; read -rp "  Press Enter to return to menu..." _
      ;;
    4)
      echo ""
      read -rp "  Resume from phase (1–5): " _pnum
      _run_all "${_pnum}"
      break
      ;;
    5) reset_state ;;
    6) _clean_vms ;;
    q|Q) log "Exiting."; exit 0 ;;
    *) echo "  Invalid choice." ;;
  esac
done

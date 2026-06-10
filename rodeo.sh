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
#
# Phases:
#   1  Preflight     resource + tool checks
#   2  Ansible       install collections + run playbook (kvm_host + vms)
#   3  VMs           start VMs, tail serial logs, wait for 3-node cluster
#   4  Rancher       K3s + Rancher Prime + Harvester import + eject ISOs
#   5  Checklist     manual steps before saving the Instruqt image
# =============================================================================

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
  RANCHER_VERSION="${RANCHER_VERSION:-2.13.1}"
  K3S_VERSION="${K3S_VERSION:-v1.31.4+k3s1}"
  CERT_MANAGER_VERSION="${CERT_MANAGER_VERSION:-v1.16.2}"
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
  if (( ram_gb >= 80 )); then ok "  RAM: ${ram_gb} GB"
  else warn "  RAM: ${ram_gb} GB — below 80 GB minimum. Guests may OOM."; fi

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

  log "Running Ansible playbook: kvm_host → vms"
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
  local kubeconfig_tmp="/tmp/harvester-kubeconfig"
  local ssh_opts="-i ${SSH_KEY} -o StrictHostKeyChecking=no -o ConnectTimeout=10 -o BatchMode=yes"

  _start_vm() {
    local name="$1"
    if virsh domstate "${name}" 2>/dev/null | grep -q "running"; then
      log "  ${name}: already running"
    else
      virsh start "${name}"
      ok "  ${name}: started"
    fi
  }

  _start_serial_tailers

  # --- harvester1 + VIP wait ---
  log "Starting harvester1 (cluster bootstrap node)..."
  _start_vm harvester1

  log "Polling https://${HARVESTER_VIP} — waiting for Harvester to respond..."
  log "  (Harvester serial output streams above — 20–40 min expected)"
  local vip_elapsed=0 vip_max="${MAX_WAIT:-3600}"
  while true; do
    if curl -sk --max-time 5 "https://${HARVESTER_VIP}" 2>&1 \
        | grep -qiE "harvester|DOCTYPE|Found|301|Unauthorized"; then
      ok "Harvester VIP is responding."
      break
    fi
    vip_elapsed=$(( vip_elapsed + 30 ))
    (( vip_elapsed >= vip_max )) && die "Timed out (${vip_max}s). Check serial logs above."
    log "  ${vip_elapsed}s / ${vip_max}s elapsed..."
    sleep 30
  done

  # --- harvester2/3 + rancher ---
  log "Starting harvester2..."
  _start_vm harvester2
  log "Waiting 90s before harvester3 (etcd join stagger)..."
  sleep 90
  log "Starting harvester3..."
  _start_vm harvester3
  log "Starting rancher VM..."
  _start_vm rancher

  log ""
  virsh list --all
  log ""

  # --- kubeconfig fetch ---
  log "Fetching kubeconfig from VIP via SSH (sshd may take a few minutes to start)..."
  local fetch_elapsed=0 fetch_max=1800
  while ! ssh ${ssh_opts} "rancher@${HARVESTER_VIP}" \
      "sudo cat /etc/rancher/rke2/rke2.yaml" \
      > "${kubeconfig_tmp}" 2>/dev/null; do
    fetch_elapsed=$(( fetch_elapsed + 15 ))
    (( fetch_elapsed >= fetch_max )) && die "Timed out (${fetch_max}s) fetching kubeconfig."
    log "  SSH not ready — ${fetch_elapsed}s / ${fetch_max}s..."
    sleep 15
  done
  sed -i "s|127.0.0.1|${HARVESTER_VIP}|g" "${kubeconfig_tmp}"
  mkdir -p /root/.kube
  cp "${kubeconfig_tmp}" /root/.kube/harvester.yaml
  chmod 600 /root/.kube/harvester.yaml
  ok "Kubeconfig saved to /root/.kube/harvester.yaml"

  # --- wait for 3 nodes Ready ---
  log "Waiting for all 3 Harvester nodes to be Ready (up to 90 min)..."
  local node_elapsed=0 node_max=5400
  while true; do
    local ready_count
    ready_count=$(KUBECONFIG="${kubeconfig_tmp}" kubectl get nodes --no-headers 2>/dev/null \
                  | grep -c ' Ready' || echo 0)
    (( ready_count >= 3 )) && break
    sleep 20; node_elapsed=$(( node_elapsed + 20 ))
    (( node_elapsed >= node_max )) && die "Timed out (${node_max}s) waiting for 3 nodes Ready."
    if (( node_elapsed % 120 == 0 )); then
      log "  ${node_elapsed}s — ${ready_count}/3 nodes Ready"
      KUBECONFIG="${kubeconfig_tmp}" kubectl get nodes --no-headers 2>/dev/null \
        | awk '{printf "    %-30s %s\n", $1, $2}' || true
    fi
  done

  _stop_serial_tailers
  ok "All 3 Harvester nodes Ready."
  KUBECONFIG="${kubeconfig_tmp}" kubectl get nodes -o wide 2>/dev/null || true

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
  local rancher_hostname="rancher.${RANCHER_IP}.sslip.io"
  local kubeconfig_tmp="/tmp/harvester-kubeconfig"
  local ssh_opts="-i ${SSH_KEY} -o StrictHostKeyChecking=no -o ConnectTimeout=10 -o BatchMode=yes"
  _ssh() { ssh ${ssh_opts} "root@${RANCHER_IP}" "$@"; }

  # --- Wait for Rancher VM SSH ---
  log "Waiting for Rancher VM SSH (${RANCHER_IP})..."
  local i
  for i in $(seq 1 30); do
    if _ssh "echo ok" &>/dev/null; then ok "  Rancher VM SSH up."; break; fi
    [[ $i -eq 30 ]] && die "Rancher VM SSH not reachable after 5 minutes."
    log "  Attempt ${i}/30 — retry in 10s..."
    sleep 10
  done

  # --- K3s ---
  if _ssh "command -v k3s" &>/dev/null; then
    log "K3s already installed — skipping."
  else
    log "Installing K3s ${K3S_VERSION}..."
    _ssh bash -s <<EOF
set -euo pipefail
export INSTALL_K3S_VERSION="${K3S_VERSION}"
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --disable traefik --node-name rancher
EOF
    ok "K3s installed."
  fi

  log "Waiting for K3s node Ready..."
  _ssh bash -s <<'EOF'
set -euo pipefail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
for i in $(seq 1 60); do
  STATUS=$(kubectl get nodes --no-headers 2>/dev/null | awk '{print $2}' | head -1)
  [[ "${STATUS}" == "Ready" ]] && echo "K3s node Ready." && exit 0
  echo "  Waiting for K3s node... (${i}/60, status=${STATUS:-unknown})"; sleep 10
done
echo "ERROR: K3s never became Ready" >&2; exit 1
EOF

  # --- Helm ---
  if _ssh "command -v helm" &>/dev/null; then
    log "Helm already installed — skipping."
  else
    log "Installing Helm..."
    _ssh bash -s <<'EOF'
set -euo pipefail
curl -sfL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
EOF
    ok "Helm installed."
  fi

  # --- cert-manager ---
  if _ssh bash -s <<'EOF' 2>/dev/null
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm list -n cert-manager 2>/dev/null | grep -q cert-manager
EOF
  then
    log "cert-manager already deployed — skipping."
  else
    log "Installing cert-manager ${CERT_MANAGER_VERSION}..."
    _ssh bash -s <<EOF
set -euo pipefail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm repo add jetstack https://charts.jetstack.io 2>/dev/null || true
helm repo update
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/${CERT_MANAGER_VERSION}/cert-manager.crds.yaml
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager --create-namespace \
  --version ${CERT_MANAGER_VERSION}
kubectl -n cert-manager rollout status deployment/cert-manager --timeout=180s
kubectl -n cert-manager rollout status deployment/cert-manager-webhook --timeout=180s
EOF
    ok "cert-manager deployed."
  fi

  # --- Rancher Prime ---
  if _ssh bash -s <<'EOF' 2>/dev/null
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm list -n cattle-system 2>/dev/null | grep -q rancher
EOF
  then
    log "Rancher Prime already deployed — skipping."
  else
    log "Installing Rancher Prime ${RANCHER_VERSION}..."
    _ssh bash -s <<EOF
set -euo pipefail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm repo add rancher-prime https://charts.rancher.com/server-charts/prime 2>/dev/null || true
helm repo update
helm install rancher rancher-prime/rancher \
  --namespace cattle-system --create-namespace \
  --version "${RANCHER_VERSION}" \
  --set hostname="${rancher_hostname}" \
  --set bootstrapPassword="admin" \
  --set replicas=1 \
  --set ingress.tls.source=rancher \
  --wait --timeout 600s
EOF
    ok "Rancher Prime deployed."
  fi

  # --- NodePort ---
  log "Ensuring Rancher NodePort ${RANCHER_NODEPORT}..."
  _ssh bash -s <<EOF
set -euo pipefail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
CURRENT=\$(kubectl -n cattle-system get svc rancher -o jsonpath='{.spec.type}' 2>/dev/null || echo "")
if [[ "\${CURRENT}" == "NodePort" ]]; then
  echo "  rancher svc already NodePort — skipping."
else
  kubectl -n cattle-system patch svc rancher \
    -p '{"spec":{"type":"NodePort","ports":[{"port":443,"nodePort":${RANCHER_NODEPORT}}]}}'
  echo "  NodePort ${RANCHER_NODEPORT} set."
fi
EOF

  log "Waiting for Rancher /ping on ${rancher_api}..."
  for i in $(seq 1 60); do
    if curl -sk --max-time 5 "${rancher_api}/ping" | grep -q "pong"; then
      ok "Rancher is up."; break
    fi
    [[ $i -eq 60 ]] && die "Rancher did not respond after 10 min."
    log "  Attempt ${i}/60 — ${rancher_api}/ping..."; sleep 10
  done

  # --- Admin password ---
  log "Setting Rancher admin password (bootstrap admin → lab password)..."
  local temp_token
  temp_token=$(curl -sk -X POST "${rancher_api}/v3-public/localProviders/local?action=login" \
    -H "Content-Type: application/json" \
    -d '{"username":"admin","password":"admin"}' | jq -r '.token // empty')
  if [[ -n "${temp_token}" ]]; then
    curl -sk -X POST "${rancher_api}/v3/users?action=changepassword" \
      -H "Authorization: Bearer ${temp_token}" \
      -H "Content-Type: application/json" \
      -d "{\"currentPassword\":\"admin\",\"newPassword\":\"${LAB_ADMIN_PASSWORD}\"}" >/dev/null
    echo "${LAB_ADMIN_PASSWORD}" > /root/rancher-password; chmod 600 /root/rancher-password
    ok "Rancher admin password set — written to /root/rancher-password."
  else
    log "  Bootstrap admin/admin returned no token — password may already be set."
  fi

  local api_token
  api_token=$(curl -sk -X POST "${rancher_api}/v3-public/localProviders/local?action=login" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"admin\",\"password\":\"${LAB_ADMIN_PASSWORD}\"}" | jq -r '.token // empty')
  [[ -n "${api_token}" ]] || die "Cannot authenticate with the lab admin password. Check /root/rancher-password."

  curl -sk -X PUT "${rancher_api}/v3/settings/server-url" \
    -H "Authorization: Bearer ${api_token}" \
    -H "Content-Type: application/json" \
    -d "{\"value\":\"${rancher_api}\"}" >/dev/null
  log "  server-url set to ${rancher_api}"

  # --- Import Harvester (idempotent) ---
  log "Checking if Harvester cluster already imported..."
  local cluster_id
  cluster_id=$(curl -sk "${rancher_api}/v3/clusters" \
    -H "Authorization: Bearer ${api_token}" \
    | jq -r '.data[] | select(.name=="harvester") | .id' 2>/dev/null | head -1 || echo "")

  if [[ -n "${cluster_id}" ]]; then
    log "  Cluster 'harvester' already exists (${cluster_id}) — skipping import."
  else
    log "  Creating cluster import record..."
    cluster_id=$(curl -sk -X POST "${rancher_api}/v3/clusters" \
      -H "Authorization: Bearer ${api_token}" \
      -H "Content-Type: application/json" \
      -d '{"type":"cluster","name":"harvester","harvesterConfig":{},"annotations":{"field.cattle.io/description":"Harvester HCI"}}' \
      | jq -r '.id')
    log "  Cluster record: ${cluster_id}"

    local manifest_url
    manifest_url=$(curl -sk "${rancher_api}/v3/clusterregistrationtokens?clusterId=${cluster_id}" \
      -H "Authorization: Bearer ${api_token}" | jq -r '.data[0].manifestUrl')

    [[ -f "${kubeconfig_tmp}" ]] || die "Harvester kubeconfig not at ${kubeconfig_tmp}. Run phase 3 first."
    log "  Applying import manifest to Harvester cluster..."
    curl -sk "${manifest_url}" | KUBECONFIG="${kubeconfig_tmp}" kubectl apply -f -

    log "  Waiting for cluster to go Active (up to 30 min)..."
    for i in $(seq 1 60); do
      local state
      state=$(curl -sk "${rancher_api}/v3/clusters/${cluster_id}" \
        -H "Authorization: Bearer ${api_token}" | jq -r '.state // "unknown"')
      log "  Cluster state: ${state} (${i}/60)"
      [[ "${state}" == "active" ]] && { ok "  Cluster Active."; break; }
      [[ $i -eq 60 ]] && warn "  Cluster not Active after 30 min — check Rancher UI."
      sleep 30
    done
  fi

  # --- Harvester dashboard password ---
  log "Setting Harvester dashboard admin password..."
  local hv_token
  hv_token=$(curl -sk -X POST "https://${HARVESTER_VIP}/v3-public/localProviders/local?action=login" \
    -H "Content-Type: application/json" \
    -d '{"username":"admin","password":"admin"}' | jq -r '.token // empty')
  if [[ -n "${hv_token}" ]]; then
    curl -sk -X POST "https://${HARVESTER_VIP}/v3/users?action=changepassword" \
      -H "Authorization: Bearer ${hv_token}" \
      -H "Content-Type: application/json" \
      -d "{\"currentPassword\":\"admin\",\"newPassword\":\"${LAB_ADMIN_PASSWORD}\"}" >/dev/null
    ok "  Harvester admin password set."
  else
    log "  Bootstrap login returned no token — may already be set."
  fi

  local hv_api_token
  hv_api_token=$(curl -sk -X POST "https://${HARVESTER_VIP}/v3-public/localProviders/local?action=login" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"admin\",\"password\":\"${LAB_ADMIN_PASSWORD}\"}" | jq -r '.token // empty')
  if [[ -n "${hv_api_token}" ]]; then
    echo "${hv_api_token}" > /root/harvester-token; chmod 600 /root/harvester-token
    ok "  Harvester API token saved to /root/harvester-token"
  fi

  # --- CoreDNS patch ---
  local lab_dns="${LAB_DNS_SERVER:-192.168.122.1}"
  log "Patching RKE2 CoreDNS: aerogrid.com → ${lab_dns}..."
  local coredns_cm=""
  for cm in rke2-coredns-rke2-coredns coredns; do
    if KUBECONFIG="${kubeconfig_tmp}" kubectl get cm "${cm}" -n kube-system &>/dev/null; then
      coredns_cm="${cm}"; break
    fi
  done
  if [[ -n "${coredns_cm}" ]]; then
    local current_cf
    current_cf=$(KUBECONFIG="${kubeconfig_tmp}" \
      kubectl get cm "${coredns_cm}" -n kube-system -o jsonpath='{.data.Corefile}')
    if echo "${current_cf}" | grep -q "aerogrid.com"; then
      log "  aerogrid.com zone already present — skipping."
    else
      KUBECONFIG="${kubeconfig_tmp}" kubectl get cm "${coredns_cm}" -n kube-system -o json \
        | jq --arg zone $'\naerogrid.com:53 {\n    errors\n    forward . '"${lab_dns}"$'\n    cache 30\n}' \
          '.data.Corefile += $zone' \
        | KUBECONFIG="${kubeconfig_tmp}" kubectl apply -f -
      ok "  CoreDNS patched — aerogrid.com forwarding active in ~30s."
    fi
  else
    warn "  CoreDNS ConfigMap not found — pod DNS patch skipped."
  fi

  # --- Eject CDROMs ---
  log "Ejecting installer ISOs from Harvester VMs..."
  for node in harvester1 harvester2 harvester3; do
    for cdrom in sda sdb; do
      local msg
      msg=$(virsh change-media "${node}" "${cdrom}" --eject --live --config 2>&1 || true)
      echo "${msg}" | grep -qiE "no media|not a cdrom|No such file" \
        || log "  ${node}:${cdrom} — ${msg}"
    done
    ok "  ${node}: CDROMs clear"
  done

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

  echo ""
  echo -e "${YELLOW}${BOLD}  These steps require the Harvester and Rancher UIs. Complete them manually.${RESET}"
  echo ""
  cat <<CHECKLIST
  [ ] 1. Disable Longhorn V2 data engine
         Harvester UI → Advanced → Settings → longhorn-v2-data-engine → false
         Reason: V2/SPDK requires NVMe — virtio-blk in nested KVM is not supported.

  [ ] 2. Install Harvester UI plugin v1.8.0 in Rancher
         Rancher UI → Extensions → enable Harvester repo → install v1.8.0
         Reason: plugin version must match the cluster version exactly.

  [ ] 3. Pre-load the openSUSE Leap 16 cloud image into Harvester
         Name MUST be exactly 'leap16' — challenges reference default/leap16.

CHECKLIST
  echo "         curl -sk -X POST \\"
  echo "           -H \"Authorization: Bearer \$(cat /root/harvester-token)\" \\"
  echo "           -H \"Content-Type: application/json\" \\"
  echo "           -d '{\"metadata\":{\"name\":\"leap16\",\"namespace\":\"default\"},"
  echo "               \"spec\":{\"displayName\":\"openSUSE Leap 16\","
  echo "               \"url\":\"https://download.opensuse.org/distribution/leap/16.0/appliances/Leap-16.0-Minimal-VM.x86_64-Cloud.qcow2\","
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
    q|Q) log "Exiting."; exit 0 ;;
    *) echo "  Invalid choice." ;;
  esac
done

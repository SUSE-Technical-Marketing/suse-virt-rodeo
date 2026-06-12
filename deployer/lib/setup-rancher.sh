#!/usr/bin/env bash
# setup-rancher.sh — Install K3s + Rancher Prime inside the rancher VM and
# import the Harvester cluster. Canonical implementation — called by deploy.sh,
# rodeo.sh phase 4, and builder/setup-rancher.sh (wrapper).
#
# Env (all have sensible defaults except where noted):
#   RANCHER_VM_IP          rancher VM management IP        (default 192.168.122.9)
#   RANCHER_VERSION        Rancher Prime chart version     (default 2.13.1)
#   K3S_VERSION            K3s install version             (default v1.31.4+k3s1)
#   HARVESTER_VIP          Harvester floating VIP          (default 192.168.122.10)
#   CERT_MANAGER_VERSION   cert-manager version            (default v1.16.2)
#   LAB_ADMIN_PASSWORD     lab admin for Rancher + Harvester dashboards
#   RANCHER_NODEPORT       Rancher NodePort                (default 30002)
#   SSH_KEY                host ed25519 key path           (default /root/.ssh/id_ed25519)
#   LAB_DNS_SERVER         aerogrid.com forward target     (default 192.168.122.1)
set -euo pipefail

RANCHER_VM_IP="${RANCHER_VM_IP:-192.168.122.9}"
RANCHER_VERSION="${RANCHER_VERSION:-2.13.1}"
K3S_VERSION="${K3S_VERSION:-v1.31.4+k3s1}"
HARVESTER_VIP="${HARVESTER_VIP:-192.168.122.10}"
CERT_MANAGER_VERSION="${CERT_MANAGER_VERSION:-v1.16.2}"
LAB_ADMIN_PASSWORD="${LAB_ADMIN_PASSWORD:-Foobar12345\$}"

RANCHER_VM_USER="root"
HARVESTER_VM_USER="rancher"
RANCHER_HOSTNAME="rancher.${RANCHER_VM_IP}.sslip.io"
RANCHER_ADMIN_PASS_FILE="/root/rancher-password"
RANCHER_NODEPORT="${RANCHER_NODEPORT:-30002}"
RANCHER_API="https://${RANCHER_VM_IP}:${RANCHER_NODEPORT}"
SSH_KEY="${SSH_KEY:-/root/.ssh/id_ed25519}"
SSH_OPTS="-i ${SSH_KEY} -o StrictHostKeyChecking=no -o ConnectTimeout=10 -o BatchMode=yes"
HARVESTER_KUBECONFIG="/tmp/harvester-kubeconfig"
LAB_DNS_SERVER="${LAB_DNS_SERVER:-192.168.122.1}"

log() { echo "[setup-rancher] $*"; }
die() { echo "[setup-rancher] ERROR: $*" >&2; exit 1; }

ssh_vm() { ssh ${SSH_OPTS} "${RANCHER_VM_USER}@${RANCHER_VM_IP}" "$@"; }

for cmd in ssh curl jq kubectl virsh; do
  command -v "$cmd" >/dev/null 2>&1 || die "Required command not found: $cmd"
done

# ---------------------------------------------------------------------------
# Wait for rancher VM SSH
# ---------------------------------------------------------------------------
log "Waiting for rancher VM SSH on ${RANCHER_VM_IP}..."
for i in $(seq 1 30); do
  if ssh_vm "echo ok" &>/dev/null; then log "SSH is up."; break; fi
  [[ $i -eq 30 ]] && die "SSH not reachable after 5 minutes"
  log "  Attempt $i/30 failed, retrying in 10s..."
  sleep 10
done

# ---------------------------------------------------------------------------
# K3s
# ---------------------------------------------------------------------------
if ssh_vm "command -v k3s" &>/dev/null; then
  log "K3s already installed — skipping."
else
  log "Installing K3s ${K3S_VERSION}..."
  ssh_vm bash -s <<EOF
set -euo pipefail
export INSTALL_K3S_VERSION="${K3S_VERSION}"
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --disable traefik --node-name rancher
EOF
fi

log "Waiting for K3s node Ready..."
ssh_vm bash -s <<'EOF'
set -euo pipefail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
for i in $(seq 1 60); do
  STATUS=$(kubectl get nodes --no-headers 2>/dev/null | awk '{print $2}' | head -1)
  [[ "${STATUS}" == "Ready" ]] && echo "K3s node Ready." && exit 0
  echo "  Waiting for K3s node... (${i}/60, status=${STATUS:-unknown})"; sleep 10
done
echo "ERROR: K3s never became Ready" >&2; exit 1
EOF

# ---------------------------------------------------------------------------
# Helm + cert-manager + Rancher Prime
# ---------------------------------------------------------------------------
if ssh_vm "command -v helm" &>/dev/null; then
  log "Helm already installed — skipping."
else
  log "Installing Helm..."
  ssh_vm bash -s <<'EOF'
set -euo pipefail
curl -sfL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
EOF
fi

if ssh_vm bash -s <<'EOF' 2>/dev/null
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm list -n cert-manager 2>/dev/null | grep -q cert-manager
EOF
then
  log "cert-manager already deployed — skipping."
else
  log "Installing cert-manager ${CERT_MANAGER_VERSION}..."
  ssh_vm bash -s <<EOF
set -euo pipefail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm repo add jetstack https://charts.jetstack.io 2>/dev/null || true
helm repo update
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/${CERT_MANAGER_VERSION}/cert-manager.crds.yaml
helm install cert-manager jetstack/cert-manager \\
  --namespace cert-manager --create-namespace \\
  --version ${CERT_MANAGER_VERSION}
kubectl -n cert-manager rollout status deployment/cert-manager --timeout=180s
kubectl -n cert-manager rollout status deployment/cert-manager-webhook --timeout=180s
EOF
fi

if ssh_vm bash -s <<'EOF' 2>/dev/null
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm list -n cattle-system 2>/dev/null | grep -q rancher
EOF
then
  log "Rancher Prime already deployed — skipping."
else
  log "Installing Rancher Prime ${RANCHER_VERSION}..."
  ssh_vm bash -s <<EOF
set -euo pipefail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm repo add rancher-prime https://charts.rancher.com/server-charts/prime 2>/dev/null || true
helm repo update
helm install rancher rancher-prime/rancher \\
  --namespace cattle-system --create-namespace \\
  --version "${RANCHER_VERSION}" \\
  --set hostname="${RANCHER_HOSTNAME}" \\
  --set bootstrapPassword="admin" \\
  --set replicas=1 \\
  --set ingress.tls.source=rancher \\
  --wait --timeout 600s
EOF
fi

log "Ensuring Rancher NodePort ${RANCHER_NODEPORT}..."
ssh_vm bash -s <<EOF
set -euo pipefail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
CURRENT=\$(kubectl -n cattle-system get svc rancher -o jsonpath='{.spec.type}' 2>/dev/null || echo "")
if [[ "\${CURRENT}" == "NodePort" ]]; then
  echo "  rancher svc already NodePort — skipping."
else
  kubectl -n cattle-system patch svc rancher \\
    -p '{"spec":{"type":"NodePort","ports":[{"port":443,"nodePort":${RANCHER_NODEPORT}}]}}'
  echo "  NodePort ${RANCHER_NODEPORT} set."
fi
EOF

log "Waiting for Rancher /ping on ${RANCHER_API}..."
for i in $(seq 1 60); do
  curl -sk --max-time 5 "${RANCHER_API}/ping" | grep -q "pong" && { log "Rancher is up."; break; }
  [[ $i -eq 60 ]] && die "Rancher did not respond after 10 minutes"
  log "  Attempt $i/60..."; sleep 10
done

# ---------------------------------------------------------------------------
# Admin password + API token + server URL
# ---------------------------------------------------------------------------
log "Setting Rancher admin password..."
TEMP_TOKEN=$(curl -sk -X POST "${RANCHER_API}/v3-public/localProviders/local?action=login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin"}' | jq -r '.token // empty')
if [[ -n "${TEMP_TOKEN}" && "${TEMP_TOKEN}" != "null" ]]; then
  curl -sk -X POST "${RANCHER_API}/v3/users?action=changepassword" \
    -H "Authorization: Bearer ${TEMP_TOKEN}" -H "Content-Type: application/json" \
    -d "{\"currentPassword\":\"admin\",\"newPassword\":\"${LAB_ADMIN_PASSWORD}\"}" >/dev/null
  echo "${LAB_ADMIN_PASSWORD}" > "${RANCHER_ADMIN_PASS_FILE}"
  chmod 600 "${RANCHER_ADMIN_PASS_FILE}"
  log "Admin password set — written to ${RANCHER_ADMIN_PASS_FILE}"
else
  log "Bootstrap admin/admin returned no token — password may already be set."
fi

API_TOKEN=$(curl -sk -X POST "${RANCHER_API}/v3-public/localProviders/local?action=login" \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"admin\",\"password\":\"${LAB_ADMIN_PASSWORD}\"}" | jq -r '.token // empty')
[[ -n "${API_TOKEN}" && "${API_TOKEN}" != "null" ]] || die "Cannot authenticate with the lab admin password. Check ${RANCHER_ADMIN_PASS_FILE}."

curl -sk -X PUT "${RANCHER_API}/v3/settings/server-url" \
  -H "Authorization: Bearer ${API_TOKEN}" -H "Content-Type: application/json" \
  -d "{\"value\":\"${RANCHER_API}\"}" >/dev/null
log "server-url set to ${RANCHER_API}"

# ---------------------------------------------------------------------------
# Harvester kubeconfig (persist for Instruqt track start)
# ---------------------------------------------------------------------------
if [[ ! -f "${HARVESTER_KUBECONFIG}" ]]; then
  log "Fetching Harvester kubeconfig from the VIP..."
  ssh ${SSH_OPTS} "${HARVESTER_VM_USER}@${HARVESTER_VIP}" \
    "sudo cat /etc/rancher/rke2/rke2.yaml" > "${HARVESTER_KUBECONFIG}" 2>/dev/null \
    || die "Could not fetch Harvester kubeconfig. Run start-vms.sh first."
  sed -i "s|127.0.0.1|${HARVESTER_VIP}|g" "${HARVESTER_KUBECONFIG}"
fi
mkdir -p /root/.kube
cp "${HARVESTER_KUBECONFIG}" /root/.kube/harvester.yaml
chmod 600 /root/.kube/harvester.yaml
log "Harvester kubeconfig saved to /root/.kube/harvester.yaml"

# ---------------------------------------------------------------------------
# CoreDNS aerogrid.com forward zone
# ---------------------------------------------------------------------------
log "Patching RKE2 CoreDNS: aerogrid.com → ${LAB_DNS_SERVER}..."
COREDNS_CM=""
for cm in rke2-coredns-rke2-coredns coredns; do
  if KUBECONFIG="${HARVESTER_KUBECONFIG}" kubectl get cm "${cm}" -n kube-system &>/dev/null; then
    COREDNS_CM="${cm}"; break
  fi
done
if [[ -z "${COREDNS_CM}" ]]; then
  log "  WARNING: CoreDNS ConfigMap not found — pod DNS patch skipped"
else
  CURRENT_CF=$(KUBECONFIG="${HARVESTER_KUBECONFIG}" \
    kubectl get cm "${COREDNS_CM}" -n kube-system -o jsonpath='{.data.Corefile}')
  if echo "${CURRENT_CF}" | grep -q "aerogrid.com"; then
    log "  aerogrid.com zone already present — skipping"
  else
    KUBECONFIG="${HARVESTER_KUBECONFIG}" \
      kubectl get cm "${COREDNS_CM}" -n kube-system -o json \
      | jq --arg zone "
aerogrid.com:53 {
    errors
    forward . ${LAB_DNS_SERVER}
    cache 30
}" '.data.Corefile += $zone' \
      | KUBECONFIG="${HARVESTER_KUBECONFIG}" kubectl apply -f -
    log "  CoreDNS patched. Reload plugin picks it up within ~30s."
  fi
fi

# ---------------------------------------------------------------------------
# Import the Harvester cluster (idempotent)
# ---------------------------------------------------------------------------
log "Checking if Harvester cluster already imported..."
CLUSTER_ID=$(curl -sk "${RANCHER_API}/v3/clusters" \
  -H "Authorization: Bearer ${API_TOKEN}" \
  | jq -r '.data[] | select(.name=="harvester") | .id' 2>/dev/null | head -1 || echo "")

if [[ -n "${CLUSTER_ID}" ]]; then
  log "Cluster 'harvester' already exists (${CLUSTER_ID}) — skipping import."
else
  log "Creating cluster import record..."
  CLUSTER_ID=$(curl -sk -X POST "${RANCHER_API}/v3/clusters" \
    -H "Authorization: Bearer ${API_TOKEN}" -H "Content-Type: application/json" \
    -d '{"type":"cluster","name":"harvester","harvesterConfig":{},"annotations":{"field.cattle.io/description":"Harvester HCI cluster for SUSE Virt Rodeo"}}' \
    | jq -r '.id')
  log "  Cluster record: ${CLUSTER_ID}"

  MANIFEST_URL=$(curl -sk "${RANCHER_API}/v3/clusterregistrationtokens?clusterId=${CLUSTER_ID}" \
    -H "Authorization: Bearer ${API_TOKEN}" | jq -r '.data[0].manifestUrl')

  log "Applying import manifest to Harvester cluster..."
  curl -sk "${MANIFEST_URL}" | KUBECONFIG="${HARVESTER_KUBECONFIG}" kubectl apply -f -

  log "Waiting for the cluster to go Active (up to 30 min)..."
  for i in $(seq 1 60); do
    STATE=$(curl -sk "${RANCHER_API}/v3/clusters/${CLUSTER_ID}" \
      -H "Authorization: Bearer ${API_TOKEN}" | jq -r '.state // "unknown"')
    log "  Cluster state: ${STATE} (${i}/60)"
    [[ "${STATE}" == "active" ]] && { log "Cluster Active."; break; }
    [[ $i -eq 60 ]] && log "WARNING: cluster not Active in time — check the Rancher UI."
    sleep 30
  done
fi

# ---------------------------------------------------------------------------
# Harvester dashboard admin password + API token
# ---------------------------------------------------------------------------
log "Setting the Harvester dashboard admin password..."
HV_BOOTSTRAP_TOKEN=$(curl -sk -X POST "https://${HARVESTER_VIP}/v3-public/localProviders/local?action=login" \
  -H "Content-Type: application/json" -d '{"username":"admin","password":"admin"}' | jq -r '.token // empty')
if [[ -n "${HV_BOOTSTRAP_TOKEN}" ]]; then
  curl -sk -X POST "https://${HARVESTER_VIP}/v3/users?action=changepassword" \
    -H "Authorization: Bearer ${HV_BOOTSTRAP_TOKEN}" -H "Content-Type: application/json" \
    -d "{\"currentPassword\":\"admin\",\"newPassword\":\"${LAB_ADMIN_PASSWORD}\"}" >/dev/null \
    && log "  Harvester admin password set to the lab password."
else
  log "  Bootstrap admin/admin login returned no token — Harvester admin password may already be set."
fi

HARVESTER_TOKEN=$(curl -sk -X POST "https://${HARVESTER_VIP}/v3-public/localProviders/local?action=login" \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"admin\",\"password\":\"${LAB_ADMIN_PASSWORD}\"}" | jq -r '.token // empty')
if [[ -n "${HARVESTER_TOKEN}" ]]; then
  echo "${HARVESTER_TOKEN}" > /root/harvester-token
  chmod 600 /root/harvester-token
  log "Harvester API token saved to /root/harvester-token"
fi

# ---------------------------------------------------------------------------
# Eject installer ISOs so the disks boot standalone
# ---------------------------------------------------------------------------
eject_cdrom() {
  local domain="$1" dev="$2" err
  err=$(virsh change-media "$domain" "$dev" --eject --live --config 2>&1) || {
    echo "$err" | grep -qiE "no media|not a cdrom|No such file" || log "WARNING: eject ${domain}:${dev} -- ${err}"
  }
}
log "Ejecting installer ISOs from Harvester VMs..."
for node in harvester1 harvester2 harvester3; do
  for cdrom in sda sdb; do eject_cdrom "$node" "$cdrom"; done
  log "  ${node}: CDROMs ejected"
done

log ""
log "Rancher URL    : ${RANCHER_API}  (NodePort)"
log "Harvester VIP  : https://${HARVESTER_VIP}  (admin / ${LAB_ADMIN_PASSWORD})"
log "Admin password : $(cat ${RANCHER_ADMIN_PASS_FILE})"
log "Cluster ID     : ${CLUSTER_ID}"
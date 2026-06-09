#!/usr/bin/env bash
# setup-rancher.sh — Install K3s + Rancher Prime inside the rancher VM and
# import the Harvester cluster. Called by deploy.sh; fully env-driven (no
# secrets baked in).
#
# Env (all have deploy.sh-provided values):
#   RANCHER_VM_IP          rancher VM management IP        (default 192.168.122.9)
#   RANCHER_VM_PASS        root password of the rancher VM (required)
#   RANCHER_VERSION        Rancher Prime chart version     (default 2.13.1)
#   K3S_VERSION            K3s install version             (default v1.31.4+k3s1)
#   HARVESTER_VIP          Harvester floating VIP          (default 192.168.122.10)
#   HARVESTER_OS_PASSWORD  Harvester node root password    (required)
#   CERT_MANAGER_VERSION   cert-manager version            (default v1.16.2)
set -euo pipefail

RANCHER_VM_IP="${RANCHER_VM_IP:-192.168.122.9}"
RANCHER_VM_PASS="${RANCHER_VM_PASS:?RANCHER_VM_PASS is required}"
RANCHER_VERSION="${RANCHER_VERSION:-2.13.1}"
K3S_VERSION="${K3S_VERSION:-v1.31.4+k3s1}"
HARVESTER_VIP="${HARVESTER_VIP:-192.168.122.10}"
HARVESTER_OS_PASSWORD="${HARVESTER_OS_PASSWORD:?HARVESTER_OS_PASSWORD is required}"
CERT_MANAGER_VERSION="${CERT_MANAGER_VERSION:-v1.16.2}"

RANCHER_VM_USER="root"
RANCHER_HOSTNAME="rancher.${RANCHER_VM_IP}.sslip.io"
RANCHER_ADMIN_PASS_FILE="/root/rancher-password"
RANCHER_NODEPORT="${RANCHER_NODEPORT:-30002}"
# K3s has traefik disabled, so Rancher is reached on a NodePort, not :443.
# All setup-time API calls and the agent server-url use this endpoint.
RANCHER_API="https://${RANCHER_VM_IP}:${RANCHER_NODEPORT}"
SSH_OPTS="-o StrictHostKeyChecking=no -o ConnectTimeout=10 -o BatchMode=yes"

log() { echo "[setup-rancher] $*"; }
die() { echo "[setup-rancher] ERROR: $*" >&2; exit 1; }

ssh_vm() { sshpass -p "${RANCHER_VM_PASS}" ssh ${SSH_OPTS} "${RANCHER_VM_USER}@${RANCHER_VM_IP}" "$@"; }

for cmd in sshpass curl jq kubectl; do
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
log "Installing K3s ${K3S_VERSION}..."
ssh_vm bash -s <<EOF
set -euo pipefail
export INSTALL_K3S_VERSION="${K3S_VERSION}"
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --disable traefik --node-name rancher
EOF

log "Waiting for K3s node Ready..."
ssh_vm bash -s <<'EOF'
set -euo pipefail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
for i in $(seq 1 60); do
  [[ "$(kubectl get nodes --no-headers 2>/dev/null | awk '{print $2}' | head -1)" == "Ready" ]] && echo "Ready" && exit 0
  echo "  Waiting... (${i}/60)"; sleep 10
done
echo "ERROR: K3s node never became Ready" >&2; exit 1
EOF

# ---------------------------------------------------------------------------
# Helm + cert-manager + Rancher Prime
# ---------------------------------------------------------------------------
log "Installing Helm..."
ssh_vm bash -s <<'EOF'
set -euo pipefail
curl -sfL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
EOF

log "Adding Helm repos + cert-manager ${CERT_MANAGER_VERSION}..."
ssh_vm bash -s <<EOF
set -euo pipefail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm repo add rancher-prime https://charts.rancher.com/server-charts/prime
helm repo add jetstack https://charts.jetstack.io
helm repo update
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/${CERT_MANAGER_VERSION}/cert-manager.crds.yaml
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version ${CERT_MANAGER_VERSION}
kubectl -n cert-manager rollout status deployment/cert-manager --timeout=180s
kubectl -n cert-manager rollout status deployment/cert-manager-webhook --timeout=180s
EOF

log "Installing Rancher Prime ${RANCHER_VERSION}..."
ssh_vm bash -s <<RANCHEREOF
set -euo pipefail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm install rancher rancher-prime/rancher \\
  --namespace cattle-system --create-namespace \\
  --version "${RANCHER_VERSION}" \\
  --set hostname="${RANCHER_HOSTNAME}" \\
  --set bootstrapPassword="admin" \\
  --set replicas=1 \\
  --set ingress.tls.source=rancher \\
  --wait --timeout 600s
RANCHEREOF

# Expose Rancher on a fixed NodePort (K3s has traefik disabled, so there is no
# ingress on :443). Reuse the rancher service's own https targetPort.
log "Exposing Rancher on NodePort ${RANCHER_NODEPORT}..."
ssh_vm bash -s <<EOF
set -euo pipefail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
HTTPS_TARGET=\$(kubectl -n cattle-system get svc rancher -o jsonpath='{.spec.ports[?(@.port==443)].targetPort}')
[ -n "\${HTTPS_TARGET}" ] || HTTPS_TARGET=443
kubectl apply -f - <<YAML
apiVersion: v1
kind: Service
metadata:
  name: rancher-nodeport
  namespace: cattle-system
spec:
  type: NodePort
  selector:
    app: rancher
  ports:
  - name: https
    protocol: TCP
    port: 443
    targetPort: \${HTTPS_TARGET}
    nodePort: ${RANCHER_NODEPORT}
YAML
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
  -H "Content-Type: application/json" -d '{"username":"admin","password":"admin"}' | jq -r '.token')
[[ -n "${TEMP_TOKEN}" && "${TEMP_TOKEN}" != "null" ]] || die "Failed to get initial login token"

# Subshell with pipefail off: tr gets SIGPIPE when head closes the pipe, which
# would otherwise abort the script under `set -o pipefail`.
ADMIN_PASS=$(set +o pipefail; LC_ALL=C tr -dc 'A-Za-z0-9!@#%^&*' < /dev/urandom | head -c 24)
curl -sk -X POST "${RANCHER_API}/v3/users?action=changepassword" \
  -H "Authorization: Bearer ${TEMP_TOKEN}" -H "Content-Type: application/json" \
  -d "{\"currentPassword\":\"admin\",\"newPassword\":\"${ADMIN_PASS}\"}"
echo "${ADMIN_PASS}" > "${RANCHER_ADMIN_PASS_FILE}"; chmod 600 "${RANCHER_ADMIN_PASS_FILE}"
log "Admin password written to ${RANCHER_ADMIN_PASS_FILE}"

API_TOKEN=$(curl -sk -X POST "${RANCHER_API}/v3-public/localProviders/local?action=login" \
  -H "Content-Type: application/json" -d "{\"username\":\"admin\",\"password\":\"${ADMIN_PASS}\"}" | jq -r '.token')
[[ -n "${API_TOKEN}" && "${API_TOKEN}" != "null" ]] || die "Failed to authenticate with new password"

# server-url must be reachable by the Harvester cattle-cluster-agent on the same
# network — point it at the NodePort, not :443.
curl -sk -X PUT "${RANCHER_API}/v3/settings/server-url" \
  -H "Authorization: Bearer ${API_TOKEN}" -H "Content-Type: application/json" \
  -d "{\"value\":\"${RANCHER_API}\"}"

# ---------------------------------------------------------------------------
# Import the Harvester cluster
# ---------------------------------------------------------------------------
log "Importing Harvester cluster into Rancher..."
CLUSTER_ID=$(curl -sk -X POST "${RANCHER_API}/v3/clusters" \
  -H "Authorization: Bearer ${API_TOKEN}" -H "Content-Type: application/json" \
  -d '{"type":"cluster","name":"harvester","harvesterConfig":{},"annotations":{"field.cattle.io/description":"Harvester HCI cluster for SUSE Virt Rodeo"}}' \
  | jq -r '.id')
log "  Cluster record: ${CLUSTER_ID}"

MANIFEST_URL=$(curl -sk "${RANCHER_API}/v3/clusterregistrationtokens?clusterId=${CLUSTER_ID}" \
  -H "Authorization: Bearer ${API_TOKEN}" | jq -r '.data[0].manifestUrl')

HARVESTER_KUBECONFIG="/tmp/harvester-kubeconfig"
if [[ ! -f "${HARVESTER_KUBECONFIG}" ]]; then
  log "  Fetching Harvester kubeconfig from ${HARVESTER_VIP}..."
  sshpass -p "${HARVESTER_OS_PASSWORD}" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=15 \
    "root@${HARVESTER_VIP}" "cat /etc/rancher/rke2/rke2.yaml" > "${HARVESTER_KUBECONFIG}" 2>/dev/null \
    || die "Could not fetch Harvester kubeconfig. Is harvester1 up with SSH enabled?"
  sed -i "s|127.0.0.1|${HARVESTER_VIP}|g" "${HARVESTER_KUBECONFIG}"
fi

# Persist the Harvester kubeconfig where the Instruqt track expects it
# (setup-geekohive reads /root/.kube/harvester.yaml). Harmless for non-Instruqt use.
mkdir -p /root/.kube
cp "${HARVESTER_KUBECONFIG}" /root/.kube/harvester.yaml
chmod 600 /root/.kube/harvester.yaml
log "  Harvester kubeconfig saved to /root/.kube/harvester.yaml (API at ${HARVESTER_VIP}:6443)"

curl -sk "${MANIFEST_URL}" | KUBECONFIG="${HARVESTER_KUBECONFIG}" kubectl apply -f -
log "  Import manifest applied. Waiting for the cluster to go Active..."

for i in $(seq 1 60); do
  STATE=$(curl -sk "${RANCHER_API}/v3/clusters/${CLUSTER_ID}" \
    -H "Authorization: Bearer ${API_TOKEN}" | jq -r '.state // "unknown"')
  log "  Cluster state: ${STATE} (attempt $i/60)"
  [[ "${STATE}" == "active" ]] && break
  [[ $i -eq 60 ]] && log "WARNING: cluster not Active in time — check the Rancher UI."
  sleep 30
done

HARVESTER_TOKEN=$(curl -sk -X POST "https://${HARVESTER_VIP}/v3-public/localProviders/local?action=login" \
  -H "Content-Type: application/json" -d "{\"username\":\"admin\",\"password\":\"${HARVESTER_OS_PASSWORD}\"}" | jq -r '.token // empty')
[[ -n "${HARVESTER_TOKEN}" ]] && { echo "${HARVESTER_TOKEN}" > /root/harvester-token; chmod 600 /root/harvester-token; log "Harvester API token saved to /root/harvester-token"; }

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
log "Admin password : $(cat ${RANCHER_ADMIN_PASS_FILE})"
log "Cluster ID     : ${CLUSTER_ID}"

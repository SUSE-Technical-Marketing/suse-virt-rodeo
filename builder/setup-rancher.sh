#!/usr/bin/env bash
# setup-rancher.sh — Install K3s + Rancher Prime 2.13.1 inside the rancher VM,
# then import the Harvester cluster into Rancher via the API.
#
# Run as root on geekohive after:
#   - All three Harvester nodes are joined and Ready
#   - The rancher VM is running (virsh start rancher)
#
# The rancher VM must have network access via virbr0 (192.168.122.9).
# SSH access uses the same root password set by your cloud-init / kickstart.
set -euo pipefail

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
RANCHER_VM_IP="192.168.122.9"
RANCHER_VM_USER="root"
RANCHER_VERSION="2.13.1"
RANCHER_HOSTNAME="rancher.${RANCHER_VM_IP}.sslip.io"
RANCHER_ADMIN_PASS_FILE="/root/rancher-password"
HARVESTER_VIP="192.168.122.10"   # floating kube-vip VIP (not a node IP)
HARVESTER_VM_USER="rancher"      # Harvester's default OS user; root login is disabled
RANCHER_NODEPORT=30002
# K3s has traefik disabled, so Rancher is reached on a NodePort, not :443.
# All setup-time API calls and the agent server-url use this endpoint.
RANCHER_API="https://${RANCHER_VM_IP}:${RANCHER_NODEPORT}"
K3S_VERSION="v1.31.4+k3s1"  # latest stable at time of writing; update as needed
LAB_ADMIN_PASSWORD="Foobar12345\$"   # fixed admin password for the Rancher + Harvester dashboards/APIs

# Key-based SSH. The host public key is baked into the Rancher VM (cloud-init)
# and the Harvester nodes (os.ssh_authorized_keys) by the Ansible playbook.
SSH_KEY="/root/.ssh/id_ed25519"
SSH_OPTS="-i ${SSH_KEY} -o StrictHostKeyChecking=no -o ConnectTimeout=10 -o BatchMode=yes"

# ---------------------------------------------------------------------------
# Helper
# ---------------------------------------------------------------------------
log() { echo "[setup-rancher] $*"; }
die() { echo "[setup-rancher] ERROR: $*" >&2; exit 1; }

ssh_vm() {
  ssh ${SSH_OPTS} "${RANCHER_VM_USER}@${RANCHER_VM_IP}" "$@"
}

scp_to_vm() {
  scp ${SSH_OPTS} "$1" "${RANCHER_VM_USER}@${RANCHER_VM_IP}:$2"
}

require_cmd() {
  for cmd in "$@"; do
    command -v "$cmd" &>/dev/null || die "Required command not found: $cmd"
  done
}

require_cmd ssh curl jq

# ---------------------------------------------------------------------------
# Wait for rancher VM to be reachable
# ---------------------------------------------------------------------------
log "Waiting for rancher VM SSH on ${RANCHER_VM_IP}..."
for i in $(seq 1 30); do
  if ssh_vm "echo ok" &>/dev/null; then
    log "SSH is up."
    break
  fi
  [[ $i -eq 30 ]] && die "SSH not reachable after 5 minutes"
  log "  Attempt $i/30 failed, retrying in 10s..."
  sleep 10
done

# ---------------------------------------------------------------------------
# Step 1 — Install K3s
# ---------------------------------------------------------------------------
log "Installing K3s ${K3S_VERSION} on rancher VM..."

ssh_vm bash -s <<EOF
set -euo pipefail
export INSTALL_K3S_VERSION="${K3S_VERSION}"
curl -sfL https://get.k3s.io | sh -s - \\
  --write-kubeconfig-mode 644 \\
  --disable traefik \\
  --node-name rancher
EOF

log "Waiting for K3s node to be Ready..."
ssh_vm bash -s <<'EOF'
set -euo pipefail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
for i in $(seq 1 60); do
  STATUS=$(kubectl get nodes --no-headers 2>/dev/null | awk '{print $2}' | head -1)
  [[ "${STATUS}" == "Ready" ]] && echo "Node is Ready" && exit 0
  echo "  Waiting... (${i}/60)"
  sleep 10
done
echo "ERROR: K3s node never became Ready" >&2
exit 1
EOF

# ---------------------------------------------------------------------------
# Step 2 — Install Helm
# ---------------------------------------------------------------------------
log "Installing Helm..."
ssh_vm bash -s <<'EOF'
set -euo pipefail
curl -sfL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
EOF

# ---------------------------------------------------------------------------
# Step 3 — Add Rancher Prime Helm repo and cert-manager
# ---------------------------------------------------------------------------
log "Adding Helm repos..."
ssh_vm bash -s <<'EOF'
set -euo pipefail
helm repo add rancher-prime https://charts.rancher.com/server-charts/prime
helm repo add jetstack https://charts.jetstack.io
helm repo update
EOF

log "Installing cert-manager..."
ssh_vm bash -s <<'EOF'
set -euo pipefail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.2/cert-manager.crds.yaml
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.16.2

echo "Waiting for cert-manager to be ready..."
kubectl -n cert-manager rollout status deployment/cert-manager --timeout=180s
kubectl -n cert-manager rollout status deployment/cert-manager-webhook --timeout=180s
EOF

# ---------------------------------------------------------------------------
# Step 4 — Install Rancher Prime 2.13.1
# ---------------------------------------------------------------------------
log "Installing Rancher Prime ${RANCHER_VERSION}..."
ssh_vm bash -s <<RANCHEREOF
set -euo pipefail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

helm install rancher rancher-prime/rancher \\
  --namespace cattle-system \\
  --create-namespace \\
  --version "${RANCHER_VERSION}" \\
  --set hostname="${RANCHER_HOSTNAME}" \\
  --set bootstrapPassword="admin" \\
  --set replicas=1 \\
  --set ingress.tls.source=rancher \\
  --wait --timeout 600s

echo "Rancher deployment complete."
RANCHEREOF

# Expose Rancher on a fixed NodePort (K3s has traefik disabled, so there is no
# ingress on :443). The cloud-client proxy and setup-geekohive both target
# geekohive:30002 -> 192.168.122.9:30002. Strategic-merge patch the existing
# rancher service on its :443 port (merge key is "port"), so Rancher's real
# https targetPort and the :80 port are preserved while :443 gets nodePort 30002.
log "Exposing Rancher on NodePort ${RANCHER_NODEPORT}..."
ssh_vm bash -s <<EOF
set -euo pipefail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
kubectl -n cattle-system patch svc rancher -p '{"spec":{"type":"NodePort","ports":[{"port":443,"nodePort":${RANCHER_NODEPORT}}]}}'
EOF

log "Waiting for Rancher to respond on ${RANCHER_API}/ping..."
for i in $(seq 1 60); do
  if curl -sk --max-time 5 "${RANCHER_API}/ping" | grep -q "pong"; then
    log "Rancher is up."
    break
  fi
  [[ $i -eq 60 ]] && die "Rancher did not respond after 10 minutes"
  log "  Attempt $i/60..."
  sleep 10
done

# ---------------------------------------------------------------------------
# Step 5 — Set admin password and retrieve API token
# ---------------------------------------------------------------------------
log "Setting Rancher admin password..."

# Rancher requires changing the bootstrap password on first login.
# We use the API to do this programmatically.
FIRST_LOGIN_RESP=$(curl -sk -X POST \
  "${RANCHER_API}/v3-public/localProviders/local?action=login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin"}')

TEMP_TOKEN=$(echo "${FIRST_LOGIN_RESP}" | jq -r '.token')
[[ -z "${TEMP_TOKEN}" || "${TEMP_TOKEN}" == "null" ]] && die "Failed to get initial login token"

# Use the fixed lab admin password (predictable for API/UI use).
ADMIN_PASS="${LAB_ADMIN_PASSWORD}"

curl -sk -X POST \
  "${RANCHER_API}/v3/users?action=changepassword" \
  -H "Authorization: Bearer ${TEMP_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"currentPassword\":\"admin\",\"newPassword\":\"${ADMIN_PASS}\"}"

# Write password to file on geekohive (setup-geekohive reads this at track start)
echo "${ADMIN_PASS}" > "${RANCHER_ADMIN_PASS_FILE}"
chmod 600 "${RANCHER_ADMIN_PASS_FILE}"
log "Admin password set to the lab password; written to ${RANCHER_ADMIN_PASS_FILE}"

# Get a permanent API token
TOKEN_RESP=$(curl -sk -X POST \
  "${RANCHER_API}/v3-public/localProviders/local?action=login" \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"admin\",\"password\":\"${ADMIN_PASS}\"}")

API_TOKEN=$(echo "${TOKEN_RESP}" | jq -r '.token')
[[ -z "${API_TOKEN}" || "${API_TOKEN}" == "null" ]] && die "Failed to authenticate with new password"

# Set the Rancher server URL
# server-url must be reachable by the Harvester cattle-cluster-agent, which sits
# on the same 192.168.122.0/24 network — point it at the NodePort, not :443.
curl -sk -X PUT \
  "${RANCHER_API}/v3/settings/server-url" \
  -H "Authorization: Bearer ${API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"value\":\"${RANCHER_API}\"}"

log "Rancher admin password set and server URL configured."

# ---------------------------------------------------------------------------
# Step 6 — Import the Harvester cluster into Rancher
# ---------------------------------------------------------------------------
log "Importing Harvester cluster into Rancher..."

# Create a provisioned cluster record for Harvester import
CLUSTER_RESP=$(curl -sk -X POST \
  "${RANCHER_API}/v3/clusters" \
  -H "Authorization: Bearer ${API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "cluster",
    "name": "harvester",
    "harvesterConfig": {},
    "annotations": {
      "field.cattle.io/description": "Harvester HCI cluster for SUSE Virt Rodeo"
    }
  }')

CLUSTER_ID=$(echo "${CLUSTER_RESP}" | jq -r '.id')
log "  Cluster record created: ${CLUSTER_ID}"

# Get the registration URL (Harvester kubeconfig import URL)
IMPORT_RESP=$(curl -sk -X POST \
  "${RANCHER_API}/v3/clusters/${CLUSTER_ID}?action=generateKubeconfig" \
  -H "Authorization: Bearer ${API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{}')

IMPORT_URL=$(echo "${IMPORT_RESP}" | jq -r '.config // empty')

# The correct import method for Harvester uses the cattle-cluster-agent manifest.
# Retrieve it and apply on the Harvester cluster.
MANIFEST_URL=$(curl -sk \
  "${RANCHER_API}/v3/clusterregistrationtokens?clusterId=${CLUSTER_ID}" \
  -H "Authorization: Bearer ${API_TOKEN}" | jq -r '.data[0].manifestUrl')

log "  Applying import manifest to Harvester cluster (${HARVESTER_VIP})..."

# We need the Harvester kubeconfig. It's inside harvester1 after install.
# Copy it out via virsh console is not scriptable easily, so we expect it
# to be accessible at a known path after harvester1 has booted and mounted SSH.
HARVESTER_KUBECONFIG="/tmp/harvester-kubeconfig"

if [[ ! -f "${HARVESTER_KUBECONFIG}" ]]; then
  log "  Fetching Harvester kubeconfig from the VIP (rke2.yaml is root-only, so sudo)..."
  ssh ${SSH_OPTS} "${HARVESTER_VM_USER}@${HARVESTER_VIP}" \
    "sudo cat /etc/rancher/rke2/rke2.yaml" > "${HARVESTER_KUBECONFIG}" 2>/dev/null || \
    die "Could not fetch Harvester kubeconfig. Is the cluster up and the host key accepted on the nodes?"

  # Fix the server IP in the kubeconfig to use the VIP
  sed -i "s|127.0.0.1|${HARVESTER_VIP}|g" "${HARVESTER_KUBECONFIG}"
fi

# Persist the Harvester kubeconfig to the path the track expects.
# track_scripts/setup-geekohive does `export KUBECONFIG=/root/.kube/harvester.yaml`
# and waits on `kubectl get nodes`, so this file MUST exist in the baked image.
mkdir -p /root/.kube
cp "${HARVESTER_KUBECONFIG}" /root/.kube/harvester.yaml
chmod 600 /root/.kube/harvester.yaml
log "Harvester kubeconfig saved to /root/.kube/harvester.yaml (API at ${HARVESTER_VIP}:6443)"

# ---------------------------------------------------------------------------
# Patch RKE2 CoreDNS to forward aerogrid.com to the host libvirt dnsmasq.
# Pods inside Harvester use the cluster's own CoreDNS which by default has no
# knowledge of aerogrid.com. A forward zone closes that gap so every pod can
# resolve virtualization/rancher/alpha/bravo/charlie.aerogrid.com.
# ---------------------------------------------------------------------------
LAB_DNS_SERVER="${LAB_DNS_SERVER:-192.168.122.1}"
log "Patching RKE2 CoreDNS: aerogrid.com → ${LAB_DNS_SERVER}..."
if KUBECONFIG="${HARVESTER_KUBECONFIG}" kubectl get cm rke2-coredns-rke2-coredns -n kube-system &>/dev/null; then
  COREDNS_CM="rke2-coredns-rke2-coredns"
elif KUBECONFIG="${HARVESTER_KUBECONFIG}" kubectl get cm coredns -n kube-system &>/dev/null; then
  COREDNS_CM="coredns"
else
  log "  WARNING: CoreDNS ConfigMap not found — pod DNS patch skipped"
  COREDNS_CM=""
fi
if [[ -n "${COREDNS_CM}" ]]; then
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

# Apply the Rancher import manifest on the Harvester cluster
curl -sk "${MANIFEST_URL}" | \
  KUBECONFIG="${HARVESTER_KUBECONFIG}" kubectl apply -f -

log "  Import manifest applied. Waiting for cattle-cluster-agent to connect..."

# Poll Rancher until the cluster shows as Active
for i in $(seq 1 60); do
  STATE=$(curl -sk \
    "${RANCHER_API}/v3/clusters/${CLUSTER_ID}" \
    -H "Authorization: Bearer ${API_TOKEN}" | jq -r '.state // "unknown"')

  log "  Cluster state: ${STATE} (attempt $i/60)"
  [[ "${STATE}" == "active" ]] && break
  [[ $i -eq 60 ]] && log "WARNING: Cluster did not reach Active state in time. Check Rancher UI."
  sleep 30
done

# Set the Harvester dashboard admin password to the lab password. Harvester's
# embedded Rancher ships a bootstrap admin/admin and forces a password set on
# first login; do that non-interactively (best-effort).
log "Setting the Harvester dashboard admin password..."
HV_BOOTSTRAP_TOKEN=$(curl -sk -X POST \
  "https://${HARVESTER_VIP}/v3-public/localProviders/local?action=login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin"}' | jq -r '.token // empty')
if [[ -n "${HV_BOOTSTRAP_TOKEN}" ]]; then
  curl -sk -X POST \
    "https://${HARVESTER_VIP}/v3/users?action=changepassword" \
    -H "Authorization: Bearer ${HV_BOOTSTRAP_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"currentPassword\":\"admin\",\"newPassword\":\"${LAB_ADMIN_PASSWORD}\"}" >/dev/null \
    && log "  Harvester admin password set to the lab password."
else
  log "  Bootstrap admin/admin login returned no token — Harvester admin password may already be set."
fi

# Save the Harvester token for later use (e.g. image upload in assignment.md)
HARVESTER_TOKEN=$(curl -sk -X POST \
  "https://${HARVESTER_VIP}/v3-public/localProviders/local?action=login" \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"admin\",\"password\":\"${LAB_ADMIN_PASSWORD}\"}" | jq -r '.token // empty')

[[ -n "${HARVESTER_TOKEN}" ]] && echo "${HARVESTER_TOKEN}" > /root/harvester-token && \
  chmod 600 /root/harvester-token && log "Harvester API token saved to /root/harvester-token"

# ---------------------------------------------------------------------------
# Step 7 — Eject installer ISOs so the saved image boots from disk only
# Keep this block in sync with the equivalent block in track_scripts/setup-geekohive
# ---------------------------------------------------------------------------
eject_cdrom() {
  local domain="$1" dev="$2"
  local err
  err=$(virsh change-media "$domain" "$dev" --eject --live --config 2>&1) || {
    echo "$err" | grep -qiE "no media|not a cdrom|No such file" \
      || log "WARNING: eject ${domain}:${dev} -- ${err}"
  }
}

log "Ejecting installer ISOs from Harvester VMs..."
for node in harvester1 harvester2 harvester3; do
  for cdrom in sda sdb; do
    eject_cdrom "$node" "$cdrom"
  done
  log "  ${node}: CDROMs ejected"
done

log ""
log "Setup complete. Summary:"
log "  Rancher URL   : ${RANCHER_API}  (NodePort; UI also via cloud-client tab)"
log "  Admin password: $(cat ${RANCHER_ADMIN_PASS_FILE})"
log "  Cluster ID    : ${CLUSTER_ID}"
log ""
log "Next: verify cluster in Rancher UI, upload Leap 16 image, then shut off all VMs."

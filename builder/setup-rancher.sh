#!/usr/bin/env bash
# Wrapper — canonical implementation is deployer/lib/setup-rancher.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${HERE}/../deployer/deploy.env"
if [[ -f "${ENV_FILE}" ]]; then
  set -a; source "${ENV_FILE}"; set +a
fi
exec env \
  RANCHER_VM_IP="${RANCHER_IP:-192.168.122.9}" \
  RANCHER_VERSION="${RANCHER_VERSION:-2.14.1}" \
  K3S_VERSION="${K3S_VERSION:-v1.32.4+k3s1}" \
  HARVESTER_VIP="${HARVESTER_VIP:-192.168.122.10}" \
  CERT_MANAGER_VERSION="${CERT_MANAGER_VERSION:-v1.16.2}" \
  LAB_ADMIN_PASSWORD="${LAB_ADMIN_PASSWORD:-Foobar12345\$}" \
  RANCHER_NODEPORT="${RANCHER_NODEPORT:-30002}" \
  SSH_KEY="${SSH_KEY:-/root/.ssh/id_ed25519}" \
  "${HERE}/../deployer/lib/setup-rancher.sh"
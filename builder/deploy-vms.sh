#!/usr/bin/env bash
# Wrapper — canonical implementation is deployer/lib/start-vms.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec env HARVESTER_VIP="${HARVESTER_VIP:-192.168.122.10}" \
  MAX_WAIT="${MAX_WAIT:-3600}" \
  "${HERE}/../deployer/lib/start-vms.sh"
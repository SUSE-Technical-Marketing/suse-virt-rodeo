#!/usr/bin/env bash
# deploy-vms.sh — Deploy nested KVM VMs for the suse-virt-rodeo-180 image build.
#
# What this script does:
#   1. Adds static DHCP MAC reservations to the default (virbr0) libvirt network
#   2. Creates qcow2 disk images (preallocation=metadata) for all VMs
#   3. Downloads the Harvester 1.8.0 ISO
#   4. Generates Harvester unattended config ISOs (one per node)
#   5. Defines each KVM VM with correct CPU/RAM/NIC/disk settings
#   6. Starts harvester1, waits for it to respond, then starts harvester2 and harvester3
#
# Each Harvester node gets two NICs, both on virbr0 (192.168.122.0/24):
#   eth0 (02:00:00:0D:62:Ex) — management NIC, static IP configured by Harvester installer
#   eth1 (02:00:00:0D:64:Ex) — VM traffic NIC, left unmanaged by OS, used by Harvester
#                              Kube-OVN as the OVN bridge uplink for the "vms" cluster network
#
# Both NICs on virbr0 ensures VM LoadBalancer IPs (192.168.122.200-220) are directly
# reachable from geekohive and cloud-client without extra routing rules.
#
# Run as root on geekohive after the Ansible role has completed.
set -euo pipefail

# ---------------------------------------------------------------------------
# Paths and versions
# ---------------------------------------------------------------------------
IMAGE_DIR="/var/lib/libvirt/images"
CONFIG_DIR="/root/harvester-configs"
HARVESTER_VERSION="1.8.0"
HARVESTER_ISO_URL="https://github.com/harvester/harvester/releases/download/v${HARVESTER_VERSION}/harvester-v${HARVESTER_VERSION}-amd64.iso"
HARVESTER_ISO="${IMAGE_DIR}/harvester-v${HARVESTER_VERSION}-amd64.iso"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OVMF_CODE="/usr/share/qemu/ovmf-x86_64-code.bin"
OVMF_VARS_TEMPLATE="/usr/share/qemu/ovmf-x86_64-vars.bin"

# ---------------------------------------------------------------------------
# Helper
# ---------------------------------------------------------------------------
log() { echo "[deploy-vms] $*"; }
die() { echo "[deploy-vms] ERROR: $*" >&2; exit 1; }

require_root() {
  [[ $EUID -eq 0 ]] || die "Must run as root"
}

require_cmd() {
  for cmd in "$@"; do
    command -v "$cmd" &>/dev/null || die "Required command not found: $cmd"
  done
}

require_root
require_cmd virsh qemu-img genisoimage curl xmlstarlet

mkdir -p "${IMAGE_DIR}" "${CONFIG_DIR}"

# ---------------------------------------------------------------------------
# Step 1 — Add static DHCP reservations to the default (virbr0) network
# ---------------------------------------------------------------------------
log "Updating default network with static DHCP reservations..."

# Dump current XML, inject host entries, re-define network
VIRBR0_XML=$(virsh net-dumpxml default)

# Remove any existing host entries first (idempotency)
VIRBR0_CLEAN=$(echo "${VIRBR0_XML}" | xmlstarlet ed \
  -d "//dhcp/host[@mac='02:00:00:0D:62:E1']" \
  -d "//dhcp/host[@mac='02:00:00:0D:62:E2']" \
  -d "//dhcp/host[@mac='02:00:00:0D:62:E3']" \
  -d "//dhcp/host[@mac='02:00:00:0D:62:E9']")

# Insert new host entries inside the <dhcp> element
VIRBR0_UPDATED=$(echo "${VIRBR0_CLEAN}" | xmlstarlet ed \
  -s "//dhcp" -t elem -n "host" -v "" \
  -i "//dhcp/host[last()]" -t attr -n "mac"  -v "02:00:00:0D:62:E9" \
  -i "//dhcp/host[last()]" -t attr -n "name" -v "rancher" \
  -i "//dhcp/host[last()]" -t attr -n "ip"   -v "192.168.122.9" \
  -s "//dhcp" -t elem -n "host" -v "" \
  -i "//dhcp/host[last()]" -t attr -n "mac"  -v "02:00:00:0D:62:E1" \
  -i "//dhcp/host[last()]" -t attr -n "name" -v "harvester1" \
  -i "//dhcp/host[last()]" -t attr -n "ip"   -v "192.168.122.11" \
  -s "//dhcp" -t elem -n "host" -v "" \
  -i "//dhcp/host[last()]" -t attr -n "mac"  -v "02:00:00:0D:62:E2" \
  -i "//dhcp/host[last()]" -t attr -n "name" -v "harvester2" \
  -i "//dhcp/host[last()]" -t attr -n "ip"   -v "192.168.122.12" \
  -s "//dhcp" -t elem -n "host" -v "" \
  -i "//dhcp/host[last()]" -t attr -n "mac"  -v "02:00:00:0D:62:E3" \
  -i "//dhcp/host[last()]" -t attr -n "name" -v "harvester3" \
  -i "//dhcp/host[last()]" -t attr -n "ip"   -v "192.168.122.13")

TMP_NET=$(mktemp /tmp/virbr0-XXXX.xml)
echo "${VIRBR0_UPDATED}" > "${TMP_NET}"
virsh net-define "${TMP_NET}"
rm -f "${TMP_NET}"

# Apply DHCP changes without full restart (avoids disrupting existing connections)
virsh net-update default add ip-dhcp-host \
  "<host mac='02:00:00:0D:62:E1' name='harvester1' ip='192.168.122.11'/>" \
  --live --config 2>/dev/null || true
virsh net-update default add ip-dhcp-host \
  "<host mac='02:00:00:0D:62:E2' name='harvester2' ip='192.168.122.12'/>" \
  --live --config 2>/dev/null || true
virsh net-update default add ip-dhcp-host \
  "<host mac='02:00:00:0D:62:E3' name='harvester3' ip='192.168.122.13'/>" \
  --live --config 2>/dev/null || true
virsh net-update default add ip-dhcp-host \
  "<host mac='02:00:00:0D:62:E9' name='rancher' ip='192.168.122.9'/>" \
  --live --config 2>/dev/null || true

log "Default network updated."

# ---------------------------------------------------------------------------
# Step 2 — Create qcow2 disk images
# ---------------------------------------------------------------------------
log "Creating disk images..."

create_disk() {
  local path="$1" size="$2"
  if [[ -f "${path}" ]]; then
    log "  Disk ${path} already exists, skipping."
  else
    qemu-img create -f qcow2 -o preallocation=metadata "${path}" "${size}"
    log "  Created ${path} (${size})"
  fi
}

# Harvester nodes: single 270 GB disk — OS partitions (~173 GB) + Longhorn (~97 GB)
for node in harvester1 harvester2 harvester3; do
  create_disk "${IMAGE_DIR}/${node}-vda.qcow2" "270G"
done

log "Disk images ready."

# ---------------------------------------------------------------------------
# Step 3b — Download Leap 16 cloud image and prepare Rancher VM disk
# ---------------------------------------------------------------------------
# The Rancher VM needs a bootable OS. We use openSUSE Leap 16 cloud image as
# the base, resize it to 60 GB, and inject cloud-init config via a seed ISO.

LEAP16_URL="https://download.opensuse.org/distribution/leap/16.0/appliances/openSUSE-Leap-16.0-Minimal-VM.x86_64-Cloud.qcow2"
LEAP16_IMG="${IMAGE_DIR}/openSUSE-Leap-16.0-Cloud.qcow2"

if [[ -f "${LEAP16_IMG}" ]]; then
  log "Leap 16 cloud image already present, skipping download."
else
  log "Downloading openSUSE Leap 16 cloud image (~500 MB)..."
  curl -L --progress-bar -o "${LEAP16_IMG}" "${LEAP16_URL}"
  log "Leap 16 image downloaded."
fi

# Build rancher disk from cloud image (convert + resize to 60 GB)
RANCHER_DISK="${IMAGE_DIR}/rancher-vda.qcow2"
if [[ -f "${RANCHER_DISK}" ]]; then
  log "Rancher disk already exists, skipping."
else
  log "Creating Rancher VM disk from Leap 16 cloud image..."
  qemu-img convert -f qcow2 -O qcow2 -o preallocation=metadata "${LEAP16_IMG}" "${RANCHER_DISK}"
  qemu-img resize "${RANCHER_DISK}" 60G
  log "Rancher disk ready (60 GB)."
fi

# Generate SSH key for geekohive → rancher VM access (used by setup-rancher.sh)
if [[ ! -f /root/.ssh/id_rsa ]]; then
  ssh-keygen -t rsa -b 2048 -f /root/.ssh/id_rsa -N "" -q
  log "SSH key generated at /root/.ssh/id_rsa"
fi
GEEKOHIVE_PUBKEY=$(cat /root/.ssh/id_rsa.pub)

# Create cloud-init seed ISO for the Rancher VM
RANCHER_CI_ISO="${IMAGE_DIR}/rancher-cloud-init.iso"
if [[ -f "${RANCHER_CI_ISO}" ]]; then
  log "Rancher cloud-init ISO already exists, skipping."
else
  log "Creating Rancher cloud-init seed ISO..."
  RANCHER_CI_DIR=$(mktemp -d)

  cat > "${RANCHER_CI_DIR}/meta-data" <<EOF
instance-id: rancher-vm
local-hostname: rancher
EOF

  cat > "${RANCHER_CI_DIR}/user-data" <<EOF
#cloud-config
hostname: rancher
ssh_authorized_keys:
  - ${GEEKOHIVE_PUBKEY}
chpasswd:
  list: |
    root:RancherRodeo2024!
  expire: false
ssh_pwauth: true
EOF

  cat > "${RANCHER_CI_DIR}/network-config" <<EOF
version: 2
ethernets:
  eth0:
    addresses:
      - 192.168.122.9/24
    gateway4: 192.168.122.1
    nameservers:
      addresses: [8.8.8.8, 1.1.1.1]
EOF

  genisoimage \
    -output "${RANCHER_CI_ISO}" \
    -volid cidata \
    -joliet -rock \
    "${RANCHER_CI_DIR}/meta-data" \
    "${RANCHER_CI_DIR}/user-data" \
    "${RANCHER_CI_DIR}/network-config" 2>/dev/null

  rm -rf "${RANCHER_CI_DIR}"
  log "Rancher cloud-init ISO ready."
fi

# ---------------------------------------------------------------------------
# Step 3 — Download Harvester 1.8.0 ISO
# ---------------------------------------------------------------------------
if [[ -f "${HARVESTER_ISO}" ]]; then
  log "Harvester ISO already present at ${HARVESTER_ISO}, skipping download."
else
  log "Downloading Harvester ${HARVESTER_VERSION} ISO (~1.5 GB)..."
  curl -L --progress-bar -o "${HARVESTER_ISO}" "${HARVESTER_ISO_URL}"
  log "ISO downloaded."
fi

# ---------------------------------------------------------------------------
# Step 4 — Generate Harvester config seed ISOs (one per node)
# ---------------------------------------------------------------------------
# Harvester reads its unattended config from a CDROM labelled HarvesterConfig.
# We create a small ISO with the config YAML at /harvester/config.yaml.

log "Generating Harvester config seed ISOs..."

build_config_iso() {
  local node="$1"
  local config_src="${SCRIPT_DIR}/harvester-config-${node}.yaml"
  local iso_path="${IMAGE_DIR}/harvester-config-${node}.iso"

  [[ -f "${config_src}" ]] || die "Config source not found: ${config_src}"

  if [[ -f "${iso_path}" ]]; then
    log "  Config ISO for ${node} already exists, skipping."
    return
  fi

  local tmpdir
  tmpdir=$(mktemp -d)
  mkdir -p "${tmpdir}/harvester"
  cp "${config_src}" "${tmpdir}/harvester/config.yaml"

  genisoimage \
    -output "${iso_path}" \
    -volid HarvesterConfig \
    -joliet -rock \
    "${tmpdir}" 2>/dev/null

  rm -rf "${tmpdir}"
  log "  Created ${iso_path}"
}

build_config_iso node1
build_config_iso node2
build_config_iso node3

log "Config ISOs ready."

# ---------------------------------------------------------------------------
# Step 5 — Copy OVMF vars templates (writable per-VM UEFI variable store)
# ---------------------------------------------------------------------------
log "Setting up OVMF VARS files..."

for node in harvester1 harvester2 harvester3 rancher; do
  vars="${IMAGE_DIR}/${node}-ovmf-vars.fd"
  if [[ ! -f "${vars}" ]]; then
    cp "${OVMF_VARS_TEMPLATE}" "${vars}"
    log "  Copied OVMF vars for ${node}"
  fi
done

# ---------------------------------------------------------------------------
# Step 6 — Define KVM VMs
# ---------------------------------------------------------------------------
log "Defining KVM VMs..."

define_vm() {
  local name="$1"
  local xml="$2"
  if virsh dominfo "${name}" &>/dev/null; then
    log "  VM ${name} already defined, skipping."
  else
    echo "${xml}" | virsh define /dev/stdin
    log "  Defined VM: ${name}"
  fi
}

# -- harvester1 -------------------------------------------------------------
define_vm harvester1 "$(cat <<HVXML
<domain type='kvm'>
  <name>harvester1</name>
  <memory unit='MiB'>24576</memory>
  <vcpu placement='static'>8</vcpu>
  <cpu mode='host-passthrough' check='none' migratable='on'/>
  <os firmware='efi'>
    <type arch='x86_64' machine='q35'>hvm</type>
    <loader readonly='yes' type='pflash'>${OVMF_CODE}</loader>
    <nvram template='${OVMF_VARS_TEMPLATE}'>${IMAGE_DIR}/harvester1-ovmf-vars.fd</nvram>
    <boot dev='cdrom'/>
    <boot dev='hd'/>
  </os>
  <features>
    <acpi/>
    <apic/>
    <smm state='on'/>
  </features>
  <clock offset='utc'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <!-- OS disk — Longhorn uses /var/lib/longhorn on this disk -->
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='none' io='native'/>
      <source file='${IMAGE_DIR}/harvester1-vda.qcow2'/>
      <target dev='vda' bus='virtio'/>
      <boot order='2'/>
    </disk>
    <!-- Harvester installer ISO -->
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='${HARVESTER_ISO}'/>
      <target dev='sda' bus='sata'/>
      <readonly/>
      <boot order='1'/>
    </disk>
    <!-- Harvester config seed ISO -->
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='${IMAGE_DIR}/harvester-config-node1.iso'/>
      <target dev='sdb' bus='sata'/>
      <readonly/>
    </disk>
    <!-- Management NIC (eth0) — static IP 192.168.122.11 configured by Harvester installer -->
    <interface type='network'>
      <mac address='02:00:00:0D:62:E1'/>
      <source network='default'/>
      <model type='e1000'/>
    </interface>
    <!-- VM traffic NIC (eth1) — no OS IP; used by Kube-OVN as OVN bridge uplink -->
    <interface type='network'>
      <mac address='02:00:00:0D:64:E1'/>
      <source network='default'/>
      <model type='e1000'/>
    </interface>
    <serial type='pty'>
      <target type='isa-serial' port='0'/>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
    <graphics type='vnc' port='-1' autoport='yes' listen='127.0.0.1'>
      <listen type='address' address='127.0.0.1'/>
    </graphics>
    <video>
      <model type='vga' vram='16384' heads='1'/>
    </video>
    <memballoon model='virtio'/>
    <rng model='virtio'>
      <backend model='random'>/dev/urandom</backend>
    </rng>
  </devices>
</domain>
HVXML
)"

# -- harvester2 -------------------------------------------------------------
define_vm harvester2 "$(cat <<HVXML
<domain type='kvm'>
  <name>harvester2</name>
  <memory unit='MiB'>24576</memory>
  <vcpu placement='static'>8</vcpu>
  <cpu mode='host-passthrough' check='none' migratable='on'/>
  <os firmware='efi'>
    <type arch='x86_64' machine='q35'>hvm</type>
    <loader readonly='yes' type='pflash'>${OVMF_CODE}</loader>
    <nvram template='${OVMF_VARS_TEMPLATE}'>${IMAGE_DIR}/harvester2-ovmf-vars.fd</nvram>
    <boot dev='cdrom'/>
    <boot dev='hd'/>
  </os>
  <features>
    <acpi/>
    <apic/>
    <smm state='on'/>
  </features>
  <clock offset='utc'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='none' io='native'/>
      <source file='${IMAGE_DIR}/harvester2-vda.qcow2'/>
      <target dev='vda' bus='virtio'/>
      <boot order='2'/>
    </disk>
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='${HARVESTER_ISO}'/>
      <target dev='sda' bus='sata'/>
      <readonly/>
      <boot order='1'/>
    </disk>
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='${IMAGE_DIR}/harvester-config-node2.iso'/>
      <target dev='sdb' bus='sata'/>
      <readonly/>
    </disk>
    <!-- Management NIC (eth0) — static IP 192.168.122.12 configured by Harvester installer -->
    <interface type='network'>
      <mac address='02:00:00:0D:62:E2'/>
      <source network='default'/>
      <model type='e1000'/>
    </interface>
    <!-- VM traffic NIC (eth1) — no OS IP; used by Kube-OVN as OVN bridge uplink -->
    <interface type='network'>
      <mac address='02:00:00:0D:64:E2'/>
      <source network='default'/>
      <model type='e1000'/>
    </interface>
    <serial type='pty'>
      <target type='isa-serial' port='0'/>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
    <graphics type='vnc' port='-1' autoport='yes' listen='127.0.0.1'>
      <listen type='address' address='127.0.0.1'/>
    </graphics>
    <video>
      <model type='vga' vram='16384' heads='1'/>
    </video>
    <memballoon model='virtio'/>
    <rng model='virtio'>
      <backend model='random'>/dev/urandom</backend>
    </rng>
  </devices>
</domain>
HVXML
)"

# -- harvester3 -------------------------------------------------------------
define_vm harvester3 "$(cat <<HVXML
<domain type='kvm'>
  <name>harvester3</name>
  <memory unit='MiB'>24576</memory>
  <vcpu placement='static'>8</vcpu>
  <cpu mode='host-passthrough' check='none' migratable='on'/>
  <os firmware='efi'>
    <type arch='x86_64' machine='q35'>hvm</type>
    <loader readonly='yes' type='pflash'>${OVMF_CODE}</loader>
    <nvram template='${OVMF_VARS_TEMPLATE}'>${IMAGE_DIR}/harvester3-ovmf-vars.fd</nvram>
    <boot dev='cdrom'/>
    <boot dev='hd'/>
  </os>
  <features>
    <acpi/>
    <apic/>
    <smm state='on'/>
  </features>
  <clock offset='utc'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='none' io='native'/>
      <source file='${IMAGE_DIR}/harvester3-vda.qcow2'/>
      <target dev='vda' bus='virtio'/>
      <boot order='2'/>
    </disk>
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='${HARVESTER_ISO}'/>
      <target dev='sda' bus='sata'/>
      <readonly/>
      <boot order='1'/>
    </disk>
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='${IMAGE_DIR}/harvester-config-node3.iso'/>
      <target dev='sdb' bus='sata'/>
      <readonly/>
    </disk>
    <!-- Management NIC (eth0) — static IP 192.168.122.13 configured by Harvester installer -->
    <interface type='network'>
      <mac address='02:00:00:0D:62:E3'/>
      <source network='default'/>
      <model type='e1000'/>
    </interface>
    <!-- VM traffic NIC (eth1) — no OS IP; used by Kube-OVN as OVN bridge uplink -->
    <interface type='network'>
      <mac address='02:00:00:0D:64:E3'/>
      <source network='default'/>
      <model type='e1000'/>
    </interface>
    <serial type='pty'>
      <target type='isa-serial' port='0'/>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
    <graphics type='vnc' port='-1' autoport='yes' listen='127.0.0.1'>
      <listen type='address' address='127.0.0.1'/>
    </graphics>
    <video>
      <model type='vga' vram='16384' heads='1'/>
    </video>
    <memballoon model='virtio'/>
    <rng model='virtio'>
      <backend model='random'>/dev/urandom</backend>
    </rng>
  </devices>
</domain>
HVXML
)"

# -- rancher ----------------------------------------------------------------
define_vm rancher "$(cat <<RXML
<domain type='kvm'>
  <name>rancher</name>
  <memory unit='MiB'>16384</memory>
  <vcpu placement='static'>4</vcpu>
  <cpu mode='host-passthrough' check='none' migratable='on'/>
  <os>
    <type arch='x86_64' machine='q35'>hvm</type>
    <boot dev='hd'/>
  </os>
  <features>
    <acpi/>
    <apic/>
  </features>
  <clock offset='utc'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <!-- OS disk — Leap 16 cloud image, resized to 60 GB -->
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='none' io='native'/>
      <source file='${IMAGE_DIR}/rancher-vda.qcow2'/>
      <target dev='vda' bus='virtio'/>
      <boot order='1'/>
    </disk>
    <!-- cloud-init seed ISO — provides network config + SSH key on first boot -->
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='${IMAGE_DIR}/rancher-cloud-init.iso'/>
      <target dev='sda' bus='sata'/>
      <readonly/>
    </disk>
    <!-- Management NIC only — rancher does not need a VM traffic NIC -->
    <interface type='network'>
      <mac address='02:00:00:0D:62:E9'/>
      <source network='default'/>
      <model type='virtio'/>
    </interface>
    <serial type='pty'>
      <target type='isa-serial' port='0'/>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
    <graphics type='vnc' port='-1' autoport='yes' listen='127.0.0.1'>
      <listen type='address' address='127.0.0.1'/>
    </graphics>
    <video>
      <model type='vga' vram='16384' heads='1'/>
    </video>
    <memballoon model='virtio'/>
    <rng model='virtio'>
      <backend model='random'>/dev/urandom</backend>
    </rng>
  </devices>
</domain>
RXML
)"

log "All VMs defined."

# ---------------------------------------------------------------------------
# Step 7 — Start harvester1, wait for API, then start harvester2 and harvester3
# ---------------------------------------------------------------------------
log "Starting harvester1 (cluster bootstrap node)..."
virsh start harvester1

log "Waiting for Harvester API on 192.168.122.11:6443 (this takes 20-40 minutes)..."
WAIT_SECONDS=0
MAX_WAIT=3600  # 60 minutes hard cap

while true; do
  if curl -sk --max-time 5 https://192.168.122.11:6443 2>&1 | grep -qE "Unauthorized|apiVersion|401"; then
    log "Harvester API is responding."
    break
  fi

  WAIT_SECONDS=$((WAIT_SECONDS + 30))
  if [[ ${WAIT_SECONDS} -ge ${MAX_WAIT} ]]; then
    die "Timed out waiting for Harvester API after ${MAX_WAIT}s. Check harvester1 console: virsh console harvester1"
  fi

  log "  ...still waiting (${WAIT_SECONDS}s elapsed)"
  sleep 30
done

log "Starting harvester2..."
virsh start harvester2

# Give harvester2 a head start before starting harvester3 to avoid join race conditions
log "Waiting 60 seconds before starting harvester3..."
sleep 60

log "Starting harvester3..."
virsh start harvester3

log ""
log "All VMs started. Summary:"
virsh list --all

log ""
log "Next steps:"
log "  1. Monitor join progress: virsh console harvester2  (Ctrl+] to detach)"
log "  2. When all 3 nodes are Ready, run: ./setup-rancher.sh"
log "  3. Verify cluster: kubectl get nodes (from inside harvester1 console)"

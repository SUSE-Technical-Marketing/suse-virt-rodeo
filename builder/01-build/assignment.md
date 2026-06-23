---
slug: build
id: xf3qowwvu7dv
type: challenge
title: Build the suse-virt-rodeo-180 image
teaser: Build the custom image from scratch — install rodeo-cli, deploy the nested
  Harvester cluster and Rancher, then snapshot geekohive.
tabs:
- id: heyxefb5qwjv
  title: geekohive
  type: terminal
  hostname: geekohive
  cmd: su - root
difficulty: advanced
timelimit: 21600
enhanced_loading: null
---

# Build the suse-virt-rodeo-180 image

This challenge builds the custom Instruqt image using rodeo-cli, which replaces the
old manual bash-script flow. When done, you snapshot `geekohive` as
`suse/suse-virt-rodeo-180`.

Expected total time: 2-3 hours (most of it is unattended Harvester installation).

---

## Step 0 — Confirm resources and nested virtualisation

The build needs roughly **32 vCPU, 64 GB RAM, and a ~950 GB disk**. Guests take
28 vCPU and 56 GiB RAM (3×16 GiB Harvester + 8 GiB Rancher). Disks are thin-provisioned:
~870 GB virtual, ~300-350 GB actually used.

```bash
free -g                                       # expect >= 64 GB total
nproc                                         # expect 32
df -h /var/lib/libvirt/images                 # expect ~950 GB available
cat /sys/module/kvm_intel/parameters/nested   # expect Y
```

---

## Step 1 — Install rodeo-cli

SLES 16 enforces PEP 668 (externally-managed Python), so install into a venv:

```bash
zypper install -y python3-pip python3-venv git
python3 -m venv /opt/rodeo-venv
/opt/rodeo-venv/bin/pip install git+https://github.com/avaleror/rodeo-cli.git@v0.10.1
ln -sf /opt/rodeo-venv/bin/rodeo /usr/local/bin/rodeo
```

Verify:

```bash
rodeo --version
```

---

## Step 2 — Install system dependencies

rodeo-cli's `kvm_host` Ansible phase handles KVM/libvirt packages, but Ansible itself
must be present before the deploy starts:

```bash
rodeo install-deps
```

This installs `ansible`, the required Ansible collections, `kubectl`, and other host
prerequisites via zypper. It does NOT start any VMs.

---

## Step 3 — Initialise the lab

Create a lab directory with the `harvester` profile. The profile already sets
`deployment_target: instruqt`, so the `finalise` phase (VM autostart) is automatically
skipped until after the snapshot.

```bash
mkdir -p /root/rodeo-lab
rodeo init --profile harvester --dir /root/rodeo-lab
```

The admin password is in `~/.rodeo/secrets.yaml`. Note it for later:

```bash
grep harvester_admin_password ~/.rodeo/secrets.yaml
```

---

## Step 4 — Deploy the lab

This single command runs all phases: `kvm_host` (packages, libvirt, firewall/DNAT),
`vms` (disks, ISOs, cloud-init, VM definitions), `pxe_server` (iPXE UEFI boot),
`cluster` (starts VMs, waits for Harvester VIP and all 3 nodes Ready — up to 90 min),
and `rancher` (K3s, Helm, Rancher Prime, cacerts sync, UI Extension, Harvester import).
The `finalise` phase is skipped automatically because `deployment_target: instruqt`.

```bash
rodeo deploy --config-dir /root/rodeo-lab
```

To monitor Harvester install progress in a second terminal:

```bash
tail -f /var/log/libvirt/qemu/harvester1_serial.log
```

When complete, the success screen shows URLs and credentials.

---

## Step 5 — Verify the import

Confirm the Harvester cluster is Active in Rancher:

```bash
PASS=$(cat /root/rancher-password)
TOKEN=$(curl -sk -XPOST https://192.168.122.9:30002/v3-public/localProviders/local?action=login \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"admin\",\"password\":\"$PASS\"}" | python3 -c "import sys,json; print(json.load(sys.stdin)['token'])")
curl -sk -H "Authorization: Bearer $TOKEN" https://192.168.122.9:30002/v3/clusters \
  | python3 -c "import sys,json; [print(c['name'], c['state']) for c in json.load(sys.stdin)['data']]"
```

Expected output: `harvester active` and `local active`.

---

## Step 6 — Disable Longhorn V2 data engine

SPDK/V2 does not work on virtio-blk in nested KVM. In the Harvester UI
(`https://192.168.122.10`), go to **Advanced → Settings → longhorn-v2-data-engine**
and confirm the value is `false`. It should already be off by default in Harvester 1.8.0.

---

## Step 7 — Load the openSUSE Leap 16 KVM image

Pre-load the Leap 16 guest image so it is ready for lab use. The `kvm-and-xen`
variant has virtio drivers built in and does not need a cloud metadata endpoint.
The image **name must be `leap16`** — all challenges reference `default/leap16`.

```bash
LEAP16_URL="https://download.opensuse.org/distribution/leap/16.0/appliances/Leap-16.0-Minimal-VM.x86_64-kvm-and-xen.qcow2"
HVTOKEN=$(cat /root/harvester-token)
curl -sk -X POST \
  -H "Authorization: Bearer $HVTOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"metadata\":{\"name\":\"leap16\",\"namespace\":\"default\"},
       \"spec\":{\"displayName\":\"openSUSE Leap 16\",\"url\":\"${LEAP16_URL}\",
                 \"sourceType\":\"download\"}}" \
  https://192.168.122.10/v1/harvesterhci.io.virtualmachineimages
```

Poll until `active`:

```bash
watch -n 10 "curl -sk -H 'Authorization: Bearer $(cat /root/harvester-token)' \
  https://192.168.122.10/v1/harvesterhci.io.virtualmachineimages \
  | python3 -c \"import sys,json; [print(i['metadata']['name'], i.get('status',{}).get('progress','?')) for i in json.load(sys.stdin).get('items',[])]\" "
```

---

## Step 8 — Stop VMs cleanly before snapshot

```bash
rodeo stop --yes --all --config-dir /root/rodeo-lab
```

Confirm all VMs are off:

```bash
virsh list --all
```

All four VMs must show `shut off` before saving the image.

---

## Step 9 — Save the Instruqt image

From the Instruqt web console:

1. Go to the builder track sandbox.
2. Select the `geekohive` VM.
3. Click **Save as image**.
4. Set the image name to `suse-virt-rodeo-180`.
5. Set the owner to `suse`.
6. Wait for the snapshot to complete (20-30 minutes).

Once saved, the image is available as `suse/suse-virt-rodeo-180` for the main
rodeo track (`config.yml` already references this slug).

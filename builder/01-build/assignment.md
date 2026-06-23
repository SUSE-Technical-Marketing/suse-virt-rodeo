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

Deploys 3-node Harvester HCI + Rancher Prime on geekohive, loads the Leap 16 guest
image, and stops all VMs ready for snapshot.

Expected total time: **2-3 hours** (mostly unattended Harvester installation).

Host requirements: 32 vCPU, 64 GB RAM, ~950 GB disk, nested KVM enabled.

---

## 1. Install rodeo-cli

```bash
curl -fsSL https://raw.githubusercontent.com/avaleror/rodeo-cli/main/install.sh | bash
```

## 2. Install host dependencies

```bash
rodeo install-deps
```

## 3. Clean any previous state

```bash
for vm in harvester1 harvester2 harvester3 rancher; do
  virsh destroy   "$vm" 2>/dev/null || true
  virsh undefine --nvram "$vm" 2>/dev/null || true
done
virsh net-destroy  default 2>/dev/null || true
virsh net-undefine default 2>/dev/null || true

rm -f  /var/lib/libvirt/images/harvester*.qcow2      \
       /var/lib/libvirt/images/harvester*_vars.bin   \
       /var/lib/libvirt/images/rancher*.qcow2        \
       /var/lib/libvirt/images/Leap-*.qcow2          \
       /var/lib/libvirt/images/harvester-config-*.iso \
       /var/lib/libvirt/images/harvester-v*.iso
rm -rf /srv/harvester-pxe/ ~/.rodeo/ /root/rodeo-lab /opt/rodeo-cli
rm -f  /usr/local/bin/rodeo
```

## 4. Init the lab

```bash
mkdir -p /root/rodeo-lab
rodeo init --profile harvester --dir /root/rodeo-lab
```

## 5. Deploy (2-3 h)

```bash
rodeo deploy --no-tui --config-dir /root/rodeo-lab
```

To watch Harvester install progress in a second terminal:

```bash
tail -f /var/log/libvirt/qemu/harvester1_serial.log
```

## 6. Load the Leap 16 image

Once deploy finishes and Harvester shows **active** in Rancher:

```bash
HVTOKEN=$(cat /root/harvester-token)

curl -sk -X POST \
  -H "Authorization: Bearer $HVTOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "metadata": {"name": "leap16", "namespace": "default"},
    "spec": {
      "displayName": "openSUSE Leap 16",
      "url": "https://download.opensuse.org/distribution/leap/16.0/appliances/Leap-16.0-Minimal-VM.x86_64-kvm-and-xen.qcow2",
      "sourceType": "download"
    }
  }' \
  https://192.168.122.10/v1/harvesterhci.io.virtualmachineimages

# Wait for the image to be active (check Harvester UI or poll the API).
```

## 7. Stop all VMs

```bash
rodeo stop --yes --all --config-dir /root/rodeo-lab
virsh list --all   # all must show 'shut off'
```

---

## Save the Instruqt image

From the Instruqt web console:

1. Go to the builder track sandbox.
2. Select the `geekohive` VM.
3. Click **Save as image**.
4. Set the image name to `suse-virt-rodeo-180`.
5. Set the owner to `suse`.
6. Wait for the snapshot to complete (20-30 minutes).

Once saved, the image is available as `suse/suse-virt-rodeo-180` for the main
rodeo track (`config.yml` already references this slug).

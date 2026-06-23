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

Runs rodeo-cli to deploy 3-node Harvester HCI + Rancher Prime on geekohive, load
the Leap 16 guest image, and stop all VMs ready for snapshot.

Expected total time: **2-3 hours** (mostly unattended Harvester installation).

Host requirements: 32 vCPU, 64 GB RAM, ~950 GB disk, nested KVM enabled.

---

## Run the build script

The entire build is automated by a single script in rodeo-cli. Run it as root:

```bash
curl -fsSL https://raw.githubusercontent.com/avaleror/rodeo-cli/main/scripts/build-instruqt-image.sh | bash
```

The script handles everything in sequence:
- Cleans any previous state (VMs, disks, networks, rodeo state)
- Installs rodeo-cli into a venv (SLES 16 / PEP 668 safe)
- Installs host dependencies (ansible, kubectl, collections)
- Initialises the lab with the `harvester` profile (`deployment_target: instruqt` — `finalise` skipped pre-snapshot)
- Deploys: `kvm_host` → `vms` → `pxe_server` → `cluster` → `rancher` (2-3 h)
- Verifies Harvester cluster is Active in Rancher
- Loads the openSUSE Leap 16 KVM image into Harvester and waits for it to be active
- Stops all VMs cleanly

To watch Harvester install progress while the script runs, open a second terminal tab:

```bash
tail -f /var/log/libvirt/qemu/harvester1_serial.log
```

When the script ends with the success banner, all four VMs are shut off and the
environment is ready to snapshot.

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

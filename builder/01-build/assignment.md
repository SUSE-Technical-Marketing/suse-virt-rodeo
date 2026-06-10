---
slug: build
type: challenge
title: Build the suse-virt-rodeo-180 image
teaser: Build the custom image from scratch — run Ansible, bring up the nested Harvester cluster and Rancher, then snapshot geekohive.
tabs:
- id: terminal-geekohive
  title: geekohive
  type: terminal
  hostname: geekohive
  cmd: su - root
timelimit: 21600
difficulty: advanced
---

# Build the suse-virt-rodeo-180 image

This challenge walks you through building the custom Instruqt image from scratch.
When done, you snapshot geekohive as `suse/suse-virt-rodeo-180`.

Expected total time: 2-3 hours (most of it is unattended Harvester installation).

---

## Step 0 — Confirm the builder host has enough resources and nested virt

The build needs roughly **32 vCPU, 90 GB RAM, and a ~950 GB disk**. The guests take
28 vCPU and 72 GiB RAM (3×20 GiB Harvester + 12 GiB Rancher). The playbook creates
3× 270 GB Harvester disks + a 60 GB Rancher disk, but they are thin
(`preallocation=metadata`): ~870 GB virtual, ~300-350 GB actually used.

Before going further, confirm `geekohive` has the capacity and nested
virtualization enabled:

```bash
free -g                                      # expect ~90 GB total
nproc                                         # expect 32
df -h /var/lib/libvirt/images                # expect ~950 GB available
cat /sys/module/kvm_intel/parameters/nested  # expect Y (or kvm_amd on AMD)
```

If RAM is below ~90 GB the guests will not fit — lower the node memory in
`ansible/roles/vms/defaults/main.yml` (`libvirt_flavors`) first. Instruqt sets VM
disk size at image creation, not in `config.yml`, so a too-small base disk must be
resized there.

---

## Step 1 — Clone the repo

```bash
git clone -b dev git@github.com:SUSE-Technical-Marketing/test-harv-rodeo.git /root/rodeo
cd /root/rodeo
```

---

## Step 2 — Verify prerequisites and install Ansible collections

Only `ansible` is needed up front. The `kvm_host` role installs the rest on the
host — the KVM stack, `xorriso`, `jq`/`curl`, `firewalld`, and `kubectl` (it adds
the upstream Kubernetes repo, `pkgs.k8s.io` channel `stable:/v1.36`, since kubectl
is not in the SUSE base repos). SSH to the guests is key-based (the playbook bakes
the host public key into the Rancher VM and Harvester nodes), so no `sshpass`:

```bash
zypper install -y ansible
```

Install Ansible collections:

```bash
ansible-galaxy collection install -r ansible/requirements.yml
```

---

## Step 3 — Run the Ansible playbook (KVM host + VM assets)

This runs two roles in sequence:

**`kvm_host`** — installs KVM packages, enables the modular libvirt daemons
(`virtqemud` et al; `security_driver = none`, adds root to libvirt/kvm groups),
enables IP forwarding, and sets up firewalld with native port-forwarding (DNAT)
for the Harvester and Rancher UIs.

**`vms`** — redefines the libvirt network (virbr0) with static DHCP entries for
all four VMs, ensures the storage pool exists, creates qcow2 disk images
(3x 270 GB for Harvester, 1x 60 GB for Rancher), downloads the Harvester 1.8.0
ISO, renders per-node Harvester config ISOs from the Ansible template, creates
the Rancher cloud-init ISO, and defines all four KVM VMs.

```bash
ansible-playbook -i deployer/inventory.local ansible/playbook.yml
```

`deployer/inventory.local` runs against this host (`localhost`,
`ansible_connection=local`). Do not use `ansible/inventory.example` — that targets
a placeholder remote host. Verify the run completes with zero failures before
moving on.

---

## Step 4 — Start the VMs

`deploy-vms.sh` starts the VMs in the correct order and waits for the Harvester
API to come up on harvester1 before starting harvester2 and harvester3.
VM definitions and disk images were already prepared by the Ansible playbook.

```bash
cd /root/rodeo/builder
chmod +x deploy-vms.sh
./deploy-vms.sh
```

---

## Step 5 — Monitor Harvester installation

Serial console output is written to log files. Open a second terminal and tail
the logs to watch install progress:

```bash
tail -f /var/log/libvirt/qemu/harvester1_serial.log
```

> [!NOTE]
> `virsh console` is not available — serial output is file-based. Use `tail -f` in a
> separate terminal window to watch the install. Press `Ctrl+C` to stop tailing.

`deploy-vms.sh` starts harvester1, polls the VIP `https://192.168.122.10` until Harvester
responds, then starts harvester2 (with a 90-second stagger before harvester3 to
avoid etcd join race conditions), and finally starts the rancher VM. All four VMs
are running by the time the script exits. Wait for the Harvester cluster to be
fully formed before running `setup-rancher.sh`.

Confirm all three nodes are Ready by SSHing into harvester1:

```bash
ssh -i /root/.ssh/id_ed25519 rancher@192.168.122.10 "sudo kubectl get nodes -o wide"
```

> [!NOTE]
> `setup-rancher.sh` fetches the kubeconfig from the Harvester VIP automatically via
> SSH and persists it to `/root/.kube/harvester.yaml` (and `/tmp/harvester-kubeconfig`).
> The track's `setup-geekohive` relies on `/root/.kube/harvester.yaml` being in the
> baked image, so do not delete it. You do not need to copy it manually.

---

## Step 6 — Set up Rancher

Once all three Harvester nodes are Ready, run the Rancher setup script.
`setup-rancher.sh` installs K3s, Helm, and Rancher Prime 2.13.1 on the
rancher VM, waits for Rancher to become healthy, imports the Harvester cluster
via the Rancher API, and ejects the installer ISOs from all Harvester VMs.

```bash
cd /root/rodeo/builder
chmod +x setup-rancher.sh
./setup-rancher.sh
```

Check the Rancher admin password:

```bash
cat /root/rancher-password
```

Verify Rancher is reachable on its NodePort (K3s has traefik disabled, so Rancher
is exposed on `30002`, not `443`):

```bash
curl -sk https://192.168.122.9:30002/ping | grep -q "pong" && echo "Rancher OK"
```

---

## Step 7 — Verify the Harvester import

1. Open `https://192.168.122.9:30002` in a browser (forward port 30002 from geekohive).
2. Log in with `admin` and the password from `/root/rancher-password`.
3. Go to **Virtualization Management** — the Harvester cluster should show as **Active**.

If the cluster shows as Pending, give it 5-10 minutes for the Harvester-Rancher
integration to fully sync.

---

## Step 8 — Disable Longhorn V2 and install the Harvester UI plugin

Two manual bake steps the image needs (see the checklist in `ARCHITECTURE.md`):

1. **Disable the Longhorn V2 data engine.** SPDK/V2 does not work on virtio-blk in
   nested KVM. In the Harvester UI go to **Advanced → Settings → longhorn-v2-data-engine**
   and set it to `false` (it should already be disabled by default — confirm it).
2. **Install the Harvester UI plugin v1.8.0 in Rancher.** In Rancher go to
   **Extensions**, enable the Harvester extension repo if needed, and install the
   Harvester plugin matching the cluster version (1.8.0) so **Virtualization
   Management** renders correctly. Versions must match exactly.

Confirm both before moving on — without them the Rancher Virtualization Management
UI and Longhorn storage will misbehave in nested KVM.

---

## Step 9 — Load the openSUSE Leap 16 cloud image

Upload the Leap 16 cloud image so it is pre-loaded in Harvester for lab use. The
image **name must be `leap16`** — every challenge references `default/leap16`:

```bash
LEAP16_URL="https://download.opensuse.org/distribution/leap/16.0/appliances/openSUSE-Leap-16.0-Minimal-VM.x86_64-Cloud.qcow2"
curl -sk -X POST \
  -H "Authorization: Bearer $(cat /root/harvester-token)" \
  -H "Content-Type: application/json" \
  -d "{\"metadata\":{\"name\":\"leap16\",\"namespace\":\"default\"},
       \"spec\":{\"displayName\":\"openSUSE Leap 16\",\"url\":\"${LEAP16_URL}\",
                 \"sourceType\":\"download\"}}" \
  https://192.168.122.10/v1/harvesterhci.io.virtualmachineimages
```

Wait for the image to reach state `active` before continuing.

---

## Step 10 — Shut off all VMs

With everything installed and verified, shut off all VMs cleanly:

```bash
for vm in harvester1 harvester2 harvester3 rancher; do
  virsh shutdown $vm
  echo "Shutdown sent to $vm"
done

# Wait for clean shutdown (each VM can take up to 3 minutes)
sleep 120
virsh list --all
```

All four VMs should show `shut off` before you save the image.

---

## Step 11 — Save the Instruqt image

From the Instruqt web console:

1. Go to the builder track sandbox.
2. Select the `geekohive` VM.
3. Click **Save as image**.
4. Set the image name to `suse-virt-rodeo-180`.
5. Set the owner to `suse`.
6. Wait for the snapshot to complete (20-30 minutes for a large disk).

Once the image is saved, update `config.yml` in the main rodeo track to point to
`suse/suse-virt-rodeo-180`.

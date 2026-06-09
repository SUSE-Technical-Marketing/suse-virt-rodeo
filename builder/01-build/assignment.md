# Build the suse-virt-rodeo-180 image

This challenge walks you through building the custom Instruqt image from scratch.
When done, you snapshot geekohive as `suse/suse-virt-rodeo-180`.

Expected total time: 2-3 hours (most of it is unattended Harvester installation).

---

## Step 1 — Clone the repo

```bash
git clone https://github.com/suse/instruqt-virtualization.git /root/instruqt-virtualization
cd /root/instruqt-virtualization
```

---

## Step 2 — Verify prerequisites and install Ansible collections

Confirm `sshpass` and `jq` are installed — `setup-rancher.sh` requires both:

```bash
rpm -q sshpass jq || zypper install -y sshpass jq
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
ansible-playbook -i ansible/inventory.example ansible/playbook.yml
```

Verify it completes with zero failures before moving on.

---

## Step 4 — Start the VMs

`deploy-vms.sh` starts the VMs in the correct order and waits for the Harvester
API to come up on harvester1 before starting harvester2 and harvester3.
VM definitions and disk images were already prepared by the Ansible playbook.

```bash
cd /root/instruqt-virtualization/builder
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
ssh root@192.168.122.11 "kubectl get nodes -o wide"
```

> [!NOTE]
> `setup-rancher.sh` fetches the kubeconfig from harvester1 automatically via SSH
> and writes it to `/tmp/harvester-kubeconfig` on geekohive. You do not need to
> copy it manually.

---

## Step 6 — Set up Rancher

Once all three Harvester nodes are Ready, run the Rancher setup script.
`setup-rancher.sh` installs K3s, Helm, and Rancher Prime 2.13.1 on the
rancher VM, waits for Rancher to become healthy, imports the Harvester cluster
via the Rancher API, and ejects the installer ISOs from all Harvester VMs.

```bash
cd /root/instruqt-virtualization/builder
chmod +x setup-rancher.sh
./setup-rancher.sh
```

Check the Rancher admin password:

```bash
cat /root/rancher-password
```

Verify Rancher is reachable:

```bash
curl -sk https://rancher.192.168.122.9.sslip.io/ping | grep -q "pong" && echo "Rancher OK"
```

---

## Step 7 — Verify the Harvester import

1. Open `https://rancher.192.168.122.9.sslip.io` in a browser (forward port 443 from geekohive).
2. Log in with `admin` and the password from `/root/rancher-password`.
3. Go to **Virtualization Management** — the Harvester cluster should show as **Active**.

If the cluster shows as Pending, give it 5-10 minutes for the Harvester-Rancher
integration to fully sync.

---

## Step 8 — Load the openSUSE Leap 16 cloud image

Upload the Leap 16 cloud image so it is pre-loaded in Harvester for lab use:

```bash
LEAP16_URL="https://download.opensuse.org/distribution/leap/16.0/appliances/openSUSE-Leap-16.0-Minimal-VM.x86_64-Cloud.qcow2"
curl -sk -X POST \
  -H "Authorization: Bearer $(cat /root/harvester-token)" \
  -H "Content-Type: application/json" \
  -d "{\"metadata\":{\"name\":\"opensuse-leap-16\",\"namespace\":\"default\"},
       \"spec\":{\"displayName\":\"openSUSE Leap 16\",\"url\":\"${LEAP16_URL}\",
                 \"sourceType\":\"download\"}}" \
  https://192.168.122.10/v1/harvesterhci.io.virtualmachineimages
```

Wait for the image to reach state `active` before continuing.

---

## Step 9 — Shut off all VMs

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

## Step 10 — Save the Instruqt image

From the Instruqt web console:

1. Go to the builder track sandbox.
2. Select the `geekohive` VM.
3. Click **Save as image**.
4. Set the image name to `suse-virt-rodeo-180`.
5. Set the owner to `suse`.
6. Wait for the snapshot to complete (20-30 minutes for a large disk).

Once the image is saved, update `config.yml` in the main rodeo track to point to
`suse/suse-virt-rodeo-180`.

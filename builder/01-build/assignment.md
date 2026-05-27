# Build the suse-virt-rodeo-180 image

This challenge walks you through building the custom Instruqt image from scratch.
When done, you snapshot geekohive as `suse/suse-virt-rodeo-180`.

Expected total time: 3-4 hours (most of it is unattended Harvester installation).

---

## Step 1 — Clone the repo

```bash
git clone https://github.com/suse/instruqt-virtualization.git /root/instruqt-virtualization
cd /root/instruqt-virtualization
```

---

## Step 2 — Run the Ansible role (KVM host setup)

This installs KVM packages, starts libvirtd, enables IP forwarding, configures firewall rules,
and sets up the DNAT service for Harvester and Rancher UI forwarding.

```bash
ansible-playbook ansible/site.yml -i ansible/inventory/builder
```

Verify it completes with no failures before moving on.

---

## Step 3 — Run deploy-vms.sh

This script:
- Adds static DHCP reservations to the default libvirt network (virbr0)
- Creates all qcow2 disk images for Harvester nodes (250 GB each)
- Downloads the openSUSE Leap 16 cloud image and creates the Rancher VM disk from it (60 GB)
- Creates a cloud-init seed ISO for the Rancher VM (network config + SSH key)
- Downloads the Harvester 1.8.0 ISO (~1.5 GB)
- Generates per-node Harvester unattended config ISOs
- Defines all KVM VMs and starts the three Harvester nodes
  (each Harvester node gets two NICs on virbr0: eth0=management, eth1=VM traffic)

```bash
cd /root/instruqt-virtualization/builder
chmod +x deploy-vms.sh
./deploy-vms.sh
```

Watch for errors in the ISO download and VM definitions. The script starts harvester1 first
and waits before starting harvester2 and harvester3.

---

## Step 4 — Monitor Harvester installation

Harvester installs unattended via the config YAMLs. Each node takes 20-40 minutes.

Check node progress on the console:
```bash
virsh console harvester1
# Ctrl+] to detach
```

Poll for the cluster VIP to become reachable (the API server on harvester1):
```bash
until curl -sk https://192.168.122.11:6443 | grep -q "Unauthorized\|apiVersion"; do
  echo "Waiting for Harvester API..."; sleep 30
done
echo "Harvester API is up"
```

Once harvester1 is ready, harvester2 and harvester3 join the cluster automatically.
Confirm all three nodes are Ready:
```bash
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
kubectl get nodes -o wide
```

Run this from inside harvester1 via virsh console, or copy the kubeconfig out after install.

---

## Step 5 — Set up Rancher

Start the rancher VM and wait for cloud-init to finish (about 60-90 seconds):
```bash
virsh start rancher
sleep 90
```

Verify SSH access (cloud-init injects geekohive's public key):
```bash
ssh -o StrictHostKeyChecking=no root@192.168.122.9 "hostname"
# Should print: rancher
```

Then run the setup script:
```bash
cd /root/instruqt-virtualization/builder
chmod +x setup-rancher.sh
./setup-rancher.sh
```

The script installs K3s, Helm, and Rancher Prime 2.13.1, then waits for Rancher to become
healthy. It writes the admin password to `/root/rancher-password`.

Check the password:
```bash
cat /root/rancher-password
```

Verify Rancher is reachable:
```bash
curl -sk https://rancher.192.168.122.9.sslip.io/ping | grep -q "pong" && echo "Rancher OK"
```

---

## Step 6 — Import Harvester into Rancher

The `setup-rancher.sh` script handles this via the Rancher API. Verify the import:
1. Open https://rancher.192.168.122.9.sslip.io in a browser (forward port 443 from geekohive).
2. Log in with `admin` and the password in `/root/rancher-password`.
3. Navigate to Virtualization Management — you should see the Harvester cluster listed as Active.

If the cluster shows as Pending, give it 5-10 minutes for the Harvester-Rancher integration
to fully sync.

---

## Step 7 — Load the openSUSE Leap 16 cloud image

Upload the Leap 16 cloud image so it is pre-loaded in Harvester for lab use:
```bash
LEAP16_URL="https://download.opensuse.org/distribution/leap/16.0/appliances/openSUSE-Leap-16.0-Minimal-VM.x86_64-Cloud.qcow2"
# Download on geekohive, then push into Harvester via its API or the UI.
# Use the Harvester image upload API:
curl -sk -X POST \
  -H "Authorization: Bearer $(cat /root/harvester-token)" \
  -H "Content-Type: application/json" \
  -d "{\"metadata\":{\"name\":\"opensuse-leap-16\",\"namespace\":\"default\"},
       \"spec\":{\"displayName\":\"openSUSE Leap 16\",\"url\":\"${LEAP16_URL}\",
                 \"sourceType\":\"download\"}}" \
  https://192.168.122.11/v1/harvesterhci.io.virtualmachineimages
```

Wait for the image to reach state `active` before continuing.

---

## Step 8 — Shut off all VMs

With everything installed and verified, shut off all VMs cleanly:
```bash
for vm in harvester1 harvester2 harvester3 rancher; do
  virsh shutdown $vm
done

# Wait for clean shutdown (up to 3 minutes each)
for vm in harvester1 harvester2 harvester3 rancher; do
  echo "Waiting for $vm to stop..."
  virsh dominfo $vm | grep -q "shut off" || sleep 30
done

virsh list --all
```

All four VMs should show `shut off` before you save the image.

---

## Step 9 — Save the Instruqt image

From the Instruqt web console:
1. Go to the builder track sandbox.
2. Select the `geekohive` VM.
3. Click **Save as image**.
4. Set the image name to `suse-virt-rodeo-180`.
5. Set the owner to `suse`.
6. Wait for the snapshot to complete (can take 20-30 minutes for a large disk).

Once the image is saved, update `config.yml` in the main rodeo track to point to
`suse/suse-virt-rodeo-180`.

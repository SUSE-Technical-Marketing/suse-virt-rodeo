# Runbook: build and run the SUSE Virtualization Rodeo

Two paths, in order. **Part 1** stands up the lab host with the agnostic deployer
(any SLES 16 machine). **Part 2** packages it as an Instruqt lab (bake the image,
then ship the student track). The Instruqt builder runs the same Part 1 steps
inside a sandbox and snapshots the result, so read Part 1 first.

Branch: `sles16-mig`. Addressing (NAT mode, `virbr0` `192.168.122.0/24`): floating
kube-vip VIP `.10` (not a node), harvester1/2/3 `.11/.12/.13`, rancher `.9`.

---

## Part 1 — Stand up the lab host (deployer)

Budget 40–90 minutes; most of it is the unattended Harvester install.

### Step 1 — Provision a SLES 16 host

A SLES 16 / openSUSE Leap 16 machine (bare metal, cloud VM, or IaaS). It needs:

- **Nested virtualization on.** Harvester runs VMs inside itself (KubeVirt), so the
  host CPU must pass virtualization through. On a cloud VM enable this at creation
  (e.g. GCP `--enable-nested-virtualization`, or a bare-metal/`*.metal` instance).
- **Capacity:** ~28 vCPU, ~96 GiB RAM, **≥ 1 TB** disk. The playbook creates
  3×270 GB + 60 GB qcow2 disks (~870 GB).
- **Root access** and **outbound internet** (pulls the Harvester ISO, the Leap
  image, K3s, and the Rancher charts).

Confirm the hardware:

```bash
lscpu | grep -i virtualization                 # expect VT-x or AMD-V
cat /sys/module/kvm_intel/parameters/nested    # expect Y (kvm_amd on AMD)
df -h /var/lib                                  # expect ~1 TB free
```

If `nested` prints `N`, fix nested virt on the platform first — the cluster cannot
run VMs without it.

### Step 2 — Install the host tools

```bash
sudo zypper install -y ansible kubernetes-client jq xorriso openssh-clients git
```

- **ansible** runs the playbook (host config + VM assets).
- **kubernetes-client** gives `kubectl` (imports Harvester into Rancher).
- **jq** parses Rancher/Harvester API JSON.
- **xorriso** builds the seed ISOs (SLES 16 dropped `genisoimage`).
- **openssh-clients** provides `ssh` — auth to the guests is key-based (the
  playbook bakes the host public key into the Rancher VM and Harvester nodes), so
  no `sshpass` or passwords are needed.
- **git** clones the repo.

### Step 3 — Clone the repo

```bash
git clone -b sles16-mig https://github.com/SUSE-Technical-Marketing/instruqt-virtualization.git
cd instruqt-virtualization/deployer
```

`deployer/` is the entrypoint; it reuses the shared roles in `../ansible/`.

### Step 4 — Configure deploy.env

```bash
cp deploy.env.example deploy.env
$EDITOR deploy.env
```

Set at minimum:

- **`HARVESTER_OS_PASSWORD`** and **`RANCHER_VM_PASSWORD`** — change from the
  placeholders. They are baked into the Harvester install config and the Rancher
  VM cloud-init, so they must be set before the run.
- **`NETWORK_MODE=nat`** — leave for a self-contained single host. Guests sit on
  the libvirt NAT network and the host port-forwards the UIs. Use `bridge` only to
  put nodes on the real LAN; then also copy `deploy.vars.yml.example` to
  `deploy.vars.yml`, set per-node IPs + gateway, and make `HARVESTER_VIP`/
  `RANCHER_IP` free LAN addresses.
- Leave the rest at defaults (`HARVESTER_VIP=192.168.122.10`,
  `RANCHER_IP=192.168.122.9`, versions).

`deploy.env` is gitignored (it holds passwords) — never commit it.

### Step 5 — Run the deployer

```bash
sudo ./deploy.sh
```

Four phases:

1. **Preflight + collections** — verifies tools, installs the Ansible collections.
2. **Ansible playbook** (`kvm_host` then `vms`) — configures the host (modular
   libvirt daemons, firewalld DNAT, RKE2-friendly sysctls) and stages all VM
   assets (NAT network with static DHCP, qcow2 disks, Harvester ISO, per-node
   config ISOs, Rancher cloud-init ISO, the four libvirt domains).
3. **Start VMs + wait** (`lib/start-vms.sh`) — boots harvester1, waits for the VIP,
   staggers harvester2/3 and the Rancher VM. The long wait (~20–40 min).
4. **K3s + Rancher** (`lib/setup-rancher.sh`) — installs K3s + Rancher Prime,
   exposes Rancher on NodePort 30002, imports the Harvester cluster, writes
   `/root/.kube/harvester.yaml` and `/root/rancher-password`.

Watch progress in a second terminal:

```bash
sudo tail -f /var/log/libvirt/qemu/harvester1_serial.log
```

### Step 6 — Verify

```bash
sudo virsh list --all                                            # 4 VMs running
sudo KUBECONFIG=/root/.kube/harvester.yaml kubectl get nodes     # 3 nodes Ready
curl -sk https://192.168.122.10/ping                             # Harvester VIP (443) -> pong
curl -sk https://192.168.122.9:30002/ping                        # Rancher NodePort -> pong
cat /root/rancher-password                                       # Rancher admin password
```

From the host, hit the internal addresses above. From outside, use the host IP on
`:8443` (Harvester) and `:30002` (Rancher) — the firewalld port-forwards
(`host:8443 → VIP:443`, `host:30002 → Rancher`).

That is a working lab host. For a throwaway test, stop here.

---

## Part 2 — Package it as an Instruqt lab

Students must not wait an hour for Harvester to install. Bake the finished
environment into a custom image once (builder track), then the student track boots
from it in minutes.

### Prerequisites

- Instruqt access to the org (`SUSE-Technical-Marketing` / `suse`).
- Instruqt CLI installed and authenticated:
  ```bash
  instruqt version
  instruqt auth login
  ```
- A SLES 16 base image in the org. `builder/config.yml` assumes `suse/sles-16-0`;
  confirm the slug in the catalog and update that file if it differs.

### 2A — Build the custom image (builder track)

**Step 1 — Push and start the builder track**

```bash
cd instruqt-virtualization/builder
instruqt track push
```

Start the track in the Instruqt console and open the `geekohive` terminal. The
sandbox needs a ≥ 1 TB disk (set at image/sandbox creation, not in `config.yml`).

**Step 2 — Run the build (follow `01-build/assignment.md`)**

Same flow as Part 1, plus image prep:

- Step 0 — confirm ≥ 1 TB disk and nested virt.
- Step 1 — clone `-b sles16-mig`.
- Step 2 — `zypper install -y ansible kubernetes-client jq xorriso openssh-clients`,
  then `ansible-galaxy collection install -r ansible/requirements.yml`.
- Step 3 — `ansible-playbook -i deployer/inventory.local ansible/playbook.yml`.
- Step 4 — `cd builder && ./deploy-vms.sh`.
- Step 5 — watch the serial logs.
- Step 6 — `./setup-rancher.sh`.
- Step 7 — verify the Harvester cluster is **Active** in Rancher
  (`https://192.168.122.9:30002`).
- Step 8 — disable the Longhorn V2 data engine and install the Harvester UI plugin
  v1.8.0 (manual; V2/SPDK does not work in nested KVM, and the plugin must match
  the cluster version).
- Step 9 — upload the Leap 16 cloud image, named exactly **`leap16`** (challenges
  reference `default/leap16`).
- Step 10 — shut off all four VMs cleanly.

**Step 3 — Save the image**

In the Instruqt console: `geekohive` → **Save as image** → name
`suse-virt-rodeo-180`, owner `suse`. Snapshot takes 20–30 min. The frozen image
holds the clustered Harvester + Rancher, the kubeconfig, the password file, and the
Leap 16 image.

### 2B — Ship the student track

**Step 1 — Point the main track at the new image**

Edit the repo-root `config.yml`:

```yaml
virtualmachines:
- name: geekohive
  image: suse/suse-virt-rodeo-180     # was suse/suse-virtualization-rodeo-dev
```

**Step 2 — Validate and push (from the repo root, not `builder/`)**

```bash
instruqt track validate
instruqt track push
```

`.github/workflows/publish.yml` can do this on push to `main`, but it is disabled
until the image exists and `INSTRUQT_TOKEN` is set. Re-enable it by restoring the
`push` trigger described in that file.

**Step 3 — What happens when a student starts**

Two host scripts run automatically (the `setup-<hostname>` convention):

- `track_scripts/setup-geekohive` — boots the four baked VMs, waits (via
  `/root/.kube/harvester.yaml`) for 3 nodes Ready, ejects the installer ISOs, waits
  for Rancher on `:30002`, then publishes agent variables.
- `track_scripts/setup-cloud-client` — configures the nginx proxy (`:90 → Harvester
  UI`, `:91 → Rancher UI`), points `kubectl` at the imported Harvester cluster
  (queried by name `harvester`), and registers an SSH keypair.

The student gets three tabs: a `cloud-client` terminal, the Harvester UI (port 90),
and the Rancher UI (port 91), and works the six AeroGrid challenges.

---

## Before a real run

Nothing here has been executed end-to-end; the image has never been built. Two
things can only be confirmed on a live SLES 16 host (see `BRANCH_CONTEXT.md`):

- the firewalld masquerade/DNAT return path under load;
- the Harvester kubeconfig fetch: `setup-rancher.sh` connects key-based as the
  `rancher` user and runs `sudo cat /etc/rancher/rke2/rke2.yaml`. Confirm the baked
  host key is accepted on the nodes (`os.ssh_authorized_keys`) and that the
  `rancher` user has passwordless sudo. If the build stalls at the kubeconfig
  fetch, check these first.

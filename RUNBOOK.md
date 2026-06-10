# Runbook: build and run the SUSE Virtualization Rodeo

Two paths, in order. **Part 1** stands up the lab host with the agnostic deployer
(any SLES 16 machine). **Part 2** packages it as an Instruqt lab (bake the image,
then ship the student track). The Instruqt builder runs the same Part 1 steps
inside a sandbox and snapshots the result, so read Part 1 first.

Source: `SUSE-Technical-Marketing/test-harv-rodeo` branch `dev` (the working repo;
mirror of `SUSE-Technical-Marketing/instruqt-virtualization` branch `sles16-mig`).

Addressing (NAT mode, `virbr0` `192.168.122.0/24`): floating kube-vip VIP `.10`
(not a node), harvester1/2/3 `.11/.12/.13`, rancher `.9`.

---

## Part 1 — Stand up the lab host (deployer)

Budget 40–90 minutes; most of it is the unattended Harvester install.

### Step 1 — Provision a SLES 16 host

A SLES 16 / openSUSE Leap 16 machine (bare metal, cloud VM, or IaaS). It needs:

- **Nested virtualization on.** Harvester runs VMs inside itself (KubeVirt), so the
  host CPU must pass virtualization through. On a cloud VM enable this at creation
  (e.g. GCP `--enable-nested-virtualization`, or a bare-metal/`*.metal` instance).
- **Capacity:** 32 vCPU, ~90 GB RAM, ~950 GB disk. The guests take 28 vCPU and
  72 GiB (3×20 GiB Harvester + 12 GiB Rancher), leaving ~13 GiB for the host. The
  disks are thin (`preallocation=metadata`): 870 GB virtual, ~300-350 GB actually
  used, so 950 GB is plenty. On a larger host you can raise the node memory in
  `ansible/roles/vms/defaults/main.yml` (`libvirt_flavors`).
- **Root access** and **outbound internet** (pulls the Harvester ISO, the Leap
  image, K3s, and the Rancher charts).

Confirm the hardware:

```bash
lscpu | grep -i virtualization                 # expect VT-x or AMD-V
cat /sys/module/kvm_intel/parameters/nested    # expect Y (kvm_amd on AMD)
free -g                                         # expect ~90 GB total
df -h /var/lib                                  # expect ~950 GB free
```

If `nested` prints `N`, fix nested virt on the platform first — the cluster cannot
run VMs without it.

### Step 2 — Install the host tools

Only two things are needed up front — **ansible** (to run the playbook) and **git**
(to clone):

```bash
sudo zypper install -y ansible git
```

The playbook installs everything else on the host: the KVM stack (`qemu`, `libvirt`,
`virsh`), `xorriso` (seed ISOs; SLES 16 dropped `genisoimage`), `jq`/`curl`,
`firewalld` + its Python bindings, and **`kubectl`** — for which it adds the upstream
Kubernetes repo (`pkgs.k8s.io`, channel `stable:/v1.36`), since kubectl is not in the
SUSE base repos. `ssh` is already in the base system; guest auth is key-based (the
playbook bakes the host public key into the Rancher VM and Harvester nodes), so no
`sshpass` or passwords are needed.

### Step 3 — Clone the repo

Access is SSH-only. Make sure an SSH key is configured for GitHub on the host
(personal key in `~/.ssh/` or a deploy key) before running:

```bash
git clone -b dev git@github.com:SUSE-Technical-Marketing/test-harv-rodeo.git
cd test-harv-rodeo/deployer
```

Quick SSH check if the clone fails:

```bash
ssh -T git@github.com    # expect: Hi <user>! You've successfully authenticated...
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

Two options. `rodeo.sh` (repo root) is the recommended path — it adds unified
logging, per-phase confirmation, and state-based resume. `deployer/deploy.sh` is
the lower-level entrypoint (no state tracking, no interactive menu).

**Option A — `rodeo.sh` (recommended):**

```bash
cd /path/to/test-harv-rodeo
sudo ./rodeo.sh              # interactive menu
sudo ./rodeo.sh --all        # unattended
sudo ./rodeo.sh --from 3     # resume from VMs phase after a failure
sudo ./rodeo.sh --status     # show which phases completed
```

Logs go to `logs/rodeo-latest.log` (symlink) and a timestamped copy.

**Option B — `deployer/deploy.sh` (direct):**

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

Both the Harvester and Rancher dashboards/APIs use the fixed lab admin password
**`Foobar12345$`** (user `admin`), set by `setup-rancher.sh` and overridable via
`LAB_ADMIN_PASSWORD` in `deploy.env`. It is lab-grade — do not reuse it anywhere real.

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
- A SLES 16 base image in the org. `builder/config.yml` is set to
  `suse/harv-rodeo-sles16` (confirmed slug).

### 2A — Build the custom image (builder track)

**Step 1 — Push and start the builder track**

```bash
cd instruqt-virtualization/builder
instruqt track push
```

Start the track in the Instruqt console and open the `geekohive` terminal. The
sandbox needs a ≥ 1 TB disk (set at image/sandbox creation, not in `config.yml`).

**Step 2 — Run the build (follow `01-build/assignment.md`)**

Same flow as Part 1, plus image prep. You can run all phases manually or use the
interactive deployer (`rodeo.sh`) to run them in one go.

**Option A — `rodeo.sh` (recommended):**

After cloning and installing Ansible, set up `deployer/deploy.env` (copy from
`deploy.env.example`), then:

```bash
cd /root/rodeo
sudo ./rodeo.sh --all          # fully unattended, all 5 phases
# or
sudo ./rodeo.sh --interactive  # confirm between each phase
# or resume from a failure
sudo ./rodeo.sh --from 3       # re-run from phase 3 (VMs) onwards
```

All output (Ansible, virsh, SSH, serial logs) streams to stdout and
`logs/rodeo-latest.log`. Use `--status` to check which phases have completed and
`--reset` to clear state for a full re-run.

**Option B — manual steps:**

- Step 0 — confirm ≥ 1 TB disk and nested virt.
- Step 1 — clone via SSH: `git clone -b dev git@github.com:SUSE-Technical-Marketing/test-harv-rodeo.git`
- Step 2 — `zypper install -y ansible`, then
  `ansible-galaxy collection install -r ansible/requirements.yml` (the playbook
  installs the KVM stack, xorriso, kubectl, etc.).
- Step 3 — `ansible-playbook -i deployer/inventory.local ansible/playbook.yml`.
- Step 4 — `cd builder && ./deploy-vms.sh` — starts VMs, waits for VIP, then waits
  for all 3 nodes to reach Ready (40-90 min). Watch serial logs in a second terminal:
  `tail -f /var/log/libvirt/qemu/harvester1_serial.log`
- Step 5 — `./setup-rancher.sh`.
- Step 6 — verify the Harvester cluster is **Active** in Rancher
  (`https://192.168.122.9:30002`).
- Step 7 — disable the Longhorn V2 data engine and install the Harvester UI plugin
  v1.8.0 (manual; V2/SPDK does not work in nested KVM, and the plugin must match
  the cluster version).
- Step 8 — upload the Leap 16 KVM image (`kvm-and-xen` variant), named exactly
  **`leap16`** (challenges reference `default/leap16`). Use the `kvm-and-xen` variant —
  virtio drivers included; the `Cloud` variant expects a cloud metadata endpoint that
  does not exist on the libvirt NAT network.
- Step 9 — shut off all four VMs cleanly.

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

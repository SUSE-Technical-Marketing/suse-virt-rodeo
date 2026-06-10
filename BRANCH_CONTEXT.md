# Branch context: `sles16-mig`

AI handoff note. Read this first if you are picking up work on this branch.

## What this branch is

This branch migrates the SUSE Virtualization Rodeo from a **SLES 15.6** KVM host to
**SLES 16**, adds a **cloud/bare-metal agnostic deployer**, hardens the host for the
**RKE2** cluster that Harvester runs underneath, and fixes the **kube-vip VIP** so it
is a real floating address.

Base branch: `development`. Nothing here is merged yet.

## What the project is (for context)

An Instruqt interactive lab. Learners migrate a fictional airport IT platform
("AeroGrid Operations") from VMware to SUSE Virtualization (Harvester HCI). A single
GCP VM (`geekohive`, n2-standard-32, nested virt on) runs four nested KVM guests:

- `harvester1/2/3` — 8 vCPU, 20 GiB, 270 GB qcow2, Harvester 1.8.0, 5 NICs each
- `rancher` — 4 vCPU, 12 GiB, 60 GB, K3s + Rancher Prime 2.13.1
- Sized for a 32 vCPU / 90 GB / 950 GB host (guests 28 vCPU / 72 GiB; thin disks).
  Raise node memory in `libvirt_flavors` on a 128 GiB host.

Harvester is built on **RKE2**. Rancher imports the Harvester cluster. Component
versions are unchanged on this branch (Harvester 1.8.0, Rancher Prime 2.13.1, K3s
v1.31); only the host OS and tooling moved to SLES 16.

## Addressing (memorize this)

Network `192.168.122.0/24` (NAT mode, libvirt `virbr0`):

| Thing | IP | Notes |
|-------|----|-------|
| virbr0 gateway | .1 | |
| **Harvester VIP** | **.10** | floating, kube-vip, NOT a node IP, not in DHCP |
| harvester1 | .11 | bootstrap / cluster-init node |
| harvester2 | .12 | join node |
| harvester3 | .13 | join node |
| rancher | .9 | K3s + Rancher |
| DHCP dynamic pool | .100-.254 | |
| LoadBalancer pool (rodeo-ippool) | .200-.220 | ARP-announced on eth3/eth4 |

The VIP being `.10` (separate from any node) is deliberate and load-bearing: if a
node dies, kube-vip moves `.10` to a survivor so the API/UI stay up. Do not set the
VIP to a node IP.

## What changed on this branch

**SLES 16 migration (host layer):**
- Modular libvirt daemons (`virtqemud`/`virtnetworkd`/`virtstoraged`/`virtnodedevd`/
  `virtsecretd`/`virtlogd` sockets) replace monolithic `libvirtd`. A
  `libvirt_daemon_mode: monolithic` switch remains for older hosts.
- UI DNAT is now native **firewalld port-forwarding** (nftables backend). The old
  raw-iptables `kvm-dnat.service` was deleted.
- Seed ISOs built with `xorriso -as mkisofs` (`genisoimage` is gone on SLES 16).
- OVMF uses explicit pflash loader + per-VM nvram (dropped `firmware='efi'`
  autoselect) from `qemu-ovmf-x86_64` at `/usr/share/qemu/`.
- SELinux is enforcing (AppArmor removed); `security_driver = "none"` in qemu.conf.

**RKE2/Harvester host hardening (the reason node-to-node traffic does not break):**
- `bridge-nf-call-iptables/ip6tables/arptables = 0` so the host firewall never
  filters L2-bridged inter-node RKE2/etcd/Canal-VXLAN(8472/udp)/Kube-OVN-Geneve
  (6081/udp) traffic. In `/etc/sysctl.d/99-harvester-rke2.conf`.
- `net.ipv4.conf.all.rp_filter = 2` (loose) for the multi-NIC + VIP + LB-ARP topology.
- firewalld masquerade on the **libvirt zone** for the DNAT return path.
- firewalld libvirt-zone accept for the node subnet (belt-and-braces).

**kube-vip VIP fix:** `harvester_vip` moved from `.11` (was harvester1's IP) to `.10`.
Join nodes use `server_url: https://192.168.122.10:443`.

**Agnostic deployer (`deployer/`):** one `deploy.sh` entrypoint that reuses the shared
Ansible roles, then starts the VMs and installs Rancher. Runs on any SLES 16 / Leap 16
host with no Instruqt. NAT or bridge networking selectable. SUSE-family only.

**External-audit fixes (2026-06-09 round):**
- Rancher is exposed on **NodePort 30002** (`rancher-nodeport` svc in `cattle-system`),
  because K3s runs with traefik disabled. All setup-time Rancher API calls + the agent
  `server-url` go through `https://192.168.122.9:30002`, not `:443`.
- `setup-rancher.sh` (builder + deployer) now persists `/root/.kube/harvester.yaml`
  (the path `setup-geekohive` waits on). Previously only `/tmp/harvester-kubeconfig`.
- `setup-cloud-client` queries the Rancher cluster by `name=harvester`, not `name=local`
  (which is Rancher's own K3s cluster).
- Harvester image name standardized to **`leap16`** (challenges use `default/leap16`).
- Builder docs: clone `-b dev` from test-harv-rodeo, run with
  `deployer/inventory.local`, Step 0 resource check (32 vCPU / 90 GB / 950 GB),
  manual Longhorn-V2-disable + Harvester-UI-plugin steps.
- **kubectl** is installed by the `kvm_host` role (not in SUSE base repos): it adds
  the upstream Kubernetes repo `pkgs.k8s.io` (channel `kubectl_repo_channel`, default
  `stable:/v1.36` — the latest stable) and `zypper install kubectl`. The only manual
  host prereq is now `ansible`; the deployer preflight checks just ansible(-galaxy).
- Builder Instruqt structure aligned to the main track: frontmatter in
  `01-build/assignment.md` (slug `build`), inline `challenges:` removed from
  `builder/track.yml`.
- **Keys-only SSH** — `sshpass` dropped entirely. `images.yml` generates a host
  ed25519 key first and bakes the public key into the Rancher VM (cloud-init, root)
  and the Harvester nodes (`os.ssh_authorized_keys`). `setup-rancher.sh` connects
  key-based: `root@rancher-vm`, and `rancher@VIP` + `sudo` for the kubeconfig.
- **aerogrid.com lab DNS (three layers):**
  - libvirt network XML `<domain>` + `<dns>` block — built-in dnsmasq on
    `192.168.122.1` serves all five A records to VMs on the NAT network.
  - Ansible `blockinfile` writes the same entries to `/etc/hosts` on geekohive.
  - `setup-cloud-client` writes `/etc/hosts` on cloud-client (resolving to
    geekohive's Instruqt IP) and adds nginx port-443 HTTPS named vhosts
    (`virtualization.aerogrid.com` → :8443, `rancher.aerogrid.com` → :30002).
  - `setup-rancher.sh` patches the RKE2 CoreDNS ConfigMap in `kube-system` to
    forward `aerogrid.com` to `192.168.122.1` — covers Kubernetes pods inside
    Harvester. Idempotent; reload plugin picks it up in ~30s.
  - Name table: `virtualization.aerogrid.com` (.10 VIP), `rancher.aerogrid.com`
    (.9), `alpha.aerogrid.com` (.11), `bravo.aerogrid.com` (.12),
    `charlie.aerogrid.com` (.13).
- **ISO URL fix:** Harvester ISOs are on `releases.rancher.com`, not GitHub
  releases. `images.yml` corrected + SHA-512 checksum pinned for v1.8.0.
- **Deployer race fix:** `start-vms.sh` now waits for all 3 nodes to reach
  `Ready` (kubectl poll via SSH-fetched kubeconfig) before handing off to
  `setup-rancher.sh`. Previously it exited after only the VIP responded.
- **Single lab admin password `Foobar12345$`** (user `admin`) for both the Rancher
  and Harvester dashboards/APIs, plus the node/VM console passwords. `setup-rancher.sh`
  sets Rancher's admin to it (was random) and sets Harvester's admin via the embedded
  Rancher v3 API (bootstrap `admin/admin` -> changepassword). Overridable via
  `LAB_ADMIN_PASSWORD`. Lab-grade only.
  - Note: the Harvester install config has **no** field for the dashboard admin
    password (`os.password` is the OS `rancher` user only), so the post-install API
    call is the supported path. The embedded Rancher bootstrap `admin/admin` is the
    confirmed default (harvester-installer `rancherd` `50-defaults.yaml`). Live check
    is just that the v3 `changepassword` endpoint responds (standard Rancher); the
    kubectl bcrypt user-patch remains a fallback if a version ever differs.
- Legacy `Converting-SLES-15.6-KVM-host.md` rewritten as `Converting-SLES-16-KVM-host.md`.

## Where things live

```
ansible/                    Shared roles — source of truth for both Instruqt + deployer
  playbook.yml              Runs kvm_host then vms
  roles/kvm_host/           Host config: packages, libvirt daemons, networking, firewall
  roles/vms/                VM assets: disks, ISOs, libvirt domains; templates/ has the
                            real harvester-config + vm.xml (Jinja)
builder/                    Instruqt image-builder track (SLES 16 base -> custom image).
                            harvester-config-node*.yaml are REFERENCE copies; Ansible
                            renders the real ones from the template.
deployer/                   Agnostic cloud/bare-metal deployer (this branch's new piece)
  deploy.sh                 Entrypoint; reads deploy.env, runs ansible -> start-vms ->
                            setup-rancher
  deploy.env.example        Copy to deploy.env (gitignored). Authoritative for
                            network_mode / VIP / IPs / passwords.
  deploy.vars.yml.example   Copy to deploy.vars.yml (gitignored). Advanced Ansible
                            overrides (bridge gateway + per-node IPs). Must NOT redefine
                            the keys deploy.env owns.
  lib/                      start-vms.sh, setup-rancher.sh (env-driven, no secrets)
config.yml / track.yml      Main Instruqt track
ARCHITECTURE.md             Full stack reference (kept current)
README.md                   Project + build + troubleshooting + "deploy outside Instruqt"
assets/diagrams/*.mmd       Mermaid sources; *.png re-rendered with mmdc
```

## Networking modes

- `network_mode: nat` (default) — guests on virbr0; host DNATs `:8443`→VIP and
  `:30002`→Rancher. Self-contained.
- `network_mode: bridge` — guests attach to an existing host bridge with real LAN IPs;
  no DNAT. In bridge mode set `HARVESTER_VIP`/`RANCHER_IP` in `deploy.env` and per-node
  IPs + gateway in `deploy.vars.yml`, kept consistent. VIP must be a free LAN address,
  not a node IP.

## How to validate (no live host needed)

```bash
ansible-playbook -i deployer/inventory.local ansible/playbook.yml --syntax-check
bash -n deployer/deploy.sh deployer/lib/*.sh
# Jinja render check uses Ansible's bundled jinja2; see the validation commands
# already exercised: vm.xml.j2 (5 NICs harvester / 1 rancher; source network vs
# bridge per mode) and harvester-config.yaml.j2 (node1 create / node2 join, VIP .10).
```

## Blockers before first build

- **OVMF paths unconfirmed.** `ovmf_code` and `ovmf_vars_template` in
  `ansible/roles/vms/defaults/main.yml` are set to `FIXME_*` placeholders.
  Run `rpm -ql qemu-ovmf-x86_64 | grep bin` on the SLES 16 target host and
  update both. If left as-is, libvirt will reject the VM XML and the `vms`
  role fails before any VM starts.

## Open items / things only verifiable on a real SLES 16 host

- Nothing has been run end-to-end; the custom Instruqt image has never been built.
  Verify on a live host: firewalld masquerade/DNAT return path; bridge mode; the
  Rancher NodePort `30002` patch on the rancher svc; the Harvester import going
  Active via `server-url` on `:30002`.
- **Harvester node SSH (keys-only)**: confirm on a live host that the ed25519 key
  baked into nodes via `os.ssh_authorized_keys` is accepted and the `rancher` user
  has passwordless sudo.
- **aerogrid.com DNS**: libvirt dnsmasq and RKE2 CoreDNS patch not yet verified
  on a live host. Confirm with `dig alpha.aerogrid.com @192.168.122.1` from a
  Harvester node and `kubectl exec` into a pod to check `nslookup`.
- MTU: RKE2 auto-shrinks the overlay MTU on a 1500 bridge, so no host change; suspect
  MTU only if large inter-node transfers ever hang.

## Project conventions

- After any technical change, the repo's `CLAUDE.md` mandates a `virt-reviewer` pass
  before closing. (Note: `CLAUDE.md` is gitignored and local-only.)
- Two `virt-reviewer` passes and template/syntax validation were run for the changes on
  this branch; findings were addressed.
- Secrets live only in gitignored `deployer/deploy.env` / `deploy.vars.yml`; a global
  gitleaks pre-push hook is active.

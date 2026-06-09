# SUSE Virtualization Rodeo — Architecture Reference

Nested KVM on Instruqt. Students get three browser tabs pointing at live UIs. This document explains the full stack: what runs where, how traffic reaches the student, and what needs to be right in the image for it to work.

**Versions:** Harvester 1.8.0 · Rancher Prime 2.13.1 (K3s) · SLES 16 host (modular libvirt daemons)

---

## Stack Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│  INSTRUQT SANDBOX                                                       │
│                                                                         │
│  ┌──────────────────────────────────────┐   ┌──────────────────────┐   │
│  │  VM: geekohive (n2-standard-32)     │   │  Container:          │   │
│  │  SLES 16 + KVM + nested virt        │   │  cloud-client        │   │
│  │                                      │   │  (gcr.io/instruqt/   │   │
│  │  ┌────────────────────────────────┐  │   │   cloud-client)      │   │
│  │  │  KVM guests — virbr0 NAT      │  │   │                      │   │
│  │  │  192.168.122.0/24             │  │   │  nginx proxy         │   │
│  │  │  eth0=mgmt  eth1-4=storage/   │  │   │  :90  → Harvester    │   │
│  │  │  migration/service1/service2 │  │   │                      │   │
│  │  │                               │  │   │  :91  → Rancher      │   │
│  │  │  harvester1  192.168.122.11   │  │   │  :92  → alien-geeko  │   │
│  │  │  harvester2  192.168.122.12   │  │   │                      │   │
│  │  │  harvester3  192.168.122.13   │  │   │  kubectl context:    │   │
│  │  │                               │  │   │  Harvester API       │   │
│  │  │  rancher     192.168.122.9    │  │   │  via Rancher proxy   │   │
│  │  │  (K3s + Rancher Prime 2.13.1) │  │   │                      │   │
│  │  │                               │  │   │  SSH keypair         │   │
│  │  │  Harvester UI: :8443          │  │   │  for guest VMs       │   │
│  │  │  Rancher UI:   :30002 (NodePort)│  │   └──────────────────────┘   │
│  │  └────────────────────────────────┘  │                               │
│  └──────────────────────────────────────┘                               │
│                                                                         │
│  geekohive and cloud-client share Instruqt's internal DNS              │
│  cloud-client resolves "geekohive" directly                            │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## How UI Tabs Reach the Student

Instruqt exposes container ports as browser tabs. The `cloud-client` container is the reverse proxy for everything.

```
Student browser
    │
    │  Tab: Harvester UI       Tab: Rancher UI        Tab: AeroGrid NOC
    │  cloud-client:90         cloud-client:91         cloud-client:92
    │         │                       │                       │
    ▼         ▼                       ▼                       ▼
┌─────────────────────────────────────────────────────────────────────┐
│  cloud-client  nginx (reverse proxy)                                │
│                                                                     │
│  :90  →  https://geekohive:8443     (Harvester UI, TLS passthru)  │
│  :91  →  https://geekohive:30002    (Rancher UI NodePort, TLS)     │
│  :92  →  kubectl port-forward        (alien-geeko svc, TCP)         │
│          (student runs this manually in challenge 06)               │
└─────────────────────────────────────────────────────────────────────┘
                     │                       │
                     ▼                       ▼
              geekohive:8443         geekohive:30002
              (firewalld DNAT         (firewalld DNAT
               → 192.168.122.10:443)   → 192.168.122.9:30002)
                     │                       │
                     ▼                       ▼
             Harvester VIP              Rancher NodePort
             (floating, kube-vip)       (K3s single-node)
```

**Port 92 is different.** It is not proxied by nginx at track startup. The student runs `kubectl port-forward` in challenge 06, which forwards `cloud-client:92` → `checkin-cluster` svc `alien-geeko:80` → container port 3000. The Instruqt tab just points at `cloud-client:92` and waits.

---

## Network Topology Inside geekohive

One libvirt NAT network (virbr0) carries all traffic. Static MAC-to-IP DHCP reservations ensure the same IPs survive every reboot — critical because Harvester's etcd encodes node IPs at cluster formation time.

```
geekohive (host)
│
├── virbr0  (libvirt NAT — 192.168.122.0/24)
│   Harvester floating VIP (kube-vip):  192.168.122.10  ← not a node, not in DHCP
│   DHCP reservations (eth0 management MACs — static, below dynamic pool):
│   ├── harvester1   02:00:00:0D:62:E1   192.168.122.11
│   ├── harvester2   02:00:00:0D:62:E2   192.168.122.12
│   ├── harvester3   02:00:00:0D:62:E3   192.168.122.13
│   └── rancher      02:00:00:0D:62:E9   192.168.122.9
│   Dynamic DHCP pool: 192.168.122.100-254 (kept clear of static IPs below .100)
│
│   eth1–eth4 MACs (storage/migration/service1/service2) also on virbr0 —
│   no DHCP reservations needed; Harvester manages these NICs post-install.
│   VM LoadBalancer IPs (192.168.122.200-220) are ARP-announced on eth3/eth4
│   (service network NICs) and are directly reachable from geekohive.
│
└── firewalld port-forwarding (nftables backend, permanent rules)
    :8443  → 192.168.122.10:443    (Harvester VIP — Harvester serves on 443)
    :30002 → 192.168.122.9:30002   (Rancher K3s NodePort)
    :30001 → 192.168.122.9:30001   (Rancher NodePort alt)
```

Harvester forms a 3-node cluster. The management VIP `192.168.122.10` is a **floating address held by kube-vip** — it is not any node's IP. kube-vip keeps it on a healthy node and moves it to a survivor if the holder goes down, so the API and UI stay reachable as long as any node is up. firewalld on `geekohive` forwards host port 8443 to the VIP on 443 (Harvester's management port; NAT mode); if the VIP migrates, traffic follows automatically. SLES 16 firewalld uses the nftables backend, so the DNAT is native firewalld port-forwarding — no raw iptables and no custom systemd unit.

### RKE2 cluster networking (Harvester internals)

Harvester runs **RKE2** under the hood. The three nodes form the entire control
plane and data plane across the bridge they share (virbr0 in NAT mode). The
node-to-node ports that must work between them include:

```
9345/tcp        RKE2 supervisor / node registration
6443/tcp        kube-apiserver
2379-2381/tcp   etcd client / peer / metrics
10250/tcp       kubelet
8472/udp        Canal VXLAN (pod overlay)
6081/udp        Kube-OVN Geneve (VM networks)
```

These are **between the guests**, not exposed on the host. Three host-level
measures keep them safe (all in `/etc/sysctl.d/99-harvester-rke2.conf` and the
firewalld config):

- **Bridge-netfilter off** (`net.bridge.bridge-nf-call-iptables=0`, etc.).
  Node-to-node traffic is L2-bridged; this keeps the host firewall from ever
  diverting and dropping it.
- **Reverse-path filtering loose** (`net.ipv4.conf.all.rp_filter=2`). Each node
  has five NICs on one subnet, and the kube-vip VIP plus the ARP-announced
  LoadBalancer IPs (`192.168.122.200-220`) create asymmetric return paths that
  strict rp_filter would drop.
- **firewalld libvirt-zone accept** for the node subnet (`192.168.122.0/24`), as
  a belt-and-braces accept even if bridge-netfilter is turned on elsewhere.

The guest OS firewall is the Harvester installer's responsibility, not the host
role. In bridge mode the same sysctl measures apply; make sure the host bridge
itself is not firewall-filtered on your LAN.

Two related notes: the guest NICs in `vm.xml.j2` carry **no `<filterref>`**, so
libvirt's `clean-traffic` anti-spoof is not bound — required for the Kube-OVN VM
traffic and the LB IPs whose MACs are not in libvirt's DHCP table. And the
overlay (Canal VXLAN +50B, Kube-OVN Geneve +58B) runs inside the guests over a
1500-MTU bridge; RKE2 auto-shrinks the pod/overlay MTU, so no host MTU change is
needed — but suspect MTU first if large-payload inter-node transfers ever hang.

---

## KVM Guest Configuration (per Harvester node)

```
cpu_mode:   host-passthrough   ← mandatory; enables KubeVirt to run VMs inside Harvester
nic_model:  e1000              ← avoids driver fingerprinting during install
boot:       UEFI (OVMF)
disks:
  vda:  270 GB qcow2 (preallocation=metadata)  ← OS partitions (~173 GB) + Longhorn (~97 GB)
nics:
  eth0: virbr0  management   02:00:00:0D:62:Ex  static IP from installer, cluster API
  eth1: virbr0  storage      02:00:00:0D:63:Ex  Longhorn storage traffic
  eth2: virbr0  migration    02:00:00:0D:64:Ex  KubeVirt live migration
  eth3: virbr0  service1     02:00:00:0D:65:Ex  Kube-OVN OVN uplink, primary VM networks
  eth4: virbr0  service2     02:00:00:0D:66:Ex  Kube-OVN second uplink / additional VM network
```

All five NICs share virbr0 (lab constraint — single bridge). In production each NIC would be on a dedicated physical switch or VLAN. eth0 has a libvirt DHCP static reservation; eth1–eth4 are managed post-install by Harvester. VM LoadBalancer IPs (192.168.122.200-220) are ARP-announced on eth3/eth4.

Longhorn V2 data engine must remain **disabled** — SPDK requires NVMe and does not work on virtio-blk in nested KVM. V1 data engine works correctly.

---

## Rancher VM Configuration

```
CPU:  4 vCPU
RAM:  16 GiB
Disk: 60 GB qcow2
NIC:  virbr0 only (management, 192.168.122.9)
Runtime:
  K3s single-node (not RKE2 — lighter, boots in 2-4 min from snapshot)
  Rancher Prime 2.13.1 via Helm
  Harvester cluster pre-imported (not provisioned — imported existing)
```

K3s is installed with traefik disabled, so Rancher is **not** reachable on `:443`.
`setup-rancher.sh` creates a NodePort service (`rancher-nodeport` in `cattle-system`,
nodePort `30002` → the rancher service's https targetPort) to expose it. All
setup-time Rancher API calls, the agent `server-url`, the host DNAT, and the
cloud-client proxy therefore use `192.168.122.9:30002`.

---

## Instruqt config.yml Roles

```yaml
virtualmachines:
  - name: geekohive
    image: suse/suse-virt-rodeo-180     # pre-built image with KVM VMs inside
    machine_type: n2-standard-32         # 32 vCPU, 128 GiB
    enable_nested_virtualization: true   # required for KubeVirt inside Harvester
    allow_external_ingress:
      - high-ports
      - http
      - https

containers:
  - name: cloud-client
    image: gcr.io/instruqt/cloud-client
    ports: [80, 90, 91, 92]             # 90=Harvester, 91=Rancher, 92=alien-geeko
    memory: 2048
```

`high-ports` on geekohive is for direct SSH/debug access during development. UI traffic always goes through `cloud-client`.

---

## Setup Script Sequence

### setup-geekohive (track-level, runs once)

```
1. Wait for /opt/instruqt/bootstrap/host-bootstrap-completed
2. virsh start harvester1 → sleep 15 → harvester2 → sleep 15 → harvester3 → sleep 15 → rancher
3. Wait: kubectl get nodes (KUBECONFIG=/root/.kube/harvester.yaml) → 3 Ready
   Timeout: 90 minutes. Progress logged every 120s.
4. sleep 30  (EFI first-boot settle before touching CDROMs)
5. virsh change-media --eject --live --config sda + sdb on all 3 Harvester nodes
   (prevents re-install loop if EFI variables are ever lost)
6. Wait: Rancher API /v3 responds (30-minute timeout)
7. Read /root/rancher-password — fail with clear error if missing
8. agent variable set RANCHER_TOKEN, RANCHER_URL, RANCHER_PASSWORD,
                       HARVESTER_URL, HARVESTER_NAT_IP, HARVESTER_PASSWORD
```

**Image requirements:**
- `/root/.kube/harvester.yaml` — kubeconfig pointing at the Harvester API via the VIP (192.168.122.10:6443)
- `/root/rancher-password` — admin password for Rancher (must exist; no fallback)
- KVM VMs pre-defined in libvirt XML (shut off, not suspended)
- KVM VMs have stable UUIDs (set in `ansible/roles/vms/defaults/main.yml`)
- firewalld permanent port-forwards (NAT mode) DNATing the UI ports to the guests
- Harvester already imported into Rancher (not provisioned — import model)
- Harvester UI plugin v1.8.0 installed in Rancher
- openSUSE Leap 16 qcow2 image pre-loaded into Harvester
- Serial console logs at `/var/log/libvirt/qemu/<vm>_serial.log` (file-based, not pty)

### setup-cloud-client (track-level, runs once)

```
1. Wait for RANCHER_TOKEN agent variable
2. Write /etc/nginx/conf.d/harvester-proxy.conf
   :90 → https://geekohive:8443  (Harvester UI)
   :91 → https://geekohive:30002 (Rancher UI)
3. nginx -s reload
4. Build kubectl context: Harvester API via Rancher proxy
5. SSH keygen + register public key as Harvester KeyPair resource
6. Write ~/.ssh/config for virt* hosts
```

Port 92 is not configured here. The student opens it in challenge 06.

---

## Challenge-by-Challenge Tab Requirements

| # | Challenge | Terminal | Harvester UI (90) | Rancher UI (91) | Nostromo (92) |
|---|-----------|----------|-------------------|-----------------|---------------|
| 01 | Intro / cluster online | yes | yes | yes | no |
| 02 | First VM | yes | yes | yes | no |
| 03 | Networking | yes | yes | yes | no |
| 04 | Storage / snapshots | yes | yes | yes | no |
| 05 | Rancher + K3s | yes | no | yes | no |
| 06 | AeroGrid NOC dashboard | yes | yes | yes | **yes** |

---

## Resource Budget

```
geekohive: n2-standard-32 (32 vCPU, 128 GiB RAM)

  harvester1:  8 vCPU  24 GiB  vda=270 GB
  harvester2:  8 vCPU  24 GiB  vda=270 GB
  harvester3:  8 vCPU  24 GiB  vda=270 GB
  rancher:     4 vCPU  16 GiB  60 GB
  ─────────────────────────────────────────────────────
  Total KVM:  28 vCPU  88 GiB
  Host overhead: 4 vCPU, ~8 GiB
  Remaining:  0 vCPU slack, ~32 GiB RAM headroom

Disk (qcow2, preallocation=metadata, 950 GB GCP pd-ssd):
  host root:  40 GB
  3 × 270 GB Harvester + 60 GB Rancher = 870 GB provisioned
  Headroom: ~40 GB
  Actual consumed after fresh install: ~300-350 GB (thin-provisioned)
  Harvester partition layout per node: ~173 GB OS + ~97 GB Longhorn (HARV_LH_DEFAULT)
  Longhorn usable per node (after 30% reserve): ~68 GB
```

Note: 24 GiB per Harvester node is below the official 32 GiB production minimum but is proven to work for dev/lab clusters. The Harvester reference HCIAB uses 16 GiB per node.

---

## What Must Be Baked Into the Image

These cannot be done at sandbox startup — too slow or require pre-provisioning:

| Item | Why it must be baked |
|------|---------------------|
| Harvester 1.8.0 — 3-node cluster, fully formed | Bootstrap takes 45-90 min |
| Rancher Prime 2.13.1 on K3s — Harvester imported | Import flow is interactive |
| `/root/.kube/harvester.yaml` | Generated after cluster forms |
| `/root/rancher-password` | Set during image prep |
| Harvester UI plugin v1.8.0 in Rancher | Must match Harvester version exactly |
| openSUSE Leap 16 qcow2 image in Harvester | Download during startup would stall students |
| firewalld permanent port-forwards (8443/30002/30001 → guests) | Must survive reboots |
| KVM VMs defined in libvirt XML | shut off, not suspended |
| virbr0 (default libvirt network) with DHCP MAC reservations for eth0 NICs | Fixed IPs required for etcd stability |
| Longhorn V2 data engine disabled | SPDK incompatible with nested KVM |

---

## Image Build Process

This image is built inside Instruqt itself using a dedicated builder track. The build track uses a plain SLES 16 base image, runs the Ansible playbook, then installs Harvester and Rancher manually via the procedures below. The resulting VM is saved as a custom image in the `suse` Instruqt org.

The same Ansible roles drive the cloud/bare-metal `deployer/` (no Instruqt). See `deployer/README.md`.

See `builder/` directory for the builder track config and Ansible playbook.

### Build sequence

```
1. Spin up builder track (SLES 16, n2-standard-32, nested virt enabled)
2. Clone repo, install Ansible collections:
     ansible-galaxy collection install -r ansible/requirements.yml
3. Run the full Ansible playbook (kvm_host + vms roles):
     ansible-playbook -i deployer/inventory.local ansible/playbook.yml
   This configures the KVM host AND prepares all VM assets:
   - libvirt network (virbr0) redefined with static DHCP entries
   - 3x 270 GB Harvester qcow2 disks + 60 GB Rancher disk
   - Harvester 1.8.0 ISO downloaded
   - Per-node Harvester config ISOs rendered from template
   - Rancher cloud-init ISO generated
   - All 4 VMs defined in libvirt XML (not yet started)
4. Start VMs and wait for Harvester install:
     cd builder && ./deploy-vms.sh
   Monitor install progress (serial is file-based — no virsh console):
     tail -f /var/log/libvirt/qemu/harvester1_serial.log
5. Wait for 3-node cluster to form (40-90 min total)
6. Run: ./setup-rancher.sh
   Installs K3s + Rancher Prime 2.13.1, imports Harvester cluster,
   ejects installer ISOs from all Harvester VMs
7. Install Harvester UI plugin v1.8.0 in Rancher
8. Pre-load openSUSE Leap 16 image into Harvester
9. Shut off all KVM VMs: virsh shutdown harvester1 harvester2 harvester3 rancher
10. Save image via Instruqt CLI: instruqt track image create
```

---

## alien-geeko: How Port 92 Gets to the Student

```
checkin-cluster K3s cluster (VM running on Harvester)
  └── alien-geeko Deployment (docker.io/avaleror/alien-geeko:latest)
        └── Service type=LoadBalancer
              └── External IP from rodeo-ippool (192.168.122.200-220)

cloud-client container
  └── kubectl port-forward svc/alien-geeko 92:80 --address=0.0.0.0 &
        └── tunnels cloud-client:92 → alien-geeko svc:80 → pod:3000

Instruqt tab "AeroGrid NOC"
  └── points at cloud-client:92
        └── student sees NOC dashboard — empty until port-forward runs
```

The student runs the port-forward in challenge 06. This is intentional: it is the final step of bringing the AeroGrid NOC dashboard live.

---

## Image Build Checklist

**Host layer (Ansible roles):**
- [ ] `ansible-playbook -i deployer/inventory.local ansible/playbook.yml` (kvm_host + vms roles)
- [ ] `cat /sys/module/kvm_intel/parameters/nested` → `Y`
- [ ] `virsh net-list --all` → virbr0 (default) active; each Harvester node has 5 NICs (eth0–eth4) on virbr0
- [ ] `firewall-cmd --zone=public --list-ports` → 8443/tcp 30001/tcp 30002/tcp
- [ ] `firewall-cmd --zone=public --list-forward-ports` → 8443→VIP, 30002/30001→Rancher
- [ ] modular libvirt daemons active: `systemctl is-active virtqemud.socket virtnetworkd.socket`

**Harvester cluster:**
- [ ] 3 Harvester 1.8.0 nodes installed and clustered
- [ ] `kubectl get nodes --kubeconfig /root/.kube/harvester.yaml` → 3 Ready
- [ ] Harvester VIP responds: `curl -sk https://192.168.122.10/ping` (VIP serves on 443)
- [ ] VIP is floating, not a node IP: `ssh root@192.168.122.10 ip a` lands on the current leader

**Rancher:**
- [ ] K3s running on rancher VM (192.168.122.9)
- [ ] Rancher Prime 2.13.1 pods Ready in cattle-system namespace
- [ ] Harvester cluster visible in Rancher → Virtualization Management
- [ ] Harvester UI plugin v1.8.0 installed
- [ ] `/root/rancher-password` file exists with admin password

**Harvester content:**
- [ ] openSUSE Leap 16 qcow2 image imported (name: `default/leap16`)
- [ ] Longhorn V2 data engine disabled in Harvester settings
- [ ] Longhorn disk configured on each node: Harvester UI > Hosts > each node > Storage — add disk path `/var/lib/longhorn` if not auto-detected

**Shutdown and save:**
- [ ] All KVM VMs shut off: `virsh shutdown harvester1 harvester2 harvester3 rancher`
- [ ] Verify: `virsh list --all` → all show `shut off`
- [ ] Save image: `instruqt track image create --machine geekohive --image-name suse-virt-rodeo-180`

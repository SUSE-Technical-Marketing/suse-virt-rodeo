# SUSE Virtualization Rodeo — Architecture Reference

Nested KVM on Instruqt. Students get three browser tabs pointing at live UIs. This document explains the full stack: what runs where, how traffic reaches the student, and what needs to be right in the image for it to work.

**Versions:** Harvester 1.8.0 · Rancher Prime 2.13.1 (K3s) · SLES 15.6

---

## Stack Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│  INSTRUQT SANDBOX                                                       │
│                                                                         │
│  ┌──────────────────────────────────────┐   ┌──────────────────────┐   │
│  │  VM: geekohive (n2-standard-32)     │   │  Container:          │   │
│  │  SLES 15.6 + KVM + nested virt      │   │  cloud-client        │   │
│  │                                      │   │  (gcr.io/instruqt/   │   │
│  │  ┌────────────────────────────────┐  │   │   cloud-client)      │   │
│  │  │  KVM guests — virbr0 NAT      │  │   │                      │   │
│  │  │  192.168.122.0/24             │  │   │  nginx proxy         │   │
│  │  │  eth0=mgmt  eth1=vm-traffic   │  │   │  :90  → Harvester    │   │
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
              (iptables DNAT          (iptables DNAT
               → 192.168.122.11:8443)  → 192.168.122.9:30002)
                     │                       │
                     ▼                       ▼
             Harvester VIP              Rancher NodePort
             (harvester1 leader)        (K3s single-node)
```

**Port 92 is different.** It is not proxied by nginx at track startup. The student runs `kubectl port-forward` in challenge 06, which forwards `cloud-client:92` → `checkin-cluster` svc `alien-geeko:80` → container port 3000. The Instruqt tab just points at `cloud-client:92` and waits.

---

## Network Topology Inside geekohive

One libvirt NAT network (virbr0) carries all traffic. Static MAC-to-IP DHCP reservations ensure the same IPs survive every reboot — critical because Harvester's etcd encodes node IPs at cluster formation time.

```
geekohive (host)
│
├── virbr0  (libvirt NAT — 192.168.122.0/24)
│   DHCP reservations (eth0 management MACs only):
│   ├── harvester1   02:00:00:0D:62:E1   192.168.122.11
│   ├── harvester2   02:00:00:0D:62:E2   192.168.122.12
│   ├── harvester3   02:00:00:0D:62:E3   192.168.122.13
│   └── rancher      02:00:00:0D:62:E9   192.168.122.9
│
│   eth1 VM-traffic MACs (02:00:00:0D:64:E1/E2/E3) also on virbr0 — no DHCP
│   reservation needed; Harvester leaves eth1 unmanaged at OS level and uses
│   it as the Kube-OVN OVN bridge uplink for the "vms" cluster network.
│   VM LoadBalancer IPs (192.168.122.200-220) are ARP-announced on eth1 and
│   are directly reachable from geekohive without additional routing.
│
└── iptables DNAT rules (kvm-dnat.service, runs at boot)
    PREROUTING: :8443  → 192.168.122.11:8443   (Harvester VIP)
    PREROUTING: :30002 → 192.168.122.9:30002   (Rancher K3s NodePort)
    PREROUTING: :30001 → 192.168.122.9:30001   (Rancher NodePort alt)
```

Harvester forms a 3-node cluster. `harvester1` holds the VIP at `192.168.122.11` (kube-vip). The iptables DNAT on `geekohive` forwards port 8443 to that VIP. If the VIP migrates, traffic follows automatically.

---

## KVM Guest Configuration (per Harvester node)

```
cpu_mode:   host-passthrough   ← mandatory; enables KubeVirt to run VMs inside Harvester
nic_model:  e1000              ← avoids driver fingerprinting during install
boot:       UEFI (OVMF)
disks:
  vda:  250 GB qcow2  ← OS + Harvester system volumes + Longhorn (/var/lib/longhorn)
nics:
  eth0: virbr0 (management, 02:00:00:0D:62:Ex — static IP set by Harvester installer)
  eth1: virbr0 (VM traffic, 02:00:00:0D:64:Ex — no OS IP; Kube-OVN OVN bridge uplink)
```

Both NICs share virbr0 so VM LoadBalancer IPs (192.168.122.200-220) are directly reachable from geekohive. eth1 carries no IP at the OS level — Harvester's Kube-OVN uses it as a raw bridge uplink for the "vms" cluster network.

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
2. virsh start harvester1 → sleep 10 → harvester2 → harvester3 → rancher
3. Wait: kubectl get nodes (KUBECONFIG=/root/.kube/harvester.yaml) → 3 Ready
4. Wait: Rancher API /v3 responds
5. Read /root/rancher-password → login → get RANCHER_TOKEN
6. agent variable set RANCHER_TOKEN, RANCHER_URL, RANCHER_PASSWORD, HARVESTER_URL
```

**Image requirements:**
- `/root/.kube/harvester.yaml` — kubeconfig pointing at Harvester API (192.168.122.11:6443)
- `/root/rancher-password` — admin password for Rancher
- KVM VMs pre-defined in libvirt XML (shut off, not suspended)
- iptables DNAT rules in `kvm-dnat.service`
- Harvester already imported into Rancher (not provisioned — import model)
- Harvester UI plugin v1.8.0 installed in Rancher
- openSUSE Leap 16 qcow2 image pre-loaded into Harvester

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

  harvester1:  8 vCPU  24 GiB  vda=250 GB
  harvester2:  8 vCPU  24 GiB  vda=250 GB
  harvester3:  8 vCPU  24 GiB  vda=250 GB
  rancher:     4 vCPU  16 GiB  60 GB
  ─────────────────────────────────────────────────────
  Total KVM:  28 vCPU  88 GiB
  Host overhead: 4 vCPU, ~8 GiB
  Remaining:  0 vCPU slack, ~32 GiB RAM headroom

Disk (thin-provisioned qcow2):
  3 × 250 GB + 60 GB Rancher = ~810 GB allocated
  Actual consumed after fresh install: ~250-350 GB
  Minimum per node: 250 GB (Harvester 1.8.0 requirement)
  Longhorn uses /var/lib/longhorn on the OS disk — no dedicated data disk needed for lab use
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
| `kvm-dnat.service` systemd unit + firewalld rules | Must survive reboots |
| KVM VMs defined in libvirt XML | shut off, not suspended |
| virbr0 (default libvirt network) with DHCP MAC reservations for eth0 NICs | Fixed IPs required for etcd stability |
| Longhorn V2 data engine disabled | SPDK incompatible with nested KVM |

---

## Image Build Process

This image is built inside Instruqt itself using a dedicated builder track. The build track uses a plain SLES 15.6 base image, runs the Ansible playbook, then installs Harvester and Rancher manually via the procedures below. The resulting VM is saved as a custom image in the `suse` Instruqt org.

See `builder/` directory for the builder track config and Ansible playbook.

### Build sequence

```
1. Spin up builder track (SLES 15.6, n2-standard-32, nested virt enabled)
2. Run: ansible-playbook -i "localhost," -c local ansible/playbook.yml
3. Deploy Harvester VMs via virsh (see builder/deploy-vms.sh)
4. Install Harvester 1.8.0 on all 3 nodes (iPXE or ISO, unattended)
5. Wait for 3-node cluster to form
6. Install K3s + Rancher 2.13.1 on rancher VM
7. Import Harvester into Rancher
8. Install Harvester UI plugin v1.8.0
9. Pre-load openSUSE Leap 16 image into Harvester
10. Shut off all KVM VMs (virsh shutdown --all)
11. Save image via Instruqt CLI: instruqt track image create
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

**Host layer (Ansible role):**
- [ ] `ansible-playbook -i "localhost," -c local ansible/playbook.yml`
- [ ] `cat /sys/module/kvm_intel/parameters/nested` → `Y`
- [ ] `virsh net-list --all` → virbr0 (default) active; each Harvester node has eth0 + eth1 on virbr0
- [ ] `systemctl status kvm-dnat` → active (exited)
- [ ] `firewall-cmd --zone=public --list-ports` → 8443/tcp 30001/tcp 30002/tcp

**Harvester cluster:**
- [ ] 3 Harvester 1.8.0 nodes installed and clustered
- [ ] `kubectl get nodes --kubeconfig /root/.kube/harvester.yaml` → 3 Ready
- [ ] Harvester VIP responds: `curl -sk https://192.168.122.11:8443/ping`

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

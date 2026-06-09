# Builder: suse-virt-rodeo-180

This directory contains everything needed to build the custom Instruqt image
`suse/suse-virt-rodeo-180`. That image is the starting point for every participant
in the SUSE Virtualization Rodeo track — they get a pre-installed, pre-clustered
environment with no waiting.

## What the image contains

- SLES 16 host OS (geekohive VM) — modular libvirt daemons, SELinux, firewalld/nftables
- KVM + libvirt + supporting tools
- 3x Harvester 1.8.0 nodes (harvester1, harvester2, harvester3) — clustered, shut off
- 1x Rancher Prime 2.13.1 on K3s (rancher VM) — Harvester already imported, shut off
- All disk images in `/var/lib/libvirt/images/`
- Each Harvester node has five NICs on virbr0: eth0 (management) + eth1-4
  (storage / migration / service1 / service2)
- Serial console logs at `/var/log/libvirt/qemu/<vm>_serial.log` (file-based)

## Files

| File | Purpose |
|---|---|
| `config.yml` | Instruqt config for the builder sandbox VM |
| `track.yml` | Instruqt track YAML (slug: suse-virt-rodeo-builder) |
| `01-build/assignment.md` | Step-by-step instructions for the image builder |
| `deploy-vms.sh` | Starts KVM VMs in sequence and waits for Harvester bootstrap |
| `setup-rancher.sh` | Installs K3s + Rancher Prime, imports Harvester, ejects installer ISOs |
| `harvester-config-node1/2/3.yaml` | Reference copies of Harvester unattended configs (superseded by Ansible template) |

VM assets (disks, ISOs, config ISOs, OVMF vars, cloud-init) are now created by the
`ansible/roles/vms/` role. `deploy-vms.sh` only starts VMs and waits for install.

## Ansible role structure

```
ansible/
├── playbook.yml              # runs kvm_host + vms roles in sequence
├── inventory.example         # localhost connection for builder
├── requirements.yml          # community.libvirt, community.general, ansible.posix
└── roles/
    ├── kvm_host/             # packages, libvirt config, DNAT, firewall
    └── vms/                  # network, storage pool, disk images, ISOs, VM definitions
        ├── defaults/main.yml # libvirt_flavors dict, vm_nodes list (MACs, IPs, UUIDs)
        ├── tasks/
        │   ├── network_setup.yml   # redefine virbr0 with static DHCP entries
        │   ├── storage_setup.yml   # ensure default storage pool exists
        │   ├── images.yml          # ISO download, qcow2 creation, config ISOs
        │   └── vm_setup.yml        # define VMs from template (idempotent)
        └── templates/
            ├── network.xml.j2              # NAT network, DHCP .100-.254, static host entries
            ├── vm.xml.j2                   # VM XML with serial file logging, EFI for Harvester
            ├── harvester-config.yaml.j2    # per-node unattended install config
            ├── cloud-init-meta-data.j2     # Rancher VM cloud-init meta-data
            ├── cloud-init-user-data.j2     # Rancher VM cloud-init user-data (SSH key, password)
            └── cloud-init-network-config.j2 # Rancher VM static IP config
```

## Network layout

All KVM traffic uses a single libvirt NAT network (virbr0, 192.168.122.0/24).
Each Harvester node has five NICs — all on virbr0 (lab single-bridge constraint).
Only eth0 (management) has a libvirt DHCP static reservation. eth1–eth4 are
managed post-install by Harvester.

```
virbr0 — 192.168.122.0/24
  Floating kube-vip VIP: 192.168.122.10  (not a node IP, not in DHCP)
  Static DHCP reservations (eth0 only, below dynamic pool):
  harvester1  eth0  02:00:00:0D:62:E1  192.168.122.11  management
              eth1  02:00:00:0D:63:E1  (no OS IP — storage / Longhorn)
              eth2  02:00:00:0D:64:E1  (no OS IP — migration / KubeVirt)
              eth3  02:00:00:0D:65:E1  (no OS IP — service net 1 / Kube-OVN uplink)
              eth4  02:00:00:0D:66:E1  (no OS IP — service net 2 / Kube-OVN uplink)
  harvester2  eth0  02:00:00:0D:62:E2  192.168.122.12
              eth1  02:00:00:0D:63:E2  ...  eth2  02:00:00:0D:64:E2  ...
              eth3  02:00:00:0D:65:E2  ...  eth4  02:00:00:0D:66:E2  ...
  harvester3  eth0  02:00:00:0D:62:E3  192.168.122.13
              eth1  02:00:00:0D:63:E3  ...  eth2  02:00:00:0D:64:E3  ...
              eth3  02:00:00:0D:65:E3  ...  eth4  02:00:00:0D:66:E3  ...
  rancher     eth0  02:00:00:0D:62:E9  192.168.122.9   management only

  Dynamic DHCP pool: 192.168.122.100-254
```

VM LoadBalancer IPs (rodeo-ippool: 192.168.122.200-220) are announced via ARP on
eth3/eth4 and are directly reachable from geekohive without additional routing rules.

## Prerequisites

Before running the builder track, confirm:

- The SLES 16 base image slug is `suse/sles-16-0` (verify in the Instruqt image catalog).
  If the slug differs, update `config.yml` before pushing the builder track.
- The builder sandbox must have nested virtualization enabled (already set in `config.yml`).
- Machine type `n2-standard-32` gives 32 vCPU and 128 GB RAM — required for all 4 VMs.
- `sshpass` and `jq` must be available on geekohive — `setup-rancher.sh` requires both.
  Install if missing: `zypper install -y sshpass jq`

## How to build the image

Full step-by-step instructions are in `01-build/assignment.md`. The high-level flow:

1. Spin up the builder track in Instruqt.
2. Clone this repo on geekohive.
3. Install Ansible collections:
   ```bash
   ansible-galaxy collection install -r ansible/requirements.yml
   ```
4. Run the Ansible playbook (configures host AND prepares all VM assets):
   ```bash
   ansible-playbook -i ansible/inventory.example ansible/playbook.yml
   ```
5. Start VMs and wait for Harvester install:
   ```bash
   cd builder && ./deploy-vms.sh
   ```
6. Run `builder/setup-rancher.sh` to install K3s + Rancher and import Harvester.
7. Upload the openSUSE Leap 16 cloud image into Harvester.
8. Shut off all VMs: `for vm in harvester1 harvester2 harvester3 rancher; do virsh shutdown $vm; done`
9. Save geekohive as `suse/suse-virt-rodeo-180` via the Instruqt console.
10. Update `config.yml` in the main rodeo track to use the new image.

## Monitoring install progress

Serial console output goes to files — `virsh console` is not available.

```bash
tail -f /var/log/libvirt/qemu/harvester1_serial.log
tail -f /var/log/libvirt/qemu/harvester2_serial.log
tail -f /var/log/libvirt/qemu/harvester3_serial.log
```

## Credentials written during build

| File on geekohive | Contents |
|---|---|
| `/root/rancher-password` | Rancher admin password (random, generated at build time) |
| `/root/harvester-token` | Harvester API bearer token |
| `/root/.ssh/id_rsa` | SSH key for geekohive → rancher VM access |

## Estimated build time

| Phase | Time |
|---|---|
| Ansible playbook (host + VM assets) | 10-15 min |
| harvester1 install + bootstrap | 25-40 min |
| harvester2 + harvester3 join | 20-30 min each |
| Rancher install + Harvester import | 15-20 min |
| Image upload + save | 10-30 min |
| **Total** | **~2-3 hours** |

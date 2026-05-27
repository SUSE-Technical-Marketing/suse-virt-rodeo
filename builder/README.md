# Builder: suse-virt-rodeo-180

This directory contains everything needed to build the custom Instruqt image
`suse/suse-virt-rodeo-180`. That image is the starting point for every participant
in the SUSE Virtualization Rodeo track — they get a pre-installed, pre-clustered
environment with no waiting.

## What the image contains

- SLES 15.6 host OS (geekohive VM)
- KVM + libvirt + supporting tools
- 3x Harvester 1.8.0 nodes (harvester1, harvester2, harvester3) — clustered, shut off
- 1x Rancher Prime 2.13.1 on K3s (rancher VM) — Harvester already imported, shut off
- All disk images in `/var/lib/libvirt/images/`
- Each Harvester node has two NICs on virbr0: eth0 (management) + eth1 (VM traffic)

## Files

| File | Purpose |
|---|---|
| `config.yml` | Instruqt config for the builder sandbox VM |
| `track.yml` | Instruqt track YAML (slug: suse-virt-rodeo-builder) |
| `01-build/assignment.md` | Step-by-step instructions for the image builder |
| `deploy-vms.sh` | Creates disks, downloads ISO, defines and starts KVM VMs |
| `setup-rancher.sh` | Installs K3s + Rancher Prime, imports Harvester |
| `harvester-config-node1.yaml` | Harvester unattended config — node1 (cluster create) |
| `harvester-config-node2.yaml` | Harvester unattended config — node2 (join) |
| `harvester-config-node3.yaml` | Harvester unattended config — node3 (join) |

The Ansible role at `ansible/roles/kvm_host/` handles KVM host setup.
`tasks/storage-network.yml` is present but unused — both NICs on Harvester nodes use virbr0 (the default libvirt network managed by the role).

## Network layout

All KVM traffic uses a single libvirt NAT network (virbr0, 192.168.122.0/24).
Each Harvester node has two NICs on virbr0:

```
virbr0 — 192.168.122.0/24
  harvester1  eth0  02:00:00:0D:62:E1  192.168.122.11  (management, kube-vip VIP)
              eth1  02:00:00:0D:64:E1  (no IP — Kube-OVN OVN bridge uplink)
  harvester2  eth0  02:00:00:0D:62:E2  192.168.122.12
              eth1  02:00:00:0D:64:E2  (no IP — Kube-OVN OVN bridge uplink)
  harvester3  eth0  02:00:00:0D:62:E3  192.168.122.13
              eth1  02:00:00:0D:64:E3  (no IP — Kube-OVN OVN bridge uplink)
  rancher     eth0  02:00:00:0D:62:E9  192.168.122.9   (management only)
```

VM LoadBalancer IPs (rodeo-ippool: 192.168.122.200-220) are announced via ARP on eth1
and are directly reachable from geekohive without additional routing rules.

## Prerequisites

Before running the builder track, confirm these in the Instruqt image catalog:

- The SLES 15.6 base image slug is `suse/sles-15sp6` (assumed — verify in the catalog).
  If the slug is different, update `config.yml` before pushing the builder track.
- The builder sandbox must have nested virtualization enabled (already set in `config.yml`).
- The `n2-standard-32` machine type gives 32 vCPU and 128 GB RAM, enough for all 4 VMs.

## How to build the image

Full step-by-step instructions are in `01-build/assignment.md`. The high-level flow:

1. Spin up the builder track in Instruqt.
2. Clone this repo on geekohive.
3. Run `ansible-playbook ansible/site.yml` to configure the KVM host.
4. Run `builder/deploy-vms.sh` to create disks, download the Harvester ISO, and start VMs.
5. Wait for Harvester to install (20-40 min per node, unattended).
6. Run `builder/setup-rancher.sh` to install K3s + Rancher and import Harvester.
7. Upload the openSUSE Leap 16 cloud image into Harvester.
8. Shut off all VMs with `virsh shutdown`.
9. Save geekohive as `suse/suse-virt-rodeo-180` via the Instruqt console.
10. Update `config.yml` in the main rodeo track to use the new image.

## Credentials written during build

| File on geekohive | Contents |
|---|---|
| `/root/rancher-password` | Rancher admin password (random, generated at build time) |
| `/root/harvester-token` | Harvester API bearer token |

## Estimated build time

| Phase | Time |
|---|---|
| Ansible + VM setup | 5-10 min |
| Harvester ISO download | 5 min |
| harvester1 install + bootstrap | 25-40 min |
| harvester2 + harvester3 join | 20-30 min each |
| Rancher install | 10-15 min |
| Harvester import + image upload | 10 min |
| **Total** | **~2.5-3.5 hours** |

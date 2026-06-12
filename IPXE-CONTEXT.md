## iPXE PXE Boot Implementation — Harvester Rodeo

### Objective
Configure geekohive (SLES 16 KVM host) to install Harvester 1.8.0 on 3 nested KVM guests via iPXE instead of ISO boot. Harvester 1.8.0 requires UEFI; legacy BIOS PXE is not supported.

### Components added

**New Ansible role:** `ansible/roles/pxe_server/`
Added to `ansible/playbook.yml` after the `vms` role.

**HTTP server:** nginx on `192.168.122.1:8080` (virbr0 IP only, not externally reachable).
Serves: vmlinuz, initrd, rootfs.squashfs, ISO symlink, per-node iPXE scripts, per-node Harvester config YAMLs.
Root: `/srv/harvester-pxe/` with subdirs `harvester/`, `ipxe/`, `config/`.

**TFTP server:** libvirt's built-in dnsmasq. No extra daemon.
TFTP root: `/var/lib/libvirt/dnsmasq/`. Contains only `ipxe.efi` (downloaded from `https://boot.ipxe.org/x86_64-efi/ipxe.efi`).

**Libvirt network XML:** `ansible/roles/pxe_server/templates/network-pxe.xml.j2`
Extends the vms role's `network.xml.j2` with `xmlns:dnsmasq` namespace options. Redefines the `default` libvirt network idempotently (skips if `dnsmasq:options` already present in `virsh net-dumpxml` output).

**Firewall:** TFTP service allowed in the libvirt firewalld zone (`immediate: true`).

### Two-stage iPXE boot flow

```
Stage 1 — UEFI firmware (no iPXE user-class):
  DHCP request → dnsmasq matches tag:!ipxe → boot file: ipxe.efi (TFTP)

Stage 2 — iPXE loaded (user-class=iPXE):
  DHCP request → dnsmasq matches tag:pxe_<nodename> + tag:ipxe
               → boot file: http://192.168.122.1:8080/ipxe/<nodename> (HTTP)
  iPXE script runs:
    dhcp
    kernel http://.../harvester-v1.8.0-vmlinuz-amd64 [cmdline]
    initrd http://.../harvester-v1.8.0-initrd-amd64
    boot
```

### dnsmasq routing (network-pxe.xml.j2)

```
dhcp-userclass=set:ipxe,iPXE
dhcp-boot=tag:!ipxe,ipxe.efi                          ← stage 1 (all UEFI hosts)
dhcp-host=02:00:00:0D:62:E1,set:pxe_harvester1        ← MAC tag per node
dhcp-host=02:00:00:0D:62:E2,set:pxe_harvester2
dhcp-host=02:00:00:0D:62:E3,set:pxe_harvester3
dhcp-boot=tag:pxe_harvester1,tag:ipxe,http://192.168.122.1:8080/ipxe/harvester1
dhcp-boot=tag:pxe_harvester2,tag:ipxe,http://192.168.122.1:8080/ipxe/harvester2
dhcp-boot=tag:pxe_harvester3,tag:ipxe,http://192.168.122.1:8080/ipxe/harvester3
```

The MAC tags coexist with the existing `<host mac=... ip=... name=.../>` DHCP reservations in the `<dhcp>` block. dnsmasq supports multiple `dhcp-host` entries per MAC.

### Per-node iPXE scripts (`ipxe/harvester{1,2,3}`)

Template: `ansible/roles/pxe_server/templates/ipxe-node.j2`

Key kernel parameters:
```
ip=dhcp rd.net.dhcp.retry=30 rd.cos.disable rd.noverifyssl net.ifnames=1
root=live:http://192.168.122.1:8080/harvester/harvester-v1.8.0-rootfs-amd64.squashfs
console=ttyS0,115200n8
harvester.install.automatic=true
harvester.install.skipchecks=true
harvester.install.config_url=http://192.168.122.1:8080/config/config-<nodename>.yaml
```

`dhcp` must be the first iPXE command — iPXE initialises its own network stack independently of UEFI.

### Per-node Harvester config YAMLs (`config/config-harvester{1,2,3}.yaml`)

Template: `ansible/roles/pxe_server/templates/config-node.yaml.j2`
Mirrors `ansible/roles/vms/templates/harvester-config.yaml.j2` with two additions:
- `iso_url: http://192.168.122.1:8080/harvester/harvester-v1.8.0-amd64.iso` (installer fetches ISO over HTTP)
- `tty: ttyS0`

harvester1: `mode: create`, static IP `.11`, VIP `.10`, `server_url: ""`
harvester2: `mode: join`, static IP `.12`, `server_url: https://192.168.122.10:443`
harvester3: `mode: join`, static IP `.13`, `server_url: https://192.168.122.10:443`
All nodes: `management_interface.interfaces[0].name: eth0`, `method: static`

### VM boot order change (`ansible/roles/vms/templates/vm.xml.j2`)

Before: Harvester ISO CDROM `boot order='1'`, vda disk `boot order='2'`
After: vda disk `boot order='1'`, mgmt NIC eth0 `boot order='2'`, ISO CDROM has no boot order

Rationale: disk-first prevents re-installation on every reboot. On first boot the qcow2 is empty so UEFI finds no bootloader, falls through to NIC → iPXE → install. After Harvester writes its bootloader, subsequent reboots go straight to disk.

### Variables loaded at runtime

`ansible/roles/pxe_server/tasks/main.yml` loads `ansible/roles/vms/defaults/main.yml` via `include_vars` so the pxe_server role has access to `vm_nodes`, `harvester_version`, `harvester_token`, `harvester_os_password`, `libvirt_network_*`, `image_dir`, etc. without duplicating them.

### File layout on geekohive after provisioning

```
/var/lib/libvirt/dnsmasq/
└── ipxe.efi

/srv/harvester-pxe/
├── harvester/
│   ├── harvester-v1.8.0-vmlinuz-amd64
│   ├── harvester-v1.8.0-initrd-amd64
│   ├── harvester-v1.8.0-rootfs-amd64.squashfs
│   └── harvester-v1.8.0-amd64.iso  → symlink to /var/lib/libvirt/images/
├── ipxe/
│   ├── harvester1
│   ├── harvester2
│   └── harvester3
└── config/
    ├── config-harvester1.yaml
    ├── config-harvester2.yaml
    └── config-harvester3.yaml
```

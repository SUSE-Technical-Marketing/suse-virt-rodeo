# Guide: Converting SLES 16 into a KVM hypervisor

This guide sets up SUSE Linux Enterprise Server 16 (or openSUSE Leap 16) as a KVM
virtualization host. SLES 16 ships the modular libvirt daemons, NetworkManager,
and SELinux, so the steps differ from SLES 15.

For the SUSE Virtualization Rodeo specifically, you do not need to follow this by
hand. The `kvm_host` Ansible role and the `deployer/` do all of it. Use this guide
when you want to understand the host setup or build one manually.

---

## Step 1: Verify hardware support

Confirm the CPU and kernel support virtualization.

- **CPU virtualization:** `lscpu | grep Virtualization` shows VT-x or AMD-V.
- **Kernel modules:** `lsmod | grep kvm` shows `kvm_intel` or `kvm_amd` loaded.
- **Nested (for VMs inside VMs):** `cat /sys/module/kvm_intel/parameters/nested` returns `Y`.

## Step 2: Install the KVM patterns

SLES uses patterns to pull the validated hypervisor stack. The pattern names are
unchanged on SLES 16.

```bash
sudo zypper install -t pattern kvm_server kvm_tools
sudo zypper install qemu-ovmf-x86_64 xorriso jq
```

`qemu-ovmf-x86_64` gives the UEFI firmware. `xorriso` builds seed ISOs (genisoimage
is gone on SLES 16).

## Step 3: Enable the modular libvirt daemons

SLES 16 no longer runs the monolithic `libvirtd` by default. It uses modular
daemons, each socket-activated. Enable the sockets:

```bash
sudo systemctl enable --now \
  virtqemud.socket virtnetworkd.socket virtstoraged.socket \
  virtnodedevd.socket virtsecretd.socket virtlogd.socket
```

`virtqemud` is the QEMU/KVM driver. The others cover networking, storage, host
devices, secrets, and logging. Restarting `virtqemud` does not interrupt running
guests.

## Step 4: Network bridge with NetworkManager

SLES 16 uses NetworkManager only (wicked is removed). A bridge lets guests appear
as nodes on your physical LAN. For a self-contained host you can skip this and use
libvirt's default NAT network (`virbr0`) instead.

```bash
sudo nmcli con add type bridge ifname br0 con-name br0
sudo nmcli con add type ethernet ifname eth0 master br0 con-name br0-port
sudo nmcli con up br0
```

## Step 5: SELinux

SLES 16 ships with SELinux enabled (AppArmor is removed). The rodeo playbook sets
**permissive** mode on the KVM host so libvirt/QEMU paths work without sVirt
labelling friction. For a lab where you want to disable per-VM sVirt labelling,
set the security driver to none:

```bash
sudo sed -i 's/^#\?security_driver.*/security_driver = "none"/' /etc/libvirt/qemu.conf
sudo systemctl restart virtqemud
```

## Step 6: Web management with Cockpit (optional)

```bash
sudo zypper install cockpit cockpit-machines
sudo firewall-cmd --permanent --add-service=cockpit
sudo firewall-cmd --reload
sudo systemctl enable --now cockpit.socket
```

Open `https://<host-ip>:9090`.

---

## Ansible playbook for SLES 16

Run this on the host itself to install and configure everything. It targets the
modular daemons and uses NetworkManager. Run it with:
`ansible-playbook kvm_setup.yml --ask-become-pass`.

```yaml
---
- name: Deploy KVM hypervisor on SLES 16
  hosts: localhost
  connection: local
  become: true
  vars:
    bridge_name: "br0"
    physical_nic: "eth0"
    libvirt_sockets:
      - virtqemud.socket
      - virtnetworkd.socket
      - virtstoraged.socket
      - virtnodedevd.socket
      - virtsecretd.socket
      - virtlogd.socket

  tasks:
    - name: Install KVM patterns
      community.general.zypper:
        name:
          - kvm_server
          - kvm_tools
        type: pattern
        state: present

    - name: Install supporting packages
      community.general.zypper:
        name:
          - cockpit
          - cockpit-machines
          - qemu-ovmf-x86_64
          - xorriso
          - jq
        state: present

    - name: Set security_driver to none in qemu.conf
      ansible.builtin.lineinfile:
        path: /etc/libvirt/qemu.conf
        regexp: '^#?security_driver'
        line: 'security_driver = "none"'
      notify: restart virtqemud

    - name: Enable the modular libvirt daemon sockets
      ansible.builtin.systemd:
        name: "{{ item }}"
        enabled: true
        state: started
      loop: "{{ libvirt_sockets }}"

    - name: Create bridge connection with NetworkManager
      community.general.nmcli:
        type: bridge
        conn_name: "{{ bridge_name }}"
        ifname: "{{ bridge_name }}"
        autoconnect: true
        state: present

    - name: Attach physical NIC to the bridge
      community.general.nmcli:
        type: ethernet
        conn_name: "{{ bridge_name }}-port"
        ifname: "{{ physical_nic }}"
        master: "{{ bridge_name }}"
        autoconnect: true
        state: present

    - name: Ensure firewalld is running
      ansible.builtin.systemd:
        name: firewalld
        enabled: true
        state: started

    - name: Open firewall ports for Cockpit and libvirt
      ansible.posix.firewalld:
        service: "{{ item }}"
        permanent: true
        immediate: true
        state: enabled
      loop:
        - cockpit
        - libvirt
        - libvirt-tls

    - name: Enable and start the Cockpit socket
      ansible.builtin.systemd:
        name: cockpit.socket
        enabled: true
        state: started

    - name: Validate KVM capabilities
      ansible.builtin.command: virt-host-validate qemu
      register: kvm_validation
      changed_when: false
      failed_when: false

    - name: Show KVM validation result
      ansible.builtin.debug:
        var: kvm_validation.stdout_lines

  handlers:
    - name: restart virtqemud
      ansible.builtin.systemd:
        name: virtqemud
        state: restarted
```

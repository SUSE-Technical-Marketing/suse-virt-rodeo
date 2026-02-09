## Guide: Converting SLES 16 into a KVM Hypervisor

This guide adapts the principles of setting up a virtualization environment for **SUSE Linux Enterprise Server (SLES) 16**. It incorporates the platform's shift to **NetworkManager** and its specific package management system.

---

### Step 1: Verify Hardware Support

Before installation, verify that your hardware and kernel support virtualization.

* 
**Check CPU Virtualization**: Run `lscpu | grep Virtualization` to ensure VT-x or AMD-V is enabled.


* 
**Check Kernel Modules**: Run `lsmod | grep kvm` to confirm the KVM modules are loaded.



### Step 2: Install KVM and Management Patterns

On SLES, we use **Patterns** rather than individual packages to ensure all dependencies and SUSE-validated configurations are present.

* 
**Install Hypervisor Tools**: Run `sudo zypper install -t pattern kvm_server kvm_tools`.


* 
**Initialize Libvirt**: Start and enable the virtualization daemon:


```bash
sudo systemctl enable --now libvirtd

```



### Step 3: Network Bridge Configuration

SLES 16 utilizes **NetworkManager** for networking. A bridge allows your Virtual Machines (VMs) to appear as physical nodes on your network.

1. **Create the Bridge (`br0`)**:
```bash
sudo nmcli con add type bridge ifname br0 con-name br0

```


2. 
**Attach Physical Interface**: Identify your interface (e.g., `eth0`) and attach it to the bridge:


```bash
sudo nmcli con add type bridge-slave ifname eth0 con-name br0-slave master br0

```


3. **Activate**:
```bash
sudo nmcli con up br0

```



### Step 4: Web-Based Management (Cockpit)

SLES 16 supports the **Cockpit** web console for an intuitive graphical interface to manage your VMs.

* 
**Install Cockpit**: Run `sudo zypper install cockpit cockpit-machines`.


* **Configure Firewall**: Since SLES 16 uses `firewalld`, you must allow the service:
```bash
sudo firewall-cmd --permanent --add-service=cockpit
sudo firewall-cmd --reload

```


* 
**Access**: Navigate to `https://[Your-IP]:9090` in your web browser.



---

## Ansible Playbooks for SLES 16 KVM

Below is the consolidated Ansible playbook to automate this deployment on SLES 16. Be aware that the playbook is meant ro run on your Virtualization host running SLES16. You can run it with: ```ansible-playbook kvm_setup.yml --ask-become-pass```, it will install and configure all the elements needed.

### `kvm_setup.yml`

```yaml
 ---
- name: Deploy KVM Hypervisor on SLES 16
  hosts: localhost
  connection: local
  become: true
  vars:
    bridge_name: "br0"
    physical_nic: "eth0"  # Update to match your actual NIC
    bridge_ip: "192.168.1.10/24"  # Set your bridge IP
    gateway: "192.168.1.1"  # Set your gateway

  tasks:
    - name: Install KVM patterns
      community.general.zypper:
        name:
          - kvm_server
          - kvm_tools
        type: pattern
        state: present

    - name: Install Cockpit and virtualization packages
      community.general.zypper:
        name:
          - cockpit
          - cockpit-machines
          - libvirt
          - qemu-kvm
          - virt-install
        state: present

    - name: Ensure libvirtd is enabled and started
      ansible.builtin.systemd:
        name: libvirtd
        enabled: yes
        state: started

    - name: Create bridge connection with NetworkManager
      community.general.nmcli:
        type: bridge
        conn_name: "{{ bridge_name }}"
        ifname: "{{ bridge_name }}"
        ip4: "{{ bridge_ip }}"
        gw4: "{{ gateway }}"
        autoconnect: yes
        state: present

    - name: Attach physical NIC to bridge
      community.general.nmcli:
        type: bridge-slave
        conn_name: "{{ bridge_name }}-slave"
        ifname: "{{ physical_nic }}"
        master: "{{ bridge_name }}"
        autoconnect: yes
        state: present

    - name: Bring up bridge connection
      ansible.builtin.command:
        cmd: nmcli connection up {{ bridge_name }}
      changed_when: false

    - name: Ensure firewalld is enabled and started
      ansible.builtin.systemd:
        name: firewalld
        enabled: yes
        state: started

    - name: Open firewall ports for Cockpit and Libvirt
      ansible.posix.firewalld:
        service: "{{ item }}"
        permanent: yes
        state: enabled
      loop:
        - cockpit
        - libvirt
        - libvirt-tls

    - name: Reload firewalld
      ansible.builtin.systemd:
        name: firewalld
        state: reloaded

    - name: Enable and start Cockpit socket
      ansible.builtin.systemd:
        name: cockpit.socket
        enabled: yes
        state: started

    - name: Verify KVM capabilities
      ansible.builtin.command: virt-host-validate qemu
      register: kvm_validation
      changed_when: false
      failed_when: false

    - name: Display KVM validation results
      ansible.builtin.debug:
        var: kvm_validation.stdout_lines
```
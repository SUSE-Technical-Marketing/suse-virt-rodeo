---
slug: harvester-portworx-overview
id: eu8fvp8sytmr
type: challenge
title: Your first VM with SUSE Virtualization
teaser: Understand VM provisioning
tabs:
- id: qb6uoe5rxt6s
  title: Terminal
  type: terminal
  hostname: cloud-client
  cmd: su - root
- id: ioqbebe5ywu6
  title: Rancher UI
  type: service
  hostname: cloud-client
  path: /
  port: 91
- id: lvy0y4n1jwmr
  title: Harvester UI
  type: service
  hostname: cloud-client
  path: /
  port: 90
difficulty: basic
timelimit: 28800
enhanced_loading: null
---

Intro
=====

In this lab, we will working with VMs for the first time. In the first chapter we created the necessary infrastructure to do so and now it´s time to provision out first Vm and understand how this process works on SUSE Virtualization. Also we will b introducing concepts like templates, Cloud-Init configuration and node placement.

### Logging in to the Rancher Prime UI

Let's open the [button label="Rancher" variant="success"](tab-1) tab.

Log in to Rancher Prime, if necessary, with the following credentials:

- Username:

```txt
admin
```

- Password:

```txt
[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="cloud-client" ]]
```

### Accessing the SUSE Virtualization Cluster

From the Rancher Prime UI, select the `Virtualization Management` menu item from the left-hand menu. Then select the `harvester` cluster from the menu

![01-connect_to_cluster.gif](../assets/01-connect_to_cluster.gif)

### The SUSE Virtualization UI

It is also possible to log in to SUSE Virtualization using the built in management interface. Although we will not be using this interface in this lab, it is available for your reference.

Let's open the [button label="Harvester UI" variant="success"](tab-2) tab.

Log in to Rancher Prime, if necessary, with the following credentials:

- Username:

```txt
admin
```

- Password:

```txt
Portworx123!
```

### The Command Line Interface

This lab has also been configured with a command line interface. Kubectl has been pre-configured to connect to the SUSE Virtualization cluster.

Let's open the [button label="Terminal" variant="success"](tab-0) tab.

Run the following command to test connectivity:

```bash,run
kubectl get nodes
```


Your first VM with SUSE Virtualization
===
In SUSE Virtualization you can create VM´s from ISO, qcow2, and other type of images. However, this is not the standard way to provision in the industry in most of cases we use a VM template that will shorten the deployment, avoid repetitive tasks and mistakes. In this challenge we will start with an image that we will use to provision a new VM, and we will use a Cloud Init template for further customization. We can store as many templates as we may need.

### Task: Create a Virtual Machine from a Template

Let's go back to the [button label="Rancher" variant="success"](tab-1) tab.

- Click on the `Virtual Machines` menu item from the left-hand menu
- Click the `Create` button.

![02-create_vm.gif](../assets/02-create_vm.gif)

- Set the name of our VM to `virt1`
- Set the `CPU` to `4`
- Set the `Memory` to `4`
- Set the `SSHKey` to `default/cloud-client` (This key will allow our cloud client to SSH to our VM)
- Select the `Volumes` menu item
- Select the `Image` dropdown and select the `default/leap16` image

![12-create_vm.gif](../assets/12-create_vm.gif)

Now we are going to work on the node scheduling for the VM. 

- Go to `Node Scheduling`on the left menu. 

We will find three options for the node placement, first `Run virtual machine on any available node` in this modality the Kubernetes Scheduler will decide where to place the VM, also it allows live migration for the VM. Then there´s the second choice `Run virtual machine on specific node` in this option we select a concrete node and the VM can´t use live migration. The third option is `Run virtual machine on node matching scheduling rules` then you can define affinity rules based on tags, these tags may indicate a certain network or the availability for certain hardware.

- Select `Run virtual machine on any available node`

We are now going to customize this VM using cloud-init. Cloud-init is a tool that allows you to customize a VM after it has been created. We will be using cloud-init set an ip address of this VM to `192.168.122.22`.

- Click on the `Networks` menu item
- Click the `Network` dropdown
- Select the `default/vmnet` network
- Click on the `Advanced Options` menu item
- Scroll down to the `Network Data:` section
- Paste the following in to the text field

```txt
version: 2
ethernets:
  enp1s0:
    addresses:
      - 192.168.122.22/24
    gateway4: 192.168.122.1
    nameservers:
      addresses:
        - 192.168.122.1
```

![02-click-create.gif](../assets/02-click-create.gif)

Switch back to the [button label="Terminal" variant="success"](tab-0) tab.

Let's wait for the VM to become available:

```bash,run
until ssh virt1 "uname -a" 2> /dev/null ; do sleep 5; done
```

Once our prompt comes back, we should see the output of `uname -a` which means our VM is up and running!


Now is time to test the `Live Migration`feature.

- Go to the `Virtual Machines`page
- Find the VM we just created click on the 3 point menu on the right and select the option `Migrate`
- Then SUSE Virtualization will offer a drop down menu where whe can select to which node we want to migrate
- Select a different node to migrate, and wait until the VM is on the new node.


> [!NOTE]
> Cloud init is a powerful way of customizing Linux virtual machines. It can set networking configurations, install packages, and more. For more information, see the [cloud-init documentation](https://cloudinit.readthedocs.io/en/latest/).
> SUSE Virtualization integrates cloud-init in to the GUI, allowing you to configure virtual machines easily.







---
slug: susevirt-intro
id: l5se76zdmayc
type: challenge
title: AeroGrid OPS — Bring the Airport Cluster Online
teaser: Confirm the cluster is healthy, build the primary VM network, and set up the LoadBalancer IP pool before airline workloads go live
tabs:
- id: tab-terminal
  title: Terminal
  type: terminal
  hostname: cloud-client
  cmd: su - root
- id: tab-rancher
  title: Rancher UI
  type: service
  hostname: cloud-client
  path: /
  port: 91
- id: tab-harvester
  title: Harvester UI
  type: service
  hostname: cloud-client
  path: /
  port: 90
difficulty: basic
timelimit: 2400
enhanced_loading: null
---

> **OPS BRIEF:** AeroGrid Network Operations Center | Priority: Critical | Assigned: Infrastructure Team
> The new SUSE Virtualization cluster is racked and powered. Confirm it is healthy, build the primary VM network, and set up the IP pool before any airline workloads go live.

AeroGrid manages IT infrastructure for a regional international airport. The platform runs everything from baggage handling and gate assignment systems to airline check-in kiosks. When the Broadcom acquisition of VMware closed, the renewal quote came in at 3.2x the previous cost — NSX, vSAN, and vCenter billed separately. The decision was made: migrate to SUSE Virtualization. Your job is to get the new platform operational.

The AeroGrid Platform
===

**SUSE Virtualization** (formerly Harvester) is AeroGrid's new hyperconverged infrastructure platform. It is a modern, open-source HCI stack built on Kubernetes. It runs directly on bare metal and manages both virtual machines and container workloads from a single interface.

It replaces every proprietary VMware component with an open-source equivalent:

| VMware (Broadcom pricing) | SUSE Virtualization | Version |
|---------------------------|---------------------|---------|
| ESXi | KubeVirt + KVM | KubeVirt v1.7.0 |
| vSAN | Longhorn distributed storage | Longhorn v1.11.1 |
| NSX | Kube-OVN + Multus | Kube-OVN v1.15.4 |
| vCenter | SUSE Rancher Prime | Rancher Prime v2.13.1 |

No vendor lock-in. No vTax. No proprietary kernel. One platform, one bill.

In this rodeo, **Rancher Prime** is your single pane of glass over the SUSE Virtualization cluster and every K8s cluster you provision on top of it.

Your Lab Environment
===

Your sandbox is a fully running 3-node SUSE Virtualization cluster inside a nested KVM environment. You have:

- **3 Harvester nodes** — forming a highly available cluster
- **Rancher Prime** — connected and managing the cluster
- **A terminal** on the cloud-client with `kubectl` already configured

Use the tabs at the top to switch between the Terminal, Rancher UI, and Harvester UI.

> [!NOTE]
> Both UIs use self-signed certificates. Accept the browser security warning when it appears.

Logging in to Rancher
===

Open the [button label="Rancher UI" variant="success"](tab-1) tab.

Log in with:

- **Username:** `admin`
- **Password:** `[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="cloud-client" ]]`

Select **Virtualization Management** from the left menu. The AeroGrid cluster appears listed and ready.

![01-connect_to_cluster.gif](../assets/01-connect_to_cluster.gif)

> [!NOTE]
> If the cluster shows as **Unavailable**, wait 1-2 minutes and refresh. The Harvester API sometimes takes a moment after the nodes boot.

Verify the Cluster from the Terminal
===

Open the [button label="Terminal" variant="success"](tab-0) tab and confirm all nodes are ready:

```bash,run
kubectl get nodes
```

All 3 nodes should show `Ready`.

Check that the core Harvester systems are running:

```bash,run
kubectl get pods -n harvester-system | grep -v Completed
```

All pods should be `Running`. The cluster is healthy.

TASK: Create the VM Traffic Cluster Network
===

Each Harvester node has two NICs. `eth0` carries cluster management traffic. `eth1` is reserved exclusively for VM workloads — it keeps VM traffic off the management path and gives AeroGrid the isolation needed to run multiple airline tenants safely.

You need to tell Harvester to use `eth1` as the uplink for a new cluster network named `vms`.

In the [button label="Harvester UI" variant="success"](tab-2) tab:

1. Go to **Networks > Cluster Networks** > **Create**
2. Set the name to `vms`
3. Under **Node Network Config**, add an entry for each node:
   - Click **Add**
   - Select a node (e.g., `harvester1`)
   - Set **NIC** to `eth1`
   - Repeat for `harvester2` and `harvester3`
4. Click **Create**

Wait for all three node configs to show `Active` before continuing.

TASK: Create the Primary VM Network
===

With the `vms` cluster network active, create the VM network that workloads will attach to.

In the [button label="Harvester UI" variant="success"](tab-2) tab:

1. Go to **Networks > VM Networks** > **Create**

![02-create_vm_network.gif](../assets/02-create_vm_network.gif)

2. Fill in:
   - **Name:** `vmnet`
   - **Type:** `L2VlanNetwork`
   - **Cluster Network:** `vms`
   - **VLAN ID:** `1` (untagged)
3. Click **Create**

![03-create_vm_network.gif](../assets/03-create_vm_network.gif)

Verify from the terminal:

```bash,run
kubectl get network-attachment-definitions -n default
```

`vmnet` should be listed. The primary VM network is live.

TASK: Set Up the LoadBalancer IP Pool
===

SUSE Virtualization can provision guest Kubernetes clusters. Those clusters need LoadBalancer IPs to expose their services externally. An **IP Pool** pre-allocates a range of addresses for that purpose.

This pool is critical. It is used in every subsequent challenge as AeroGrid provisions and exposes services on the platform. The passenger check-in portal, the NOC dashboard, and airline-facing services all pull IPs from here.

In the [button label="Harvester UI" variant="success"](tab-2) tab:

1. Go to **Networks > IP Pools** > **Create**
2. Set the name to `rodeo-ippool`
3. On the **Range** tab, add the range `192.168.122.200` to `192.168.122.220`
4. On the **Selector** tab:
   - **VM Network:** `default/vmnet`
   - **Namespace:** `default`
5. Click **Create**

Verify:

```bash,run
kubectl get ippools.network.harvesterhci.io -n default
```

`rodeo-ippool` should be listed. The cluster is ready to provision workloads and expose services.

Click **Check** when both resources are confirmed.

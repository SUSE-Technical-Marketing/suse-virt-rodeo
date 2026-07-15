---
slug: the-subterranean-divide-cluster-prep
id: tmmoesxdhg4b
type: challenge
title: "\U0001F6D7 Chapter 2 — The Subterranean Divide"
teaser: Two hardware silos, two teams that barely speak. Descend into the datacenter,
  map the node topology, and prepare a unified home for the bank's workloads.
tabs:
- id: gix6w5fqkxd6
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: duhbmh2ml3qo
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: zgpgmllqoznu
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: basic
timelimit: 2400
enhanced_loading: null
---

🛗 Chapter 2 — The Subterranean Divide
======================================

<style type="text/css">
  * {
    font-family: suse;
    src: url('https://fonts.google.com/specimen/SUSE');
  }
  .suse { color: #30ba78; }
  .virt { color: #30ba78; }
  .bank { color: #d4af37; }
  .danger { color: #ff4d4d; font-weight: bold; }
  .hovereffect {
    border-radius: 25px 25px 25px 25px;
    background: linear-gradient(#30ba78 0 0) var(--hundredpercent, 0) / var(--hundredpercent, 0) no-repeat;
    transition: 0.5s, background-position 0s;
    padding: 5px;
  }
  .hovereffect:hover {
    --hundredpercent: 100%;
    color: white;
    border-radius: 10px 25px 10px 25px;
  }
  .storybox {
    border-left: 5px solid #d4af37;
    border-radius: 0 15px 15px 0;
    background: linear-gradient(135deg, rgba(48,186,120,.10), rgba(212,175,55,.10));
    padding: 15px 20px;
    margin: 15px 0;
  }
  .storybox em { color: #d4af37; }
  .missionbox {
    border: 2px dashed #30ba78;
    border-radius: 15px;
    padding: 12px 18px;
    margin: 15px 0;
  }
  .highlightcopy { color: white; font-weight: bold; padding: 0 10px; }
  img.logos { border-radius: 10px; }
</style>

<img class="logos" alt="Welcome!" src="../assets/02-chapter-img.png"/>

<div class="storybox">

Sarah leads you out of the quiet executive suites, into a secure elevator, and down into the bank's subterranean datacenter. The ambient temperature drops sharply as the heavy steel biometric doors lock behind you. The room hums with the deafening, relentless roar of industrial cooling systems.

She gestures to the left side of the room, where rows of sleek, densely packed server chassis blink with rapid blue lights. *"Those run our mobile banking APIs,"* she shouts over the fan noise. *"Pure microservices. Fully containerized and agile."*

She then points to the right side of the room, dominated by hulking, archaic server cabinets radiating an uncomfortable amount of heat. *"And those are the legacy monolithic virtual machines holding the core transaction ledgers. Two completely different worlds. Two different hardware silos. Two different engineering teams that barely even speak to each other."*

You walk between the two rows, feeling the distinct temperature differential. *"That divide ends today,"* you tell her.

</div>

## <b class="hovereffect">One fabric for two worlds</b>

You explain the elegant architecture of <b class="virt">SUSE Virtualization</b>: by leveraging advanced open-source technologies on a **Kubernetes foundation**, the platform does not just *tolerate* virtual machines — it treats them as **native citizens of the container ecosystem**. The heavy virtual machines will run side-by-side with the nimble containers, managed by the exact same orchestration engine:

| Virtualization world | Container World | Unified on SUSE Virtualization |
|---------------------|----------------|-------------------------------|
| Hypervisor hosts | Kubernetes nodes | **One set of nodes runs both** |
| Hypervisor management console | Container tooling | **One platform underneath**. SUSE Virtualization runs the VMs, Rancher Prime commands the clusters and the containers |
| SAN storage arrays | CSI volumes | **Longhorn serves VMs and pods alike** |

To prove the architecture is sound, you must prepare the environment to host the bank's workloads.

<div class="missionbox">

## 🎯 Your Quest Objectives

1. Inspect the physical node topology
2. Prepare a dedicated workspace for the bank
3. Build the bank's production VM network
4. Carve out a development network on the spare uplink
5. Reserve address space for customer-facing services

</div>

🔐 Login Credentials
====================

The **SUSE Virtualization** UI and **Rancher Prime** UI use the same credentials.

Username:
```txt
admin
```

Password:
```txt
[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="kvm-host" ]]
```


🖥️ Task 1: Inspect the physical node topology
=============================================

Go to the [button label="SUSE Virtualization UI" variant="success"](tab-0), navigate to the left-hand menu, and click on **Hosts**.

1. Click on the name of **one of the hosts** in the list
2. Navigate around the UI and check the different options to understand better how things work

Observe how raw block devices are provisioned for virtual machine disks. Each disk you see here becomes part of the Longhorn distributed storage pool that will hold the bank's ledgers.

> [!NOTE]
> **Banks grow and so does this fabric.** Adding a node to <b class="virt">SUSE Virtualization</b> is refreshingly simple: boot the new machine with the cluster's **join token** and its network and hostname settings, and it enrolls itself with no manual cluster surgery. Combine that with **PXE network boot** and racking new capacity becomes a matter of minutes: power on, walk away, and watch the newcomer appear on this Hosts page. The [PXE Boot Installation guide](https://documentation.suse.com/cloudnative/virtualization/latest/en/installation-setup/methods/pxe-boot-install.html) has the details.

🏗️ Task 2: Prepare a dedicated workspace for the bank
=====================================================

The platform isolates workloads in **namespaces**, separate, governable workspaces on the same cluster. The bank's financial workloads deserve their own.

In the [button label="SUSE Virtualization UI" variant="success"](tab-0), select **Namespaces** from the left-hand menu. You will notice <b class="highlightcopy">prod</b> already sitting in the list — the platform team provisioned it before you arrived, and it is where the bank's production workloads will live.

Now create its counterpart for development:
1. Select **Namespaces** from the left-hand menu
2. Set the **Name** to <b class="highlightcopy">dev</b>
3. Click **Create**

Two workspaces now stand ready: <b class="highlightcopy">prod</b>, already provisioned, and <b class="highlightcopy">dev</b>, freshly created — each with its own quotas, policies, and access controls.

🌐 Task 3: Build the bank's production VM network
=================================================

Before a single ledger VM can boot, it needs a network to live on. this network need to allow the bank's virtual machines talk to each other and to the outside world.

In the [button label="SUSE Virtualization UI" variant="success"](tab-0):

1. Select **Networks** from the left-hand menu, then **Virtual Machine Networks**
2. Click **Create**

![02-create_vm_network.gif](../assets/02-create_vm_network.gif)

3. Select the namespace **prod** from the Namespace drop-down menu in the top left.
4. Fill in:
   - **Name:** <b class="highlightcopy">vmnet</b>
   - **Type:** `UntaggedNetwork`
   - **Cluster Network:** `mgmt`
5. Click **Create**

![03-create_vm_network.gif](../assets/03-create_vm_network.gif)

Back in the list, <b class="highlightcopy">vmnet</b> should show as **Active**. Every bank workload you deploy in the coming chapters attaches to this network.

> [!NOTE]
> On production hardware with more physical NICs, best practice is to split responsibilities across dedicated networks — management, storage replication, live migration, and VM workload traffic each on their own uplink. In this lab, production traffic rides the `mgmt` cluster network — and in the next task you will put a spare NIC to work for development traffic. SUSE Virtualization also supports VLAN tagging, load-balancer configurations, and other software-defined networking services — you will build a tagged VLAN yourself in a later chapter.

🧪 Task 4: Carve out a development network on the spare uplink

Production traffic should never share a lane with experiments. Every node in the bank's new fabric happens to have a **spare physical network interface** — `eth4` — carrying no traffic at all. You will turn it into a dedicated development network, physically separated from the production path. On legacy hardware this meant switch tickets and a week of waiting; here it is a two-minute job.

First, define the cluster-wide network on the spare uplink. In the [button label="SUSE Virtualization UI" variant="success"](tab-0):

1. Go to **Networks > Cluster Network Configuration** and click **Create a Cluster Network** on the top right corner
2. Set the **Name** to <b class="highlightcopy">dev</b> and click **Create**
3. Back in the list, find the new <b class="highlightcopy">dev</b> cluster network and click **Create Network Configuration** 
4. Set the **Name** to <b class="highlightcopy">dev-uplink</b>
5. Under **Uplink**, select NIC <b class="highlightcopy">ens5</b> (leave the node selector empty so the config applies to every node)
6. Click **Create** and wait for the config to show as **Active** on all nodes

Now build a VM network on top of it:

7. Go to **Networks > Virtual Machine Networks** and click **Create**
8. Select namespace "dev" from the Namespace drop-down menu to deploy the new devnet network
9. Fill in:
   - **Name:** <b class="highlightcopy">devnet</b>
   - **Type:** `UntaggedNetwork`
   - **Cluster Network:** `dev`
10. Click **Create**

Two lanes now show as **Active** in the list: <b class="highlightcopy">vmnet</b> (production, on `mgmt`) and <b class="highlightcopy">devnet</b> (development, on the spare uplink). Two worlds, physically separated, zero switch tickets — the A-Team's future sandboxes will live here, safely away from the money.

🏦 Task 5: Reserve address space for customer-facing services
=============================================================

<b class="virt">SUSE Virtualization</b> is not only a virtualization platform — it is designed to also run Kubernetes clusters on top. Those clusters need LoadBalancer IPs to expose their services. An **IP Pool** pre-allocates a range of addresses for exactly that.

The bank will need this soon: the mobile banking portal, the ops dashboard, and every customer-facing service will pull its address from this reserve.

In the [button label="SUSE Virtualization UI" variant="success"](tab-0):

1. Go to **Networks > IP Pools** > **Create**
2. Set the name to <b class="highlightcopy">vertex-ippool</b>
3. On the **Range** tab, add the range `192.168.122.200` to `192.168.122.220`
4. On the **Subnet** tab, add `192.168.122.0/24`
5. On the **Selector** tab:
   - **VM Network:** `prod/vmnet`
   - **Namespace:** `prod`
6. Click **Create**

<b class="highlightcopy">vertex-ippool</b> now appears in the list. The bank's address reserve is funded.

🏋️ Bonus Drills — for the command-line curious (optional)
==========================================================

New to Kubernetes? **Skip ahead freely.** If you are curious, everything you just did in the UI is also visible through the Kubernetes API — open the [button label="Cluster Terminal" variant="success"](tab-1):

- **Map the nodes from the command line** — same machines, same IPs, same OS image as the **Hosts** page; the UI and the API are two views of one single source of truth:

```bash,run
kubectl --kubeconfig .kube/harvester.yaml get nodes -o wide
```

- **Expose the hidden engine** that runs every VM as a container-native process. You should see components like `virt-api`, `virt-controller`, and `virt-handler` — this is **KubeVirt**, the bridge between Kubernetes and KVM:

```bash,run
kubectl --kubeconfig .kube/harvester.yaml get pods -n harvester-system | grep virt
```

- **See your UI handiwork as API objects** — the workspace, both networks, and the address reserve:

```bash,run
kubectl --kubeconfig .kube/harvester.yaml get namespace prod; kubectl --kubeconfig .kube/harvester.yaml get clusternetworks.network.harvesterhci.io; kubectl --kubeconfig .kube/harvester.yaml get network-attachment-definitions -n prod; kubectl --kubeconfig .kube/harvester.yaml get ippools.network.harvesterhci.io -n prod;
```

- **Confirm the cluster is ready for VMs**, and only one VM exists in the cluster (the VM is for one of the challenges):

```bash,run
kubectl --kubeconfig .kube/harvester.yaml get vm -A
```

- **Label the new workspace** so future automation can target production financial workloads:

```bash,run
kubectl --kubeconfig .kube/harvester.yaml label namespace prod stage=prod owner=vertex-trust
```

💼 Why does this matter for Vertex Trust Bank?
==============================================

- **The silos disappear.** VMs and containers share nodes, storage, networking, and one operations team, the datacenter's "temperature divide" is gone.
- **No retraining cliff.** The container team's Kubernetes skills now manage the VM estate too; the VM team gets a familiar point-and-click UI backed by Kubernetes API.
- **Namespaces bring governance.** Financial workloads live in `prod` with their own quotas, policies, and access controls — auditors will love it.
- **Networking is self-service.** A production VM network, a physically separate development network on a spare NIC, and a LoadBalancer address reserve takes minutes to define, no switch tickets, no waiting on the network team.

<div class="storybox">

Sarah watches over your shoulder as the new workspace, the production network, and the address reserve appear on the dashboard, one after another. A faint smile breaks across her face. *"The foundation is solid. Let's get to work."*

</div>

Click **Check** to continue. ⚡

📚 More information
===================

- [SUSE Virtualization — Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Hardware and Network Requirements](https://documentation.suse.com/cloudnative/virtualization/latest/en/installation-setup/requirements.html)

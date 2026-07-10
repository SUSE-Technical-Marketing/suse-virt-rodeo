---
slug: the-arrival-welcome
id: ermykdy1tbse
type: challenge
title: "\U0001F3E6 Chapter 1 — The Arrival"
teaser: Vertex Trust Bank is drowning in legacy hypervisor costs. Step into the boardroom,
  take command of SUSE Virtualization, and inspect your new command center.
notes:
- type: text
  contents: |
    # Welcome to the SUSE Virtualization Hands-on Workshop!
    Please wait while we prepare your lab environment.

    The rain is lashing against the windows of Vertex Trust Bank headquarters...
    Sarah, the CTO, is waiting for you in the boardroom.
    <img class="logos" src="../assets/logos/suse_logo.svg"/>
tabs:
- id: 3veafppy6ial
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: ljaolp3q406m
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: ihjqc1cl533q
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: basic
timelimit: 2400
enhanced_loading: null
---

🏦 Chapter 1 — The Arrival
==========================

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

<img class="logos" alt="Welcome!" src="../assets/01-chapter-img.png"/>


<div class="storybox">

The rain lashed against the floor-to-ceiling windows of <b class="bank">Vertex Trust Bank</b> headquarters, distorting the city skyline into a gray, watery blur. Inside the glass-walled executive boardroom, the atmosphere was equally turbulent. **Sarah**, the Chief Technology Officer, paced the length of the room, her eyes fixed on a massive overhead monitor projecting a sea of <span class="danger">red alerts</span> and performance warnings.

She turned to you, her voice tight with exhaustion. *"We are losing precious milliseconds on every single market transaction. Our legacy hypervisors are buckling under the sheer volume of modern digital banking traffic. The infrastructure is brittle, the storage arrays are constantly falling out of synchronization, and our licensing costs are bleeding our engineering budget completely dry. We cannot survive another year chained to these monolithic, antiquated systems."*

You sit quietly at the end of the mahogany table, reviewing the architectural schematics she provided. As an elite **Infrastructure Architect**, you have been brought in for one specific purpose: to save <b class="bank">Vertex Trust Bank</b> from total operational gridlock. They need a bridge to the cloud-native world — without rebuilding their entire application stack from scratch.

*"We have a plan, Sarah,"* you finally say, closing your laptop with a reassuring click. *"We are going to transition the entire datacenter to <b class="virt">SUSE Virtualization</b>. We will bring your legacy systems into the modern era, and we will do it without missing a beat."*

</div>

Your journey begins right now. Before you can begin dismantling the old world, you need to establish a foothold in the new one and deeply inspect the environment.

## <b class="hovereffect">What is SUSE Virtualization?</b>

<b class="virt">SUSE Virtualization</b> (also known as **Harvester**) is a modern, open-source hyperconverged infrastructure (HCI) platform built on Kubernetes. It runs directly on bare metal and manages both **virtual machines** and **container workloads** from a single interface — exactly the bridge <b class="bank">Vertex Trust Bank</b> needs:

- **KubeVirt + KVM** — enterprise virtualization as native Kubernetes workloads
- **Longhorn** — distributed, replicated block storage across every node
- **Software-defined networking** — VLANs and isolated overlay networks without touching a cable
- **One open-source bill** — no per-socket hypervisor tax

Every proprietary component bleeding the bank's budget dry has a modern, open-source replacement:

| The old world (per-socket licensing) | SUSE Virtualization | Version |
|--------------------------------------|---------------------|---------|
| ESXi | KubeVirt + KVM | KubeVirt v1.7.0 |
| vSAN | Longhorn distributed storage | Longhorn v1.11.1 |
| NSX | Kube-OVN + Multus | Kube-OVN v1.15.4 |
| vCenter | SUSE Rancher Prime | Rancher Prime v2.13.1 |

No vendor lock-in. No virtualization tax. No proprietary kernel. **One platform, one bill** — exactly what you promised Sarah in the boardroom.

<div class="missionbox">

## 🎯 Your Quest Objectives

1. Log in and inspect the unified dashboard
2. Validate the distributed storage fabric
3. Test your administrative terminal access
4. Check cluster component health

</div>

🔐 Your Architect Credentials
=============================

For your records, your Architect Credentials are as follows:

Username:
```txt
admin
```

Password:
```txt
[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="kvm-host" ]]
```

> [!NOTE]
> The UIs use self-signed certificates. Accept the browser security warning when it appears. If a page does not load right away, the lab environment may still be booting — wait a minute and refresh the tab.

> [!NOTE]
> If you prefer to work in your own browser instead of the embedded tabs, the lab host is reachable directly at:
> <a href="https://kvm-host.[[ Instruqt-Var key="_SANDBOX_ID" hostname="kvm-host" ]].instruqt.io:8443">https://kvm-host.[[ Instruqt-Var key="_SANDBOX_ID" hostname="kvm-host" ]].instruqt.io:8443</a>

📊 Task 1: Log in and inspect the unified dashboard
===================================================

Navigate to the [button label="SUSE Virtualization UI" variant="success"](tab-0) tab and log in using your credentials.

> [!NOTE]
> The platform is also connected to **Rancher Prime** — the bank's future "single pane of glass" over every cluster it will ever run. Open the [button label="Rancher Prime UI" variant="success"](tab-2), log in with the same credentials, and select **Virtualization Management** from the left menu to see the cluster from the fleet-management perspective. You will use this view again later in the mission.

![01-connect_to_cluster.gif](../assets/01-connect_to_cluster.gif)

Take a moment to examine the main **Dashboard** — this is your command center for the entire mission:

- Locate the **Cluster Metrics** section to view real-time **CPU**, **Memory**, and **Storage IOPS** utilization.
- Note the **Hosts** listed at the bottom — every physical node in the bank's new fabric reports here.
- Check the **Events** stream: a healthy cluster should show routine activity, not a sea of red like Sarah's old monitor.

> [!NOTE]
> Everything you see in this dashboard — VMs, volumes, networks — is a Kubernetes resource under the hood. You will use both the UI and `kubectl` throughout this mission, and they always show the same truth.

💾 Task 2: Validate the distributed storage fabric
==================================================

A healthy storage backend is critical for banking operations. <b class="virt">SUSE Virtualization</b> uses **Longhorn** to replicate every volume across the cluster.

In the [button label="SUSE Virtualization UI" variant="success"](tab-0):

1. Click on the **Advanced** menu on the left side of the screen and select the **Longhorn** storage dashboard (if you do not see it there, the link is also available on the **Support** page, bottom-left)
2. Verify that all storage nodes are marked as **Schedulable**
3. Verify that there are **no degraded volumes**

If a node were unschedulable or a volume degraded, Longhorn would already be rebuilding replicas elsewhere — but you always confirm your ground truth before a migration of this magnitude.

⌨️ Task 3: Test your administrative terminal access
===================================================

Click on the [button label="Cluster Terminal" variant="success"](tab-1) tab. You must validate that your connection to the underlying Kubernetes engine is active:

```bash,run
kubectl cluster-info
```

You should see the Kubernetes control plane and CoreDNS endpoints respond. Your administrative access is live.

🩺 Task 4: Check cluster component health
=========================================

To ensure all <b class="virt">SUSE Virtualization</b> subsystems are operating correctly, query the control plane's health endpoint:

```bash,run
kubectl get --raw='/readyz?verbose'
```

Review the output carefully — every check (etcd, informers, shutdown hooks) should report `ok`.

> [!NOTE]
> You may see older guides use `kubectl get componentstatuses`. That API is deprecated — the `/readyz` endpoint above is the modern, complete health readout, and it is what the bank's monitoring will scrape in production.

🏋️ Bonus Drills — go deeper before you proceed
===============================================

A true architect never stops at the minimum. Run these extra checks in the [button label="Cluster Terminal" variant="success"](tab-1):

- **Confirm every node in the fabric is ready:**

```bash,run
kubectl get nodes
```

  All nodes should show `Ready`.

- **Verify the core virtualization services are running:**

```bash,run
kubectl get pods -n harvester-system | grep -v Completed
```

  All pods should be `Running`.

- **Confirm the exact platform version you promised Sarah:**

```bash,run
kubectl get settings.harvesterhci.io server-version
```

💼 Why does this matter for Vertex Trust Bank?
==============================================

- **One command center.** VMs, storage, and networking are visible from a single dashboard — no more juggling three separate management consoles with three separate licenses.
- **Kubernetes-native from day one.** Every check you just performed used standard `kubectl` — the same skills the bank's container teams already have.
- **Distributed storage out of the box.** Longhorn replicates data across nodes automatically; no proprietary SAN, no synchronization nightmares.

Once you confirm the control plane is responding, the storage is healthy, and your administrative access is secured, you are ready to proceed deeper into the facility.

Click **Check** to descend into the datacenter. 🛗

📚 More information
===================

- [SUSE Virtualization — Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Hardware and Network Requirements](https://documentation.suse.com/cloudnative/virtualization/latest/en/installation-setup/requirements.html)

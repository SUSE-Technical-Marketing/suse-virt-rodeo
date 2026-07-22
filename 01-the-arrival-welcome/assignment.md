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
  .story {
    border-left: 5px solid #d4af37;
    border-radius: 0 15px 15px 0;
    background: linear-gradient(135deg, rgba(48,186,120,.10), rgba(212,175,55,.10));
    padding: 15px 20px;
    margin: 15px 0;
  }
  .story em { color: #d4af37; }
  .missionbox {
    border: 2px dashed #30ba78;
    border-radius: 15px;
    padding: 12px 18px;
    margin: 15px 0;
  }
  .highlightcopy { color: white; font-weight: bold; padding: 0 10px; }
  img.logos { border-radius: 10px; }
  /* compact credential boxes (scoped: only code blocks inside <div class="cred">) */
  .cred > div { margin: 0; }
  .cred .my-3 {
    display: flex;
    flex-direction: row-reverse;   /* put the copy bar on the right */
    align-items: stretch;
    width: fit-content;
    min-width: 14em;
    margin: 4px 0;
    overflow: hidden;
  }
  .cred .my-3 > div:first-child {  /* the bar holding the copy button */
    height: auto;
    padding: 2px 8px;
    border-bottom: none;
    border-left: 1px solid white;
    border-radius: 0;
    display: flex;
    align-items: center;
    background-color: #30ba78;   /* new: green copy-bar background */
  }
  .cred .my-3 > div:first-child,
  .cred .my-3 > div:first-child * {
    color: #fff !important;
  }
  .cred .my-3 > div:first-child:hover,
  .cred .my-3 > div:first-child:hover * {
    font-weight: bold;
  }

  .cred .my-3 > pre {
    flex: 1 1 auto;
    margin: 0 !important;
    padding: 2px !important;
    border-radius: 0 !important;
    display: flex;
    align-items: center;
  }
</style>

<img class="logos" alt="Welcome!" src="../assets/01-chapter-img.png"/>


<div id="101" class="story">

The rain lashed against the floor-to-ceiling windows of <b class="bank">Vertex Trust Bank</b> headquarters, distorting the city skyline into a gray, watery blur. Inside the glass-walled executive boardroom, the atmosphere was equally turbulent. **Sarah**, the Chief Technology Officer, paced the length of the room, her eyes fixed on a massive overhead monitor projecting a sea of <span class="danger">red alerts</span> and performance warnings.

She turned to you, her voice tight with exhaustion. *"We are losing precious milliseconds on every single market transaction. Our legacy hypervisors are buckling under the sheer volume of modern digital banking traffic. The infrastructure is brittle, the storage arrays are constantly falling out of synchronization, and our licensing costs are bleeding our engineering budget completely dry. We cannot survive another year chained to these monolithic, antiquated systems."*

You sit quietly at the end of the mahogany table, reviewing the architectural schematics she provided. As an elite **Infrastructure Architect**, you have been brought in for one specific purpose: to save <b class="bank">Vertex Trust Bank</b> from total operational gridlock. They need a bridge to the cloud-native world — without rebuilding their entire application stack from scratch.

*"We have a plan, Sarah,"* you finally say, closing your laptop with a reassuring click. *"We are going to transition the entire datacenter to <b class="virt">SUSE Virtualization</b>. We will bring your legacy systems into the modern era, and we will do it without missing a beat."*

</div>

Your journey begins right now. Before you can begin dismantling the old world, you need to establish a foothold in the new one and deeply inspect the environment.

## <b class="hovereffect">What is SUSE Virtualization?</b>

<b class="virt">SUSE Virtualization</b> (also known as **Harvester**) is a modern, open-source hyperconverged infrastructure (HCI) platform built on Kubernetes. It runs directly on bare metal and gives the bank enterprise-grade **virtual machines** on a cloud-native foundation — exactly the bridge <b class="bank">Vertex Trust Bank</b> needs:

- **KubeVirt + KVM/QEMU** — enterprise virtualization as native Kubernetes workloads. Underneath sits the same battle-hardened **KVM/QEMU** pair that has powered Linux virtualization for decades — which is why the platform can run an enormous variety of guest operating systems, including the very old ones still serving in the bank's dustiest legacy corners, patiently waiting for their migration
- **Longhorn** — distributed, replicated block storage across every node, set up and ready out of the box. And if the bank ever prefers different storage, **any CSI-compatible storage driver plugs right in** — freedom of choice, never lock-in
- **Software-defined networking** — VLANs and isolated overlay networks without touching a cable
- **One open-source bill** — no per-socket hypervisor tax
- **Support that actually listens** — SUSE customers consistently rate **SUSE Support** among the best in the industry, and their feedback directly shapes where the products go next. Try asking a closed-source vendor for a seat at that table

Because the platform runs *on* Kubernetes, containerized workloads can run on the very same cluster. Keep the division of labor straight from day one: the <b class="virt">SUSE Virtualization</b> UI manages **virtual machines** — managing containers (and managing whole fleets of clusters) is the job of **Rancher Prime**, which you will meet in a moment.

Every proprietary component bleeding the bank's budget dry has a modern, open-source replacement:

| The old world (per-socket licensing) | SUSE Virtualization |
|--------------------------------------|---------------------|
| ISAware proprietary hypervisor | KubeVirt + KVM |
| Proprietary storage array | Longhorn distributed storage — or any CSI driver the bank chooses |
| Closed-source SDN | Kube-OVN + Multus |
| ISAware Command Throne | SUSE Rancher Prime |

No vendor lock-in. No virtualization tax. No proprietary kernel. **One platform, one bill** — exactly what you promised Sarah in the boardroom.

<div class="missionbox">

## 🎯 Your Quest Objectives

1. Log in and inspect the unified dashboard
2. Meet Rancher Prime, the fleet commander
3. Validate the distributed storage fabric
4. Test your administrative terminal access

</div>

> [!NOTE]
> Disclaimer: This lab is meant to be educational and not to provide instructions on how to configure a production environment for a 'bank', most decisions made are with the limitations and purpose of this environment.


🔐 Your Architect Credentials
=============================

For your records, your Architect Credentials are as follows:

Username:

<div class="cred">

```txt
admin
```

</div>

Password:

<div class="cred">

```txt
[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="kvm-host" ]]
```

</div>

> [!NOTE]
> The UIs use self-signed certificates. Accept the browser security warning when it appears. If a page does not load right away, the lab environment may still be booting — wait a minute and refresh the tab.

> [!NOTE]
> If you prefer to work in your own browser instead of the embedded tabs, the lab host is reachable directly at:
> <a href="https://kvm-host.[[ Instruqt-Var key="_SANDBOX_ID" hostname="kvm-host" ]].instruqt.io:8443">https://kvm-host.[[ Instruqt-Var key="_SANDBOX_ID" hostname="kvm-host" ]].instruqt.io:8443</a>

📊 Task 1: Log in and inspect the unified dashboard
===================================================

Navigate to the [button label="SUSE Virtualization UI" variant="success"](tab-0) tab and log in using your credentials.

![01-connect_to_cluster.gif](../assets/01-connect_to_cluster.gif)

Take a moment to examine the main **Dashboard** — this is your command center for the entire mission:


> [!NOTE]
> Don't make any changes yet — we are just getting familiar with the environment.


- The first section contains the overall numbers:
  - **Hosts** the cluster is made of
  - **Virtual Machines** (running and stopped)
  - **Images** available to deploy new VMs
  - **Volumes** in use
  - **Disks** available

Clicking on each of them takes you to a dedicated section with further information. Click on **Hosts**:

You see a detailed view of each host's reserved and used resources, as well as the host's IP addresses and other details.

Notice the **three dots** at the end of each row — clicking them opens a menu with different actions for that host.

Go back to the **Dashboard** and look at what else is there:

- The second section, **Capacity**, lists the resources currently reserved and available in the cluster.

- Below it sits a section with two tabs:

  - **Cluster Metrics** — real-time metrics about the cluster; these come in handy when troubleshooting performance issues.

  - **Virtual Machine Metrics** — real-time metrics for virtual machines; note that if no VM is running there is no data to show.

- At the bottom, the last section, **Events**, shows the latest events happening in the cluster.

Now look further around the UI. At the top right there is a drop-down menu with **All Namespaces** selected — it lets you focus on specific namespaces. Namespaces here are Kubernetes namespaces: a way to organize resources and assign dedicated permissions to everything inside them, a concept similar to a "group". At the bottom of this chapter you will find links with more information — many of the concepts you find in Kubernetes apply directly to SUSE Virtualization.

The **bell** holds notifications and alerts, and further right the **user icon** leads you to user settings and keys for automated access.

On the left side there is a column with different sections. We are not going through all of them now — you will examine many in the coming chapters. Note that these sections change depending on which plugins are enabled or disabled.

Finally, in the bottom-left corner, click on **Support**.
It takes you to a page with links to documentation and other support resources, plus two important sections:

- **Generate a Support Bundle** — produces a file that helps SUSE Support troubleshoot your environment without having to access it directly.
- **Download KubeConfig** — gives you the kubeconfig file you can use to manage this cluster with kubectl and other tools from a console.

If you still have time, familiarize yourself with the sections before moving on to the next task.


> [!NOTE]
> Everything you see in this dashboard — VMs, volumes, networks — is a Kubernetes resource under the hood. The UI is your primary tool for this mission; a terminal stands ready for the optional bonus drills, if you are curious about the machinery.



🐮 Task 2: Meet Rancher Prime, the fleet commander
==================================================

The platform can also be connected to **Rancher Prime** — and it is important to understand who does what in the bank's new world:

- <b class="virt">SUSE Virtualization</b> manages the **virtual machines** on this cluster.
- **Rancher Prime** manages **many clusters at once** — every SUSE Virtualization cluster in every branch datacenter — plus centralized **users, roles, and access control (RBAC)**, and the **container workloads** the bank will run alongside its VMs.

Let's see what is inside Rancher.

Open the [button label="Rancher Prime UI" variant="success"](tab-2), log in with the same credentials, and select **Virtualization Management** from the left menu.

From here you can manage multiple SUSE Virtualization clusters. Import the existing one:

1. Click **Import Existing**
2. Set the **Cluster Name** to
<div class="cred">

```txt
mysusevirt1
```

</div>

3. Click **Create**

A new screen appears. Notice the state next to the cluster name: **Pending** — it is waiting for the cluster to register.
Below it you can see the registration instructions. Follow them, and remember to select **Insecure Skip TLS Verify** when editing the <b class="highlightcopy">cluster-registration-url</b> setting.

Remain in the Rancher UI and watch the state change from **Pending** to **Waiting**, then finally to **Active**.

Now go back to **Harvester Clusters** — the cluster appears in the list.

Let's see what else you can do here. Click the **three dots** at the end of the cluster's row; a menu drops down with some options:

- **Kubectl Shell** — opens a shell connected to the cluster, where you can run kubectl commands against it.
- **Download KubeConfig** — same as what you already saw in the SUSE Virtualization UI.
- **Download YAML** — downloads the cluster definition in YAML format; you can use it as a template to import new clusters in an automated fashion (it also needs one extra step in the cluster UI).

Finally, click on the cluster name itself: it takes you to the SUSE Virtualization UI embedded within the Rancher UI, so you can easily operate multiple clusters from one place.



> [!NOTE]
> There is a dedicated rodeo for rancher, feel free to join!



⌨️ Task 3: Test your administrative terminal access
===================================================

You will spend most of this mission in the UI, but an architect always verifies their emergency access. Click on the [button label="Cluster Terminal" variant="success"](tab-1) tab and run one command to validate that your connection to the underlying Kubernetes engine is active:


```bash,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get VirtualMachine -A
```

You should see the list of Virtual Machines present in every namespace.



💾 Bonus Drill — validate the distributed storage fabric (optional)
====================================================================

A healthy storage backend is critical for banking operations. <b class="virt">SUSE Virtualization</b> uses **Longhorn** to replicate every volume across the cluster.

The [button label="SUSE Virtualization UI" variant="success"](tab-0) already shows information about the storage health, but it is also possible to access the Longhorn dashboard by enabling the **Extension developer features**:

1. Click on your **user icon** in the top-right corner
2. Select **Preferences**
3. Tick **Enable Extension developer features**

Go back to **Home**, and in the bottom-left corner click on **Support**.

You will now see two new sections:

- **Access Embedded Rancher UI**
- **Access Embedded Longhorn UI**

Click on the **Longhorn UI** section.

It will take you to the Longhorn Dashboard, all should be green.
If a node were unschedulable or a volume degraded, Longhorn would already be rebuilding replicas elsewhere — but you always confirm your ground truth.


🏋️ Bonus Drills — for the command-line curious (optional)
==========================================================

New to Kubernetes? **Skip ahead freely** — everything that matters is in the UI. If you want to peek at the machinery, run these extra checks in the [button label="Cluster Terminal" variant="success"](tab-1):

- **See the Kubernetes control plane and CoreDNS endpoints:**

```bash,run
kubectl cluster-info --kubeconfig .rodeo/harvester-kubeconfig
```

- **Check cluster component health** — query the control plane's health endpoint; every check (etcd, informers, shutdown hooks) should report `ok`:

```bash,run
kubectl get --raw='/readyz?verbose' --kubeconfig .rodeo/harvester-kubeconfig
```

- **Confirm every node in the fabric is ready:**

```bash,run
kubectl get nodes --kubeconfig .rodeo/harvester-kubeconfig
```

  All nodes should show `Ready`.

- **Verify the core virtualization services are running:**

```bash,run
kubectl get pods -n harvester-system --kubeconfig .rodeo/harvester-kubeconfig | grep -v Completed
```

  All pods should be `Running`.

- **Confirm the exact platform version the bank is running:**

```bash,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get settings.harvesterhci.io server-version
```

💼 Why does this matter?
==============================================

- **One command center.** VMs, storage, and networking are visible from a single dashboard — no more juggling three separate management consoles with three separate licenses.
- **Kubernetes-native from day one.** Everything in the dashboard is a Kubernetes resource under the hood — the container team's existing skills transfer directly, while the VM team gets a friendly point-and-click UI.
- **Fleet management and RBAC included.** Rancher Prime is ready to command every cluster the bank will ever run, with one login and one set of access rules.
- **Distributed storage out of the box.** Longhorn replicates data across nodes automatically; no proprietary SAN, no synchronization nightmares.

Once you confirm the control plane is responding, the storage is healthy, and your administrative access is secured, you are ready to proceed deeper into the facility.

Click **Check** to descend into the datacenter. 🛗

📚 More information
===================

- [SUSE Virtualization — Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Hardware and Network Requirements](https://documentation.suse.com/cloudnative/virtualization/latest/en/installation-setup/requirements.html)
- [Kubernetes concepts](https://kubernetes.io/docs/concepts/overview/)

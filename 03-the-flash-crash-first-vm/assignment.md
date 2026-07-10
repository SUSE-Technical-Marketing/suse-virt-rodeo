---
slug: the-flash-crash-first-vm
id: 09d4eiczcvaw
type: challenge
title: ⚡ Chapter 3 — The Flash Crash
teaser: The Asian markets are melting down and the quants need a calculation engine
  NOW. Deploy a fully configured VM with storage and credentials in minutes, not days.
tabs:
- id: 6byxu4pxkfpm
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: 381amyptjwzi
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: wxzurljjianr
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: basic
timelimit: 3000
enhanced_loading: null
---

⚡ Chapter 3 — The Flash Crash
=============================

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
  img.animatedgif {
    --borderthickness: 5pt;
    --colors: #0000 25%,#30ba78 0;
    padding: 10px;
    background:
      conic-gradient(from 90deg  at top    var(--borderthickness) left  var(--borderthickness),var(--colors)) 0    0,
      conic-gradient(from 180deg at top    var(--borderthickness) right var(--borderthickness),var(--colors)) 100% 0,
      conic-gradient(from 0deg   at bottom var(--borderthickness) left  var(--borderthickness),var(--colors)) 0    100%,
      conic-gradient(from -90deg at bottom var(--borderthickness) right var(--borderthickness),var(--colors)) 100% 100%;
    background-size: 50px 50px;
    background-repeat: no-repeat;
    transition: 1s;
  }
  img.animatedgif:hover {
    background-size: 51% 51%;
  }
</style>

<img class="logos" alt="Welcome!" src="../assets/03-chapter-img.png"/>

<div class="storybox">

You are sitting in a makeshift office just outside the datacenter, halfway through reviewing the network topologies, when the overhead emergency lights suddenly pulse a harsh yellow. Your radio crackles to life. It is the **Head of Quantitative Trading**, and he sounds panicked.

*"We have a <span class="danger">massive anomaly</span> in the Asian markets!"* he shouts over the chaotic background noise of a frenzied trading floor. *"Our current algorithmic models are failing to parse the incoming data stream fast enough. We need a new, dedicated high-performance calculation engine deployed immediately, complete with a secondary high-speed data volume, or we are going to bleed millions in the next ten minutes!"*

In the past, fulfilling this emergency request at <b class="bank">Vertex Trust Bank</b> meant opening a priority ticket, waiting for the infrastructure team to carve out storage allocations, and manually installing an operating system. It was a process that took **days**.

You do not have days. **You have minutes.**

</div>

You bypass the legacy ticketing system entirely and prepare to deploy a fully configured Linux virtual machine — with injected security credentials and attached storage — in mere seconds.

<div class="missionbox">

## 🎯 Your Quest Objectives

1. Verify the operating system image
2. Provision the calculation engine
3. Attach the volumes and the production network
4. Inject security credentials and a fixed IP with cloud-init
5. Choose where the engine is allowed to run
6. Access the Web Console
7. Validate via Secure Shell

</div>

📀 Task 1: Verify the operating system image
============================================

Go to the [button label="SUSE Virtualization UI" variant="success"](tab-0), navigate to **Images**, and confirm that the base **openSUSE-Leap-15.5** operating system image is present and marked as **Active**.

> [!NOTE]
> Images in <b class="virt">SUSE Virtualization</b> are cluster-wide golden masters. Every VM you boot from this image gets its own copy-on-write disk — the image itself is never modified.

**If the image were missing**, you could add it yourself in seconds — no waiting for a storage admin. Images can be created from a URL, uploaded from your workstation, or exported from an existing volume via **Images > Create**:

<div style='align: middle; margin: 15px;'>
  <img class="animatedgif" src="../assets/04-create_vm_image.gif"/>
</div>

For example, to add a newer openSUSE Leap cloud image, you would paste this into the **URL** field:

```txt
https://mirror.rackspace.com/openSUSE/distribution/openSUSE-current/appliances/openSUSE-Leap-15.6-Minimal-VM.x86_64-Cloud.qcow2
```

> [!NOTE]
> The download runs server-side and takes a couple of minutes — the image becomes **Active** once Longhorn has it replicated.

🚀 Task 2: Provision the calculation engine
===========================================

Navigate to **Virtual Machines** and click the **Create** button. Configure the engine exactly as the quants need it:

| Setting | Value |
|--------:|:------|
| **Name** | <b class="highlightcopy">algo-trader-01</b> |
| **Namespace** | <b class="highlightcopy">vertex-trust-prod</b> |
| **CPU** | <b class="highlightcopy">2</b> |
| **Memory** | <b class="highlightcopy">4 GiB</b> |

Do **not** click Create yet — the trader also needs his data volume.

💽 Task 3: Attach the volumes and the production network
========================================================

Under the **Volumes** tab:

1. Select the **openSUSE-Leap-15.5** image as the primary boot disk
2. Click **Add Volume**
3. Set the **Name** to <b class="highlightcopy">market-data-vol</b>
4. Set the **Type** to `disk`
5. Set the **Size** to **10 GiB**

This fulfills the trader's request for a secondary high-speed data drive. Behind the scenes, both disks become replicated Longhorn volumes — the market data survives even if a physical disk dies mid-trade.

Now wire the engine into the bank's network. Under the **Networks** tab:

6. Make sure the network interface is attached to <b class="highlightcopy">default/vmnet</b> — the production VM network you built in the previous chapter

🔑 Task 4: Inject security credentials
======================================

Navigate to **Advanced Options**, then select **Cloud Config**. To ensure the trading system is accessible immediately upon boot without manual intervention, you must inject an initialization script.

In the **User Data** field, type exactly the following lines to set up the default password:

```yaml
#cloud-config
password: password123
chpasswd: { expire: False }
ssh_pwauth: True
```

The trading desk's firewall team has one more demand: the engine must come up on a **predictable address**, not whatever DHCP hands out. In the **Network Data** field, enter:

```yaml
version: 2
ethernets:
  enp1s0:
    addresses:
      - 192.168.122.50/24
    gateway4: 192.168.122.1
    nameservers:
      addresses:
        - 8.8.8.8
```

Cloud-init applies both on first boot — <b class="highlightcopy">algo-trader-01</b> will come online at `192.168.122.50` with zero post-deployment manual setup.

> [!NOTE]
> This is **cloud-init** — the same industry-standard mechanism used by every major public cloud. In production you would inject SSH keys, package installs, and hardening scripts instead of a demo password (the **SSH Keys** selector at the top of the create form does exactly that).

📍 Task 5: Choose where the engine is allowed to run
====================================================

One decision remains before launch. Go to **Node Scheduling**. <b class="virt">SUSE Virtualization</b> offers three placement policies:

- **Any available node** — the Kubernetes scheduler places the VM, and **live migration stays enabled**
- **Specific node** — pin the VM to one node (no migration possible)
- **Scheduling rules** — affinity rules based on node labels (GPU capability, NUMA topology, network zone…)

Select **Run virtual machine on any available node**.

> [!NOTE]
> Scheduling rules let you separate critical banking systems from background workloads — for example, pinning the trading engines to low-latency nodes while batch jobs share the rest. Keeping "any available node" here matters: it is what makes the zero-downtime evacuation in the next chapter possible.

Click **Create** to initialize the deployment.

🖥️ Task 6: Access the Web Console
=================================

Monitor the [button label="SUSE Virtualization UI" variant="success"](tab-0) until the virtual machine transitions to the **Running** state.

1. Click the **Console** button on the virtual machine row to open the VNC web console
2. Watch the Linux boot sequence complete
3. Close the console window

🔐 Task 7: Validate via Secure Shell
====================================

Thanks to the fixed address you injected, there is no hunting for IPs. Switch to the [button label="Cluster Terminal" variant="success"](tab-1) and wait for the engine to answer on the network:

```bash,run
until ping -c1 -W1 192.168.122.50 >/dev/null 2>&1; do echo "Waiting for the calculation engine..."; sleep 5; done; echo "Engine is on the network."
```

Establish the secure connection:

```bash
ssh opensuse@192.168.122.50
```

Enter the password <b class="highlightcopy">password123</b> when prompted.

Verify that the secondary 10 GiB data volume is successfully attached to the system:

```bash,run
lsblk
```

You should see the boot disk **and** a second 10 GiB block device. Type `exit` to close the connection.

🏋️ Bonus Drills — see through the abstraction (optional, for the command-line curious)
========================================================================================

New to Kubernetes? **Skip ahead freely.** Otherwise, back in the [button label="Cluster Terminal" variant="success"](tab-1), look at what the platform actually created for you:

- **The golden images are API objects too:**

```bash,run
kubectl get virtualmachineimages -A
```

- **The VM is a Kubernetes resource:**

```bash,run
kubectl get virtualmachines -n vertex-trust-prod
```

- **The running instance, with its node and IP** (the same IP you used for SSH):

```bash,run
kubectl get vmi -n vertex-trust-prod -o wide
```

- **The disks are ordinary PersistentVolumeClaims backed by Longhorn:**

```bash,run
kubectl get pvc -n vertex-trust-prod
```

You should recognize `market-data-vol` in the list — a banking data drive, expressed as cloud-native storage.

💼 Why does this matter for Vertex Trust Bank?
==============================================

- **Days become minutes.** A ticket-driven, multi-team provisioning process collapsed into a two-minute self-service workflow — during a live market crisis.
- **Consistency by construction.** Golden images plus cloud-init mean every engine the quants request boots identical, configured, and ready.
- **No stranded storage.** Volumes are carved from the shared Longhorn pool on demand — no more waiting for SAN LUN allocations.

<div class="storybox">

You radio back to the trading floor. *"Your engine is online and the data volume is attached."* The crisis is averted — but the day is far from over.

</div>

Click **Check** to continue. 🌊

📚 More information
===================

- [Creating Virtual Machines](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)
- [SUSE Virtualization — Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)

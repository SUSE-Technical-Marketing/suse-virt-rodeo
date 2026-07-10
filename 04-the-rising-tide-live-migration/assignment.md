---
slug: the-rising-tide-live-migration
id: xjv2r0tfyztq
type: challenge
title: "\U0001F30A Chapter 4 — The Rising Tide"
teaser: A coolant leak is flooding the rack hosting the Payment Gateway. Execute a
  zero-downtime live migration before the hardware shorts out — while transactions
  keep flowing.
tabs:
- id: fpgxlmifoynn
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: dltxk4yfrhwa
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: js6k1cai9uqc
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: intermediate
timelimit: 2400
enhanced_loading: null
---

🌊 Chapter 4 — The Rising Tide
==============================

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

<img class="logos" alt="Welcome!" src="../assets/04-chapter-img.png"/>

<div class="storybox">

The adrenaline from the trading floor incident has barely faded from your system when a deep, metallic groan echoes through the datacenter walls. You and Sarah turn simultaneously toward **Rack 4**. A primary coolant valve has ruptured overhead, and a steady stream of chilled, chemically treated water is cascading directly onto the physical server chassis hosting the bank's primary **Payment Gateway**.

*"If that server shorts out, the gateway drops,"* Sarah says, genuine panic creeping into her voice as she watches the water pool. *"If the gateway drops, every single credit card transaction for <b class="bank">Vertex Trust Bank</b> fails. We will be facing <span class="danger">federal regulatory investigations</span> by morning."*

*"We aren't going to let it drop,"* you reply, your fingers flying across your keyboard.

</div>

You cannot shut the machine down to move it; the transaction stream is too critical, processing thousands of requests a second. You must execute a **live migration** — moving a running VM, memory and all, to a different physical node with **zero downtime**.

But first, to ensure maximum bandwidth is available for the emergency migration, you decide to suspend a nearby non-critical batch processing server.

<div class="missionbox">

## 🎯 Your Quest Objectives

1. Suspend non-critical workloads to free resources
2. Establish a service heartbeat
3. Execute the Live Migration
4. Monitor the seamless transfer
5. Resume normal operations

</div>

⏸️ Task 1: Suspend non-critical workloads to free resources
===========================================================

In the [button label="SUSE Virtualization UI" variant="success"](tab-0), go to **Virtual Machines**:

1. Locate the virtual machine named <b class="highlightcopy">daily-batch-processor</b>
2. Click the **three vertical dots** on the right side of its row
3. Select **Pause**
4. Wait for its state to change to **Paused**

This halts its CPU cycles, dedicating maximum hardware resources to your emergency operation.

📡 Task 2: Establish a service heartbeat
========================================

Switch to the [button label="Cluster Terminal" variant="success"](tab-1). You need a continuous heartbeat monitor to prove the network connection remains unbroken during the evacuation.

Locate the IP address for <b class="highlightcopy">payment-gateway-prod</b> in the UI, then start the heartbeat (replace `PAYMENT_GATEWAY_IP` with the actual address):

```bash
ping PAYMENT_GATEWAY_IP
```

> [!IMPORTANT]
> Leave the ping running continuously in the terminal. **Do not stop it.** This scrolling stream of replies is your proof of zero downtime. Switch your focus back to the SUSE Virtualization UI.

🚚 Task 3: Execute the Live Migration
=====================================

In the [button label="SUSE Virtualization UI" variant="success"](tab-0), go to **Virtual Machines** and locate the <b class="highlightcopy">payment-gateway-prod</b> instance:

1. Read the **Node** column and **write down** which node the gateway is running on — you will want proof it moved
2. Click the **three vertical dots** on the far right side of its row
3. Select **Migrate** from the context menu
4. Choose a different, safe target node from the dropdown list
5. Click **Apply**

Behind the scenes, KubeVirt copies the VM's live memory pages to the target node over the network, tracking and re-copying any pages the busy gateway dirties mid-flight, until it can freeze, flip, and resume execution on the new node in a fraction of a second.

👀 Task 4: Monitor the seamless transfer
========================================

Immediately switch back to the [button label="Cluster Terminal" variant="success"](tab-1) tab and watch the ping sequence.

<div class="storybox">

You hold your breath as the hypervisor coordinates the massive memory transfer over the network. The pings continue scrolling down the screen, **completely uninterrupted**. The virtual machine seamlessly materializes on the new physical node just as sparks begin to fly from the water-damaged chassis in Rack 4.

</div>

Press `Ctrl+C` to terminate the ping. You exhale sharply. **The transaction flow survived.**

Back in the [button label="SUSE Virtualization UI" variant="success"](tab-0), the **Node** column for <b class="highlightcopy">payment-gateway-prod</b> now shows a **different node** than the one you wrote down — the gateway physically moved while its customers never noticed.

Now produce the evidence Sarah will forward to the regulators — the guest's uptime counter never reset, meaning the operating system never stopped running (replace `PAYMENT_GATEWAY_IP`):

```bash
ssh opensuse@PAYMENT_GATEWAY_IP "hostname && uptime"
```

▶️ Task 5: Resume normal operations
===================================

Return to the [button label="SUSE Virtualization UI" variant="success"](tab-0). Locate the <b class="highlightcopy">daily-batch-processor</b> you paused earlier:

1. Click the **three dots** on its row
2. Select **Unpause** to allow the non-critical jobs to resume

🏋️ Bonus Drills — the migration paper trail (optional, for the command-line curious)
======================================================================================

New to Kubernetes? **Skip ahead freely.** Otherwise: every migration is itself a Kubernetes object — which means it is auditable. In the [button label="Cluster Terminal" variant="success"](tab-1):

- **Review the migration record** (who moved, when, from where to where):

```bash,run
kubectl get virtualmachineinstancemigrations -A
```

- **Inspect the details of the completed migration:**

```bash,run
kubectl describe virtualmachineinstancemigrations -A | grep -A 10 "Status"
```

- **Think ahead:** what happens if a *node* fails without warning, before anyone can migrate? Check each VM's run strategy — SUSE Virtualization can reschedule VMs from a failed host automatically:

```bash,run
kubectl get vm -A -o custom-columns=NAME:.metadata.name,RUNSTRATEGY:.spec.runStrategy
```

> [!NOTE]
> **Beyond compute:** the same zero-downtime idea also applies to *disks*. <b class="virt">SUSE Virtualization</b> supports **in-place storage live migration** — moving a running VM's volumes between storage backends — for example from Longhorn to an external CSI array — without stopping the VM. Compute evacuated tonight, storage evacuated next quarter, and the gateway never notices either one.

💼 Why does this matter for Vertex Trust Bank?
==============================================

- **Hardware failures stop being outages.** Coolant leaks, firmware updates, host reboots — workloads simply slide to healthy nodes while customers keep paying with their cards.
- **Planned maintenance without midnight windows.** The same live migration you just used under fire is how the team will drain nodes for routine patching, at 2 PM instead of 2 AM.
- **An audit trail regulators can read.** Every migration is a recorded API object — no more reconstructing what happened from console screenshots.

Click **Check** to continue. 🕵️

📚 More information
===================

- [Live Migration](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/live-migration.html)

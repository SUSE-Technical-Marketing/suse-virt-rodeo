---
slug: the-rising-tide-live-migration
id: xjv2r0tfyztq
type: challenge
title: "<span id="assignment.65" lang="en" hist="sky-telco">🌊 Chapter 4: The Rising Tide</span>"
teaser: <span id="assignment.66" lang="en" hist="sky-telco">A coolant leak is flooding the rack hosting the Call Routing Gateway. Execute a
  zero-downtime live migration before the hardware shorts out, while calls and texts
  keep flowing.</span>
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
<span id="assignment.67" lang="en" hist="sky-telco">🌊 Chapter 4: The Rising Tide
==============================</span>
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
    padding: 4px 8px;
    border-bottom: none;
    border-left: 1px solid rgba(255,255,255,.25);
    border-radius: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #30ba78;
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

  .embedded_img {
    width: 100%;
    height: auto;
    max-height: 3vh;
    max-width: 3vh;
    margin: 0;
    padding: 0;
    display: inline-block;
  }

</style>

<img class="logos" alt="Welcome!" src="../assets/04-chapter-img.png"/>

<div id="401" class="story">

<span id="assignment.68" lang="en" hist="sky-telco">The adrenaline from the call center incident has barely faded from your system when a deep, metallic groan echoes through the datacenter walls. You and Sarah turn simultaneously toward **Rack 4**. A primary coolant valve has ruptured overhead, and a steady stream of chilled, chemically treated water is cascading directly onto the physical server chassis hosting Nimbus Telecom's primary **Call Routing Gateway**.

*"If that server shorts out, the gateway drops,"* Sarah says, genuine panic creeping into her voice as she watches the water pool. *"If the gateway drops, every single call and text message on our network fails. We'll have the FCC on the line by morning — assuming any lines still work."*

*"We aren't going to let it drop,"* you reply, your fingers flying across your keyboard.</span>

</div>

<span id="assignment.69" lang="en" no>You cannot shut the machine down to move it; the call stream is too critical, routing thousands of connections a second. You must execute a **live migration**, moving a running VM, memory and all, to a different physical node with **zero downtime**.

But first, to ensure maximum bandwidth is available for the emergency migration, you decide to suspend a nearby non-critical batch processing server.



## 🎯 Your Quest Objectives

1. Suspend non-critical workloads to free resources
2. Establish a service heartbeat
3. Execute the Live Migration
4. Monitor the seamless transfer
5. Resume normal operations
6. Hand the damaged rack to the repair crew



🔐 Login Credentials
====================

The <span id="assignment.69.1" lang="nolang" no>**SUSE Virtualization**</span> UI and **Rancher Prime** UI use the same credentials.</span>

<span id="assignment.70" lang="nolang" no>Username:</span>

<div class="cred">

```txt
admin
```

</div>

<span id="assignment.71" lang="nolang" no>Password:</span>

<div class="cred">

```txt
[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="kvm-host" ]]
```

</div>



<span id="assignment.72" lang="en" no>⏸️ Task 1: Suspend non-critical workloads to free resources
===========================================================


  



In the</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.73" lang="en" no>, go to <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>:

1. Locate the virtual machine named:</span>

<div class="cred">

```txt
daily-batch-processor
```

</div>

<span id="assignment.74" lang="en" no>2. Click the  on the right side of its row
3. Select <span id="assignment.74.1" lang="nolang" no>**Pause**</span> then click <span id="assignment.74.2" lang="nolang" no>**Apply**</span> after prompted to confirm.
4. Wait for its state to change to <span id="assignment.74.3" lang="nolang" no>**Paused**</span>

This halts its CPU cycles, dedicating maximum hardware resources to your emergency operation.

> [!NOTE]
> This is not really necessary, we have setup already a dedicated network for live migration traffic, is here for educational purposes</span>



<span id="assignment.75" lang="en" no>📡 Task 2: Establish a service heartbeat
========================================


  


Switch to the</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.76" lang="en" no>. You need a continuous heartbeat monitor to prove the network connection remains unbroken during the evacuation.

Start the heartbeat monitor from <span id="assignment.76.1" lang="nolang" no><b class="highlightcopy">webserver-prod</b></span>:

```bash,run
ssh -o StrictHostKeyChecking=accept-new  sles@[[ Instruqt-Var key="PAYMENT_GATEWAY_IP" hostname="kvm-host" ]] 'ping 192.168.122.1'

```

> [!IMPORTANT]
> Leave the ping running continuously in the terminal. **Do not stop it.** This scrolling stream of replies is your proof of zero downtime. Switch your focus back to the <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> UI.</span>

<span id="assignment.77" lang="en" no>🚚 Task 3: Execute the Live Migration
=====================================


  


In the</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.78" lang="en" no>, go to **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>** and locate the following instance:</span>

<div class="cred">

```txt
webserver-prod
```

</div>

<span id="assignment.79" lang="en" no>1. Read the <span id="assignment.79.1" lang="nolang" no>**Node**</span> column and **write down** which node the gateway is running on: you will want proof it moved
2. Click the  on the far right side of its row
3. Select <span id="assignment.79.2" lang="nolang" no>**Migrate**</span> from the context menu
4. Choose a different, safe target node from the dropdown list
5. Click <span id="assignment.74.2" lang="nolang" no>**Apply**</span>

Behind the scenes, <span id="assignment.2.3" lang="nolang" no>KubeVirt</span> copies the VM's live memory pages to the target node over the network, tracking and re-copying any pages the busy gateway dirties mid-flight, until it can freeze, flip, and resume execution on the new node in a fraction of a second.</span>

<span id="assignment.80" lang="en" no>👀 Task 4: Monitor the seamless transfer
========================================


  


Immediately switch back to the</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.81" lang="en" no>tab and watch the ping sequence.</span>

<div id="402" class="story">

<span id="assignment.82" lang="en" hist="sky-telco">You hold your breath as the <span id="ch1.intro1.1" lang="nolang" no>hypervisor</span> coordinates the massive memory transfer over the network. The pings continue scrolling down the screen, **completely uninterrupted**. The virtual machine seamlessly materializes on the new physical node just as sparks begin to fly from the water-damaged chassis in Rack 4.</span>

</div>

<span id="assignment.83" lang="en" no>Press `Ctrl+C` to terminate the ping.</span>

<div id="403" class="story">
<span id="assignment.84" lang="en" hist="sky-telco">You exhale sharply. The call flow survived.</span>
</div>


<span id="assignment.85" lang="en" no>Strictly speaking, there *is* a hand-over moment: once the memory copy converges, the VM freezes for one final instant while execution flips to the new node, a micro-interruption. On a properly sized infrastructure it passes completely unnoticed; even in this lab, which runs virtualization *inside* virtualization *inside* virtualization, the most you might have spotted is slightly higher latency times in the pings.

Back in the</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.86" lang="en" no>, the <span id="assignment.79.1" lang="nolang" no>**Node**</span> column for webserver-prod now shows a **different node** than the one you wrote down.</span><span id="assignment.87" lang="en" hist="sky-telco">The gateway physically moved while subscribers kept chatting, none the wiser.</span>

<div id="404" class="story">
<span id="assignment.88" lang="en" hist="sky-telco">Now produce the evidence Sarah will forward to the FCC — the guest's uptime counter never reset, meaning the operating system never stopped running:</span>
</div>

```bash,wrap,run
ssh -o StrictHostKeyChecking=accept-new  sles@[[ Instruqt-Var key="PAYMENT_GATEWAY_IP" hostname="kvm-host" ]] "hostname && uptime"
```

<span id="assignment.89" lang="en" no>▶️ Task 5: Resume normal operations
===================================


  


Return to the</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.90" lang="en" no>. Locate the virtual machine you paused earlier:</span>

<div class="cred">

```txt
daily-batch-processor
```

</div>

<span id="assignment.91" lang="en" no>1. Click the  on its row
2. Select <span id="assignment.91.1" lang="nolang" no>**Unpause**</span> to allow the non-critical jobs to resume

🛠️ Task 6: Hand the damaged rack to the repair crew
====================================================</span>


<div id="405" class="story">
<span id="assignment.92" lang="en" hist="sky-telco">The gateway is safe — but the water-damaged node is still dripping, and smaller workloads may still be running on it. You are not going to migrate them one by one while a puddle spreads across the floor. Let the platform manage it.</span>
</div>


<span id="assignment.93" lang="en" no>In the</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.94" lang="en" no>, go to <span id="assignment.94.1" lang="nolang" no>**Hosts**</span>:

1. Find the node that webserver-prod was running on **before** the migration, the one you wrote down.</span>

<i id="406" class="story"><span id="assignment.95" lang="en" hist="sky-telco">That is the water-damaged machine</span></i>

<span id="assignment.96" lang="en" no>2. Click the  on its row and select <span id="assignment.96.1" lang="nolang" no>**Enable Maintenance Mode**</span>, then <span id="assignment.96.2" lang="nolang" no>confirm</span>

Now watch the **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>** page: every VM still living on the damaged node live-migrates off it **automatically**. The platform picks healthy target nodes, moves the workloads one by one, and leaves the node empty. No spreadsheets, no manual target-picking, no forgotten VM.

> [!NOTE]
> This may take some time in this lab environment.

Once the node shows <span id="assignment.96.3" lang="nolang" no>**Maintenance**</span> and its VM count reaches zero, the (virtual) repair crew swaps the (virtual) coolant valve. Bring the node back into service:

3. Click the  on its row again and select <span id="assignment.96.4" lang="nolang" no>**Uncordon**</span> and then <span id="assignment.96.5" lang="nolang" no>**Disable Maintenance Mode**</span>

The node rejoins the fabric, ready to accept workloads again.

> [!NOTE]
> The same intelligence works in the other direction, too: every time a new VM is created, the scheduler places it on the least-loaded suitable node, keeping the cluster naturally balanced, no manual Tetris required. Between automatic placement on the way in and automatic evacuation on the way out, the humans only decide *what* should run; the platform decides *where*.</span>

<span id="assignment.97" lang="en" no>🏋️ Bonus Drills: the migration paper trail (optional, for the command-line curious)
======================================================================================


  


New to <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Skip ahead freely.** Otherwise: every migration is itself a <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> object, which means it is auditable. In the</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.98" lang="en" no>:

- **Review the migration record** (who moved, when, from where to where):

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachineinstancemigrations -A
```

- **Inspect the details of the completed migration:**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig describe virtualmachineinstancemigrations -A | grep -A 10 "Status"
```

- **Think ahead:** what happens if a *node* fails without warning, before anyone can migrate? Check each VM's run strategy: <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> can reschedule VMs from a failed host automatically:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get vm -A -o custom-columns=NAME:.metadata.name,RUNSTRATEGY:.spec.runStrategy
```

> [!NOTE]
> **Beyond compute:** the same zero-downtime idea also applies to *disks*. <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> supports **in-place storage live migration** (moving a running VM's volumes between storage backends, for example from <span id="assignment.2.8" lang="nolang" no>Longhorn</span> to an external <span id="assignment.2.9" lang="nolang" no>CSI</span> array) without stopping the VM. Compute evacuated tonight, storage evacuated next quarter, and the gateway never notices either one.</span>

<span id="assignment.99" lang="en" no>💼 Why does this matter?
==============================================

- **Hardware failures stop being outages.** Coolant leaks, firmware updates, host reboots: workloads simply slide to healthy nodes while calls keep connecting and texts keep landing.
- **Planned maintenance without midnight windows.** One click on **Maintenance Mode** drains an entire node automatically. Routine patching happens at 2 PM instead of 2 AM, and nobody keeps a spreadsheet of which VM lives where.
- **An audit trail regulators can read.** Every migration is a recorded API object, no more reconstructing what happened from console screenshots when the FCC comes asking.

Click **Check** to continue. 🕵️

📚 More information
===================</span>

- [Live Migration](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/live-migration.html)

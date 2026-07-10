---
slug: the-stampede-automation
id: euwnv5ojhvfl
type: challenge
title: "\U0001F920 Chapter 7 — The Stampede"
teaser: The markets are in freefall and the quants need the calculation fleet scaled
  from three nodes to five — now. Forge a golden VM template and stamp out identical
  machines on demand.
tabs:
- id: xxc2ymjtxzih
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: uclhjzflraeo
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: inaridrpaxka
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: intermediate
timelimit: 3000
enhanced_loading: null
---

🤠 Chapter 7 — The Stampede
===========================

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

<img class="logos" alt="Welcome!" src="../assets/07-chapter-img.png"/>

<div class="storybox">

A sudden, aggressive shift in global interest rates sends the financial markets into a chaotic frenzy. <b class="bank">Vertex Trust Bank</b>'s risk analysis algorithms are screaming for more compute capacity to process the incoming flood of volatile market data.

*"One calculation engine is not enough anymore!"* the **Head of Quant** shouts across the room, waving a printed report. *"I need a fleet of <span class="danger">five identical engines immediately</span>, or we fly blind into this market crash!"*

Building five machines by hand, one screen at a time, invites exactly what you cannot afford right now: a mistyped memory size here, a forgotten network there. Configuration drift under pressure — and right now, human error costs millions of dollars **per second**.

You crack your knuckles. What the bank needs is a **golden blueprint**: define the perfect machine once, then stamp out identical copies on demand.

</div>

<b class="virt">SUSE Virtualization</b> has exactly that: **VM Templates**. A template captures CPU, memory, disks, networks, and cloud-init in a single versioned object. Combined with **multi-instance creation**, one blueprint becomes an entire fleet in a single click.

<div class="missionbox">

## 🎯 Your Quest Objectives

1. Forge the golden template
2. Stamp out the initial fleet
3. Scale the fleet under pressure
4. Stand the fleet down

</div>

📜 Task 1: Forge the golden template
====================================

In the [button label="SUSE Virtualization UI" variant="success"](tab-0), navigate to **Advanced > Templates** and click **Create**. Define the blueprint for the calculation engines:

| Setting | Value |
|--------:|:------|
| **Name** | <b class="highlightcopy">stress-test-template</b> |
| **Namespace** | <b class="highlightcopy">vertex-trust-prod</b> |
| **CPU** | <b class="highlightcopy">1</b> |
| **Memory** | <b class="highlightcopy">2 GiB</b> |

Then:

1. Under the **Volumes** tab, select the **openSUSE-Leap-15.5** image as the boot disk
2. Under the **Networks** tab, attach the interface to <b class="highlightcopy">default/vmnet</b>
3. Under **Advanced Options > Cloud Config**, paste the same credential bootstrap you used during the Flash Crash into **User Data**:

```yaml
#cloud-config
password: password123
chpasswd: { expire: False }
ssh_pwauth: True
```

4. Click **Create**

The blueprint is forged. Every engine born from it will be configured identically — down to the last byte.

> [!NOTE]
> Templates are **versioned**. If you later edit the template, a new version is created while machines built from older versions keep their lineage — a full audit trail of what was deployed from which blueprint, which your regulators will appreciate.

🏭 Task 2: Stamp out the initial fleet
======================================

Navigate to **Virtual Machines** and click **Create**:

1. Select **Multiple Instance** at the top of the form
2. Set the **VM Name Prefix** to <b class="highlightcopy">stress-test</b>
3. Set the **Count** to <b class="highlightcopy">3</b>
4. Tick **Use VM Template** and select <b class="highlightcopy">stress-test-template</b> (default version)
5. Make sure the **Namespace** is <b class="highlightcopy">vertex-trust-prod</b>
6. Click **Create**

Watch as <b class="highlightcopy">stress-test-01</b>, <b class="highlightcopy">stress-test-02</b>, and <b class="highlightcopy">stress-test-03</b> materialize in the list and boot in parallel.

Three identical engines, born from one blueprint. No tickets. No checklists. No slipped cursors.

📈 Task 3: Scale the fleet under pressure
=========================================

The Head of Quant needs **five** engines, not three. Because the blueprint already exists, scaling out is the same three clicks — click **Create** again:

1. Select **Multiple Instance**
2. Set the **VM Name Prefix** to <b class="highlightcopy">stress-test-surge</b>
3. Set the **Count** to <b class="highlightcopy">2</b>
4. Tick **Use VM Template** and select <b class="highlightcopy">stress-test-template</b> again
5. Click **Create**

<b class="highlightcopy">stress-test-surge-01</b> and <b class="highlightcopy">stress-test-surge-02</b> boot up and join the fleet — bit-for-bit identical to the first three, because they come from the exact same versioned blueprint.

<div class="storybox">

The risk analysis team begins feeding data into the expanded fleet, stabilizing the bank's market position just in time.

</div>

> [!NOTE]
> Everything you just clicked is also available through the platform's API — which means fleet operations like this can be fully automated and code-reviewed like any other change. Choosing the bank's automation toolchain is a story for another sprint.

🧹 Task 4: Stand the fleet down
===============================

Once the market surge subsides, return the capacity to the pool. In **Virtual Machines**:

1. Tick the **checkboxes** next to all five `stress-test*` machines
2. Click **Delete** and confirm

Five machines summoned, used, and returned — and the only artifact left behind is the golden template, versioned and waiting for the next flash crash.

🏋️ Bonus Drills — for the command-line curious (optional)
==========================================================

New to Kubernetes? **Skip ahead freely.** Otherwise, prove in the [button label="Cluster Terminal" variant="success"](tab-1) that the UI, the fleet, and the API all agree:

- **Count the fleet from the command line** (run this between Task 3 and Task 4 to see all five):

```bash,run
kubectl --kubeconfig .kube/harvester.yaml get vm -n vertex-trust-prod | grep stress-test
```

- **Inspect the blueprint as an API object** — templates and their versions are resources too:

```bash,run
kubectl --kubeconfig .kube/harvester.yaml get virtualmachinetemplates,virtualmachinetemplateversions -n vertex-trust-prod
```

💼 Why does this matter for Vertex Trust Bank?
==============================================

- **Elasticity on owned hardware.** Cloud-style scale-out (and scale-in) on the bank's own datacenter — no data residency questions, no egress bills.
- **Human error is engineered out.** Machines come from a versioned golden blueprint, not from memory and muscle — configuration drift cannot happen at 2 AM.
- **Full lifecycle economics.** Decommissioning is a checkbox and a click, so temporary capacity never becomes permanent cost — the exact opposite of the old hypervisor sprawl.

Click **Check** to continue. ⚔️

📚 More information
===================

- [SUSE Virtualization — Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Creating Virtual Machines](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)

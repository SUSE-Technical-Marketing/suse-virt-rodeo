---
slug: the-stampede-automation
id: euwnv5ojhvfl
type: challenge
title: "<span id="assignment.138" lang="en" no>\U0001F920 Chapter 7: The Stampede</span>"
teaser: <span id="assignment.139" lang="en" hist="vertrex-bank">The markets are in freefall and the quants need the calculation fleet scaled
  from three nodes to five, now. Forge a golden VM template and stamp out identical
  machines on demand.</span>
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
<span id="assignment.140" lang="en" no>

🤠 Chapter 7: The Stampede
===========================
</span>
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
    border-left: 1px solid rgba(255,255,255,.25);
    border-radius: 0;
    display: flex;
    align-items: center;
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
    max-height: 1.5vh;
    max-width: 1.5vh;
    margin: 0;
    padding: 0;
    display: inline-block;
  }

</style>

<img class="logos" alt="Welcome!" src="../assets/07-chapter-img.png"/>

<div id="701" class="story">

<span id="assignment.141" lang="en" hist="vertrex-bank">
A sudden, aggressive shift in global interest rates sends the financial markets into a chaotic frenzy. <b class="bank">Vertex Trust Bank</b>'s risk analysis algorithms are screaming for more compute capacity to process the incoming flood of volatile market data.

*"One calculation engine is not enough anymore!"* the **Head of Quant** shouts across the room, waving a printed report. *"I need a fleet of <span class="danger">five identical engines immediately</span>, or we fly blind into this market crash!"*

Building five machines by hand, one screen at a time, invites exactly what you cannot afford right now: a mistyped memory size here, a forgotten network there. Configuration drift under pressure — and right now, human error costs millions of dollars **per second**.

You crack your knuckles. What the bank needs is a **golden blueprint**: define the perfect machine once, then stamp out identical copies on demand.
</span>

</div>

<span id="assignment.142" lang="en" no><b class="virt"><span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span></b> has exactly that: **VM Templates**. A template captures CPU, memory, disks, networks, and cloud-init in a single versioned object. Combined with **multi-instance creation**, one blueprint becomes an entire fleet in a single click.

<div class="missionbox">

## 🎯 Your Quest Objectives

1. Forge the golden template
2. Scale the fleet under pressure
3. Stand the fleet down

</div>

🔐 Login Credentials
====================

The <span id="assignment.69.1" lang="nolang" no>**SUSE Virtualization**</span> UI and **Rancher Prime** UI use the same credentials.
</span>

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



<span id="assignment.143" lang="en" no>📜 Task 1: Forge the golden template
====================================

<div style='align: middle; margin: 15px;'>
  <img class="animatedgif" src="../assets/chapter7-prod-vm-template.gif"/>
</div>

You need a template that speeds up the deployment of virtual machines and standardizes them.
In </span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.144" lang="en" no> navigate to <span id="assignment.144.1" lang="nolang" no>**Advanced > Templates**</span> and click <span id="assignment.19.3" lang="nolang" no>**Create**</span>, then fill in the following details:

- <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: <b class="highlightcopy">prod</b>
- <span id="assignment.144.2" lang="nolang" no>**Template Name**</span>:
</span>

<div class="cred">

```txt
prod-basic
```

</div>

<span id="assignment.145" lang="en" no>
We need to minimize resource usage, and all the VMs should be reachable using the production SSH key, which is securely guarded.

- Basics:
  - <span id="assignment.42.1" lang="nolang" no>**CPU**</span>: <b class="highlightcopy">1</b>
  - <span id="assignment.145.1" lang="nolang" no>**Memory**</span>: <b class="highlightcopy">1</b>
  - <span id="assignment.45.1" lang="nolang" no>**SSHKey**</span>: <b class="highlightcopy">prod/default</b>

Our default base OS is SLES 16.

- <span id="assignment.6.4" lang="nolang" no>Volumes</span>:
  - <span id="assignment.45.2" lang="nolang" no>**Image**</span>: <b class="highlightcopy">official-images/SLES-16.0-Minimal-VM.x86_64-Cloud-GM.qcow2</b>
  - <span id="assignment.45.3" lang="nolang" no>**Size**</span>: <b class="highlightcopy">5</b>

We want production servers to offer their services on the production service network.

- <span id="assignment.49.1" lang="nolang" no>Networks</span>:
  - <span id="assignment.49.2" lang="nolang" no>**Network**</span>: <b class="highlightcopy">prod/service</b>

All production VMs should run only on production-ready hosts.

- <span id="assignment.51.1" lang="nolang" no>Node Scheduling</span>:
  1. Select <span id="assignment.51.5" lang="nolang" no>**Run virtual machine on node(s) matching scheduling rules**</span>
  2. Click <span id="assignment.51.6" lang="nolang" no>**Add Node Selector**</span>, then <span id="assignment.51.7" lang="nolang" no>**Add Rule**</span>:


- <span id="assignment.51.8" lang="nolang" no>**Key**</span>:
</span>

<div class="cred">

```txt
stage
```

</div>

<span id="assignment.52" lang="en" no>
- **Value**:
</span>

<div class="cred">

```txt
prod
```

</div>


<span id="assignment.146" lang="en" no>
We want the VMs to be properly labeled:

- <span id="assignment.53.1" lang="nolang" no>Labels</span>:
  - Click <span id="assignment.53.3" lang="nolang" no>**Add Label**</span>:


- <span id="assignment.51.8" lang="nolang" no>**Key**</span>:
</span>
<div class="cred">

```txt
stage
```

</div>

<span id="assignment.52" lang="en" no>
- **Value**:
</span>
<div class="cred">

```txt
prod
```

</div>


<span id="assignment.147" lang="en" no>
Finally, we want all production machines standardized on a set of packages and settings:

- <span id="assignment.54.1" lang="nolang" no>Advanced Options</span>:
  - <span id="assignment.54.4" lang="nolang" no>**User Data Template**</span>: <b class="highlightcopy">prod/prod</b>

To finalize, click <span id="assignment.19.3" lang="nolang" no>**Create**</span>.

Can you imagine filling in all these details every time? People would give up, and the environment would fill up with inconsistency, and inconsistency makes further automation even more difficult.


> [!NOTE]
> Templates are **versioned**. If you later edit the template, a new version is created while machines built from older versions keep their lineage: a full audit trail of what was deployed from which blueprint, which your regulators will appreciate.


📈 Task 2: Scale the fleet under pressure
=========================================

Because the template already exists, deploying multiple servers takes just a few clicks.

<div style='align: middle; margin: 15px;'>
  <img class="animatedgif" src="../assets/chapter7-fleet-vms.gif"/>
</div>

In </span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.148" lang="en" no> go to **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>** and click <span id="assignment.19.3" lang="nolang" no>**Create**</span>, then fill in the following details:

1. Select <span id="assignment.148.1" lang="nolang" no>**Multiple Instance**</span>
2. Set the <span id="assignment.39.3" lang="nolang" no>**Namespace**</span> to <b class="highlightcopy">prod</b>
3. Set the <span id="assignment.148.2" lang="nolang" no>**Name Prefix**</span> to:
</span>

<div class="cred">

```txt
appcluster
```

</div>


<span id="assignment.149" lang="en" no>
4. Set the <span id="assignment.149.1" lang="nolang" no>**Count**</span> to <b class="highlightcopy">2</b>
5. Tick <span id="assignment.149.2" lang="nolang" no>**Use VM Template**</span> and set the <span id="assignment.149.3" lang="nolang" no>**Template**</span> to <b class="highlightcopy">prod/prod-basic</b>
6. Click <span id="assignment.19.3" lang="nolang" no>**Create**</span>
</span>




<div id="702" class="story">

<span id="assignment.150" lang="en" hist="vertrex-bank">
The risk analysis team begins feeding data into the expanded fleet, stabilizing the bank's market position just in time.
</span>

</div>


<span id="assignment.151" lang="en" no>🧹 Task 3: Stand the fleet down
===============================
</span>

<div id="703" class="story">

<span id="assignment.152" lang="en" hist="vertrex-bank">
The market surge subsides. The virtual machines sit idle, waiting for the next wave — but will it come today? Tomorrow? Next month? For these noble servers, waiting is more painful than doing all the number crunching.
</span>

</div>

<span id="assignment.153" lang="en" no>
You no longer need so many virtual machines, delete them all at once (don't worry if they are still starting).

<div style='align: middle; margin: 15px;'>
  <img class="animatedgif" src="../assets/chapter7-fleet-vms-delete.gif"/>
</div>


In </span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.154" lang="en" no> navigate to the <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span> section:

1. Tick the <span id="assignment.154.1" lang="nolang" no>**checkboxes**</span> next to all the new virtual machines you created
2. Click <span id="assignment.137.2" lang="nolang" no>**Delete**</span>, tick <span id="assignment.154.2" lang="nolang" no>**Delete All**</span>, and click <span id="assignment.154.3" lang="nolang" no>**Delete**
</span>
</span>

<div id="704" class="story">

<span id="assignment.155" lang="en" hist="vertrex-bank">
The suffering of these noble virtual machines has stopped. You see the flames, my child? Now they rest in Valhalla.
</span>

</div>




<span id="assignment.156" lang="en" no>🏋️ Bonus Drills: for the command-line curious (optional)
==========================================================

New to <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Skip ahead freely.** Otherwise, prove in the </span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.157" lang="en" no> that the UI, the fleet, and the API all agree:

- **Inspect the template as an API object**: templates and their versions are resources too:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplates,virtualmachinetemplateversions -n prod
```

- **Retrieve the template definition in yaml format**:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplates -n prod prod-basic -o yaml > template_prod-basic.yaml
template_version_name=`kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplateversions -n prod -o name |grep '/prod-basic-'`
kubectl --kubeconfig .rodeo/harvester-kubeconfig get -n prod ${template_version_name} -o yaml >> template_prod-basic.yaml
```

You can examine the file `template_prod-basic.yaml`:


```bash,wrap,run
less template_prod-basic.yaml
```


It contains a definition similar to the one you used to create the template in Task 2.



💼 Why does this matter?
==============================================

- **Elasticity on owned hardware.** <span id="assignment.157.1" lang="en" hist="vertrex-bank">Cloud-style scale-out (and scale-in) on the bank's own datacenter: no data residency questions, no egress bills.</span>
- **Human error is engineered out.** Machines come from a versioned golden blueprint, not from memory and muscle: configuration drift cannot happen at 2 AM.
- **Full lifecycle economics.** Decommissioning is a checkbox and a click, so temporary capacity never becomes permanent cost, the exact opposite of the old <span id="ch1.intro1.1" lang="nolang" no>hypervisor</span> sprawl.

Click <span id="assignment.32.1" lang="nolang" no>**Check**</span> to continue. ⚔️

📚 More information
===================
</span>

- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Creating <span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)

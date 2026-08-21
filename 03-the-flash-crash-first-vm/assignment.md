---
slug: the-flash-crash-first-vm
id: 09d4eiczcvaw
type: challenge
title: '<span id="assignment.33" lang="en" hist="vertrex-bank">⚡ Chapter 3: The Flash Crash</span>'
teaser: <span id="assignment.34" lang="en" hist="vertrex-bank">The Asian markets are melting down and the quants need a calculation engine
  NOW. Deploy a fully configured VM with storage and credentials in minutes, not days.</span>
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
<span id="assignment.35" lang="en" hist="vertrex-bank">

⚡ Chapter 3: The Flash Crash
=============================

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
    max-height: 1.5vh;
    max-width: 1.5vh;
    margin: 0;
    padding: 0;
    display: inline-block;
  }

</style>

<img class="logos" alt="Welcome!" src="../assets/03-chapter-img.png"/>

<div id="301" class="story">

<span id="assignment.36" lang="en" hist="vertrex-bank">
You are sitting in a makeshift office just outside the datacenter, halfway through reviewing the network topology, when the overhead emergency lights suddenly pulse a harsh yellow. Your radio crackles to life. It is the **Head of Quantitative Trading**, and he sounds panicked.

*"We have a <span class="danger">massive anomaly</span> in the Asian markets!"* he shouts over the chaotic background noise of a frenzied trading floor. *"Our current algorithmic models are failing to parse the incoming data stream fast enough. We need a new, dedicated high-performance calculation engine deployed immediately, complete with a secondary high-speed data volume, or we are going to bleed millions in the next ten minutes!"*

In the past, fulfilling this emergency request at <b class="bank">Vertex Trust Bank</b> meant opening a priority ticket, waiting for the infrastructure team to carve out storage allocations, and manually installing an operating system. It was a process that took **days**.

You do not have days. **You have minutes.**



You bypass the legacy ticketing system entirely and prepare to deploy a fully configured <span id="assignment.2.6" lang="nolang" no>Linux</span> virtual machine (with injected security credentials and attached storage) in mere seconds.
</span>
</div>


<span id="assignment.37" lang="en" no>
<div class="missionbox">

## 🎯 Your Quest Objectives

1. Verify the operating system image
2. Provision the <span id="assignment.37.1" lang="en" hist="vertrex-bank">calculation engine</span>
3. Access the Web Console

</div>

🔐 Login Credentials
====================

The **<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>** UI and **Rancher Prime** UI use the same credentials.
</span>

<span id="assignment.10" lang="nolang" no>Username</span>:

<div class="cred">

```txt
admin
```

</div>

<span id="assignment.11" lang="nolang" no>Password</span>:

<div class="cred">

```txt
[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="kvm-host" ]]
```

</div>




<span id="assignment.38" lang="en" no>
📀 Task 1: Verify the operating system image
============================================

Go to the </span> [button label="<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> UI" variant="success"](tab-0) <span id="assignment.39" lang="en" no>, navigate to **<span id="assignment.6.3" lang="nolang" no>Images</span>** on the left side panel, and confirm that the base <span id="assignment.39.1" lang="nolang" no>**SLES-16.0-Minimal-VM.x86_64-Cloud-GM.qcow2**</span> operating system image is present and marked as **<span id="assignment.6.17" lang="nolang" no>Active</span>**.

> [!NOTE]
> <span id="assignment.6.3" lang="nolang" no>Images</span> in <b class="virt"><span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span></b> are cluster-wide golden masters. Every VM you boot from this image gets its own copy-on-write disk. The image itself is never modified.

**If the image were missing**, you could add it yourself in seconds, no waiting for a storage admin.

Images can be created from a URL, uploaded from your workstation, or exported from an existing volume via <span id="assignment.39.2" lang="nolang" no>**Images > Create**</span>:

<div style='align: middle; margin: 15px;'>
  <img class="animatedgif" src="../assets/chapter3-new-image.gif"/>
</div>

For example, let's add a new image:

1. Go to **<span id="assignment.6.3" lang="nolang" no>Images</span>** on the left panel and click <span id="assignment.19.3" lang="nolang" no>**Create**</span>, then fill in the following details:
   - <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: <b class="highlightcopy">official-images</b>
   - <span id="assignment.19.4" lang="nolang" no>**Name**</span>: filled in automatically
   - <b style="color:#30ba78;">Basics</b>:
     - <span id="assignment.39.4" lang="nolang" no>**URL**</span>:

</span>

<div class="cred">

```txt
http://192.168.122.1:8889/SLES15-SP7-Minimal-VM.x86_64-Cloud-GM.qcow2
```

</div>


<span id="assignment.40" lang="en" no>

2. Click <span id="assignment.19.3" lang="nolang" no>**Create**</span>

The image you just created appears in the list with the state <span id="assignment.40.1" lang="nolang" no>**Downloading**</span>. You can follow it in the progress column.

Move on to the next task; once the download completes, an alert shows up in the **notification bell** at the top right of the screen.


> [!NOTE]
> The download runs server-side, from a local mirror on this lab's own network, so it lands in seconds. The image becomes **<span id="assignment.6.17" lang="nolang" no>Active</span>** once <span id="assignment.2.8" lang="nolang" no>Longhorn</span> has it replicated.


🚀 Task 2: Provision the calculation engine
===========================================


For this task we are going to create our first VM.


> [!NOTE]
> Please don't click <span id="assignment.19.3" lang="nolang" no>**Create**</span> until instructed.

<div style='align: middle; margin: 15px;'>
  <img class="animatedgif" src="../assets/chapter3-new-vm.gif"/>
</div>


Navigate to <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span> and click the <span id="assignment.19.3" lang="nolang" no>**Create**</span> button.

<span id="assignment.40.3" lang="en" hist="vertrex-bank">Configure the engine exactly as the quants need it:</span>

- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:
</span>
<div class="cred">

```txt
the-engine-01
```

</div>

<span id="assignment.41" lang="nolang" no>
- **Namespace**:
</span>
<div class="cred">

```txt
prod
```

</div>


<span id="assignment.42" lang="en" no>
  If the namespace does not exist, create it.

- <span id="assignment.42.1" lang="nolang" no>**CPU**</span>:
</span>
<div class="cred">

```txt
2
```

</div>


<span id="assignment.43" lang="nolang" no>
- **Memory**:
</span>
<div class="cred">

```txt
2
```

</div>


<span id="assignment.44" lang="en" hist="vertrex-bank">
Notice the very low resources: our future crew of quants is highly skilled, and their application is extremely optimized for low latency and low resource usage.
</span>

<span id="assignment.45" lang="en" no>
- <span id="assignment.45.1" lang="nolang" no>**SSHKey**</span>: <b class="highlightcopy">prod/default</b>




Under the <b style="color:#30ba78;"><span id="assignment.6.4" lang="nolang" no>Volumes</span></b> tab (green, not to be confused with the one in black), fill in the following details:

- <span id="assignment.45.2" lang="nolang" no>**Image**</span>: <b class="highlightcopy">official-images/SLES-16.0-Minimal-VM.x86_64-Cloud-GM.qcow2</b>
- <span id="assignment.45.3" lang="nolang" no>**Size**</span>:
</span>
<div class="cred">

```txt
5
```

</div>

<span id="assignment.46" lang="en" no>
Then add a new volume by clicking <span id="assignment.46.1" lang="nolang" no>**Add Volume**</span>, and fill in the following details:

- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:
</span>
<div class="cred">

```txt
market-data-vol
```

</div>

<span id="assignment.47" lang="nolang" no>
- **Size**:
</span>
<div class="cred">

```txt
1
```

</div>

<span id="assignment.48" lang="en" hist="vertrex-bank">
Now wire the engine into the bank's network.</span><span id="assignment.49" lang="en" no>Under the <span id="assignment.49.1" lang="nolang" no><b style="color:#30ba78;">Networks</b></span> tab (green, not to be confused with the one in black):

- <span id="assignment.49.2" lang="nolang" no>**Network**</span>: <span id="assignment.49.3" lang="nolang" no><b class="highlightcopy">prod/service</b></span>




</span>
<div id="302" class="story">


<span id="assignment.50" lang="en" hist="vertrex-bank">
This fulfills the trader's request for a secondary high-speed data drive. Behind the scenes, both disks become replicated <span id="assignment.2.8" lang="nolang" no>Longhorn</span> volumes, the market data survives even if a physical disk dies mid-trade.
</span>

</div>


<span id="assignment.51" lang="en" no>


Since this is a mixed-environment cluster, let's make sure the VM runs only on production nodes.

Click on <span id="assignment.51.1" lang="nolang" no><b style="color:#30ba78;">Node Scheduling</b></span>: <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> offers three choices:

- <span id="assignment.51.2" lang="nolang" no>**Any available node**</span>: the <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> scheduler chooses where to place the VM, and **live migration stays enabled**
- <span id="assignment.51.3" lang="nolang" no>**Specific node**</span>: pin the VM to one node (no migration possible)
- <span id="assignment.51.4" lang="nolang" no>**Scheduling rules**</span>: affinity rules based on node labels (GPU capability, NUMA topology, network zone…)

Configure the production rule:

1. Select <span id="assignment.51.5" lang="nolang" no>**Run virtual machine on node(s) matching scheduling rules**</span>
2. Click <span id="assignment.51.6" lang="nolang" no>**Add Node Selector**</span>, then <span id="assignment.51.7" lang="nolang" no>**Add Rule**</span>:

- <span id="assignment.51.8" lang="nolang" no>**Key**</span>:
</span>
<div class="cred">

```txt
stage
```

</div>

<span id="assignment.52" lang="nolang" no>
- **Value**:
</span>
<div class="cred">

```txt
prod
```

</div>


<span id="assignment.53" lang="en" no>
Now assign it a label:

Go to the <span id="assignment.53.1" lang="nolang" no><b style="color:#30ba78;">Labels</b></span> tab (not to be confused with <span id="assignment.53.2" lang="nolang" no>"Instance Labels"</span>) and click <span id="assignment.53.3" lang="nolang" no>**Add Label**</span>:

- <span id="assignment.51.8" lang="nolang" no>**Key**</span>:
</span>
<div class="cred">

```txt
stage
```

</div>

<span id="assignment.52" lang="nolang" no>
- **Value**:
</span>
<div class="cred">

```txt
prod
```

</div>

<span id="assignment.54" lang="en" no>
This will help us manage the VM with future automation.


Navigate to <span id="assignment.54.1" lang="nolang" no><b style="color:#30ba78;">Advanced Options</b></span> (don't mistake it with <span id="assignment.54.2" lang="nolang" no>'Advanced'</span> on the left column), then select <span id="assignment.54.3" lang="nolang" no>**Cloud Configuration**</span>, to make sure the system comes up with all the required settings and packages installed.

Click on <span id="assignment.54.4" lang="nolang" no>**User Data Template**</span> and select <span id="assignment.54.5" lang="nolang" no>**Create New**</span> to define a standard template. Name it:

- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:
</span>
<div class="cred">

```txt
prod
```

</div>


<span id="assignment.55" lang="en" no>
For the <span id="assignment.55.1" lang="nolang" no>**User Data**</span>, enter:

```yaml
#cloud-config
packages:
  - qemu-guest-agent
runcmd:
  - - systemctl
    - enable
    - --now
    - qemu-guest-agent.service
write_files:
  - path: /etc/issue
    content: |
      \e{red}Production\e{reset}
    append: true
ssh_authorized_keys:
  - ssh-ed25519
    AAAAC3NzaC1lZDI1NTE5AAAAIFdt8wX4G0WGg/l4uDq/LntBO7WiNyqh0+pNUzF/NfMa
```

Save the template by clicking in <span id="assignment.19.3" lang="nolang" no>**Create**</span> (inside the template box)


Since the template lives in the <span id="assignment.55.2" lang="nolang" no><b class="highlightcopy">prod</b></span> namespace and is itself named <span id="assignment.55.2" lang="nolang" no><b class="highlightcopy">prod</b></span>, it becomes <b class="highlightcopy">prod/prod</b>: the production standard, ready to use for every VM.


</span>
<div id="303" class="story">
<span id="assignment.56" lang="en" hist="vertrex-bank">
The trading desk's firewall team has one more demand:
</span>
</div>

<span id="assignment.57" lang="en" no>
The engine must come up on a **predictable address**, not whatever DHCP hands out. In the <span id="assignment.57.1" lang="nolang" no>**Network Data**</span> field, enter:

```yaml
version: 2
ethernets:
  enp1s0:
    addresses:
      - 192.168.122.50/24
    gateway4: 192.168.122.1
    nameservers:
      addresses:
        - 192.168.122.1
```

Cloud-init applies both on first boot: <span id="assignment.57.2" lang="nolang" no><b class="highlightcopy">the-engine-01</b></span> will come online at `192.168.122.50` with zero post-deployment manual setup.

> [!NOTE]
> This is **cloud-init**, the same industry-standard mechanism used by every major public cloud.
> In a real-case scenario there would be more complete automation and dedicated templates for this server's purpose.


Now we have finished the configuration please click <span id="assignment.19.3" lang="nolang" no>**Create**</span> to initialize the deployment of the Virtual Machine.

Don't wait for it to finish booting, please proceed to the next task.
</span>

<div id="304" class="story">
<span id="assignment.58" lang="en" hist="vertrex-bank">
Scheduling rules let you separate critical systems from other workloads, for example, pinning the trading engines to low-latency nodes while batch jobs share the rest. Keeping "any available node" here matters: it is what makes the zero-downtime evacuation in the next chapter possible.
</span>

</div>

<span id="assignment.59" lang="en" hist="vertrex-bank">
> [!NOTE]
> **When microseconds are money:** the high-frequency trading desk will demand more than placement rules and dedicated hardware. <b class="virt"><span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span></b> can **pin dedicated CPU cores** to a VM, pass hardware straight through, virtualize hardware using **SR-IOV** (for both NICs and GPUs), and slice datacenter GPUs into hardware-isolated **MIG partitions** so several VMs share one GPU with no noisy neighbors. Dedicating physical resources to a VM buys **predictable, consistent latency**. This exercise is just for educational purposes and not a recommendation for how to setup a high-frequency trading application.</span>

<span id="assignment.60" lang="en" no>
> [!IMPORTANT]
> Since this lab runs on a **nested configuration**, I/O performance is a bit slower than usual, and the provisioning process will take a few minutes. While your VM spins up, we have some entertainment lined up for you! Head over to Bonus Drills to learn how to interact with the <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> API using the CLI. Everything in <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> is a <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> object, which means you can manage it via the <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> API through the underlying RKE2 cluster.
> Once you're done, jump back into Task 3.

🖥️ Task 3: Access the Web Console
=================================

Monitor the </span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.61" lang="en" no> until the virtual machine transitions to the **Running** state.

<div style='align: middle; margin: 15px;'>
  <img class="animatedgif" src="../assets/chapter3-vm-vnc.gif"/>
</div>


1. Click the <span id="assignment.61.1" lang="nolang" no>**Console**</span> button on the virtual machine row to open the VNC web console
2. Observe we can access the system without a connection by using this method, **don't wait for the installation to finish just move on to the next**.
3. Close the console window



🏋️ Bonus Drills: see through the abstraction (optional, for the command-line curious)
========================================================================================

New to <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Skip ahead freely.** Otherwise, back in the </span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.62" lang="en" no>, look at what the platform actually created for you:

- **The golden images are API objects too:**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachineimages -A
```

- **The VM is a <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> resource:**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachines -n prod
```

- **The running instance, with its node and IP** (the same IP you used for SSH):

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get vmi -n prod -o wide
```

- **The disks are ordinary <span id="assignment.62.1" lang="nolang" no>PersistentVolumeClaims</span> backed by <span id="assignment.2.8" lang="nolang" no>Longhorn</span>:**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get pvc -n prod
```

You should recognize `market-data-vol` in the list: <span id="assignment.62.2" lang="en" hist="vertrex-bank">a banking data drive, expressed as cloud-native storage</span>.

💼 Why does this matter?
========================

- **Days become minutes.** A ticket-driven, multi-team provisioning process collapsed into a two-minute self-service workflow, <span id="assignment.62.3" lang="en" hist="vertrex-bank">during a live market crisis.</span>
- **Consistency by construction.** Golden images plus cloud-init mean every engine the quants request boots identical, configured, and ready.
- **No stranded storage.** <span id="assignment.6.4" lang="nolang" no>Volumes</span> are carved from the shared <span id="assignment.2.8" lang="nolang" no>Longhorn</span> pool on demand.
</span>

<div id="305" class="story">

<span id="assignment.63" lang="en" hist="vertrex-bank">
You radio back to the trading floor. *"Your engine is online and the data volume is attached."* The crisis is averted — but the day is far from over.
</span>

</div>

<span id="assignment.64" lang="en" no>
Click <span id="assignment.32.1" lang="nolang" no>**Check**</span> to continue. 🌊

📚 More information
===================
</span>

- [Creating <span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)
- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)

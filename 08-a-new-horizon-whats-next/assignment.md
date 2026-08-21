---
slug: a-new-horizon-whats-next
id: qzmycpm7jtwa
type: challenge
title: "<span id="assignment.158" lang="en" no>🌅 Chapter 8: A New Horizon</span>"
teaser: <span id="assignment.159" lang="en" hist="sky-telco">The network runs entirely on <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>.
  Take a victory lap, review everything you mastered, and chart where your new skills
  can take your own datacenter.</span>
tabs:
- id: jw4tji5y1jbv
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: gjstzqppnxay
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: ohjx4w0pk1mb
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: basic
timelimit: 1800
enhanced_loading: null
---
<span id="assignment.160" lang="en" no>🌅 Chapter 8: A New Horizon
============================</span>
<style type="text/css">
  * {
    font-family: suse;
    src: url('https://fonts.google.com/specimen/SUSE');
  }
  .suse { color: #30ba78; }
  .virt { color: #30ba78; }
  .bank { color: #d4af37; }
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


</style>

<img class="logos" alt="Welcome!" src="../assets/chapter-img-a_new_horizon.png"/>

<div id="901" class="story">

<span id="assignment.161" lang="en" hist="sky-telco">The static has finally cleared. The network operations center is quiet, bathed in the soft green glow of the <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> nodes humming along in perfect sync.

NorthStar Telecom is no longer chained to a rack of groaning, decade-old switches. It now runs entirely on a lean, high-performance, cloud-native virtualization stack.

Sarah stands beside you, eyes fixed on the unified dashboard filling the main screen. *"I honestly didn't think we'd pull this off,"* she admits, shaking her head in disbelief. *"We've got containerized microservices and our ancient billing mainframe running on the exact same fabric. Storage is distributed, networks are software-defined, and our vendor licensing bill just fell off a cliff."*

She turns to you and extends her hand. *"Thank you. You didn't just save our infrastructure — you saved the network."*</span>

</div>

<span id="assignment.162" lang="en" no>## 🏆 Your Deeds

You conquered incredible odds during your time here:

| Chapter | Crisis | Skill you mastered |
|:--------|:-------|:-------------------|
| 📡 The Arrival | A drowning legacy datacenter | Inspecting the platform dashboard, <span id="assignment.2.8" lang="nolang" no>Longhorn</span> storage, and Rancher Prime |
| 🛗 The Subterranean Divide | Two warring hardware silos | Uniting VMs and containers on one <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> fabric |
| ⚡ The Flash Crash | A viral livestream that melted the network | Deploying VMs in minutes with images, volumes, and cloud-init |
| 🌊 The Rising Tide | A flooded central office | Zero-downtime live migration and one-click node evacuation |
| 🕵️ The Invisible Intruder | A lateral attack path | Software-defined VLANs and isolated SDN subnets |
| ⏪ The Unthinkable Error | A deleted subscriber billing database | Snapshots, staging clones, storage tiers, and scheduled off-cluster backups |
| 🤠 The Stampede | A capacity famine before a roaming surge | Golden VM templates, stamping out identical fleets on demand |</span>


<div id="902" class="story">

<span id="assignment.163" lang="en" hist="sky-telco">Your work at NorthStar Telecom is complete — but the digital frontier is vast and constantly evolving. There are always new networks to design and new systems to modernize.</span>

</div>


<span id="assignment.164" lang="en" no>🔐 Login Credentials
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



<span id="assignment.165" lang="en" no>🧭 Victory lap: the lab is still yours
=======================================

The lab environment will remain active until your timer expires. Feel free to dig into the dashboard and experiment with the infrastructure you have built. Some ideas:

- **Take a final inventory of the empire you built.** Tour the</span>[button label="SUSE Virtualization UI" variant="success"](tab-0)<span id="assignment.166" lang="en" no>: the <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span> page, the **Networks** you defined, the **Templates** blueprint, and the **Backup & Snapshot** history: every crisis of the week left its mark here.

- **Design your own crisis.** Create a new VM from scratch: pick the image, size it, cloud-init it, snapshot it, live-migrate it. No instructions this time. You know the way.

- **For the command-line curious (optional):** the API is yours:

```bash,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get vm -A && kubectl  --kubeconfig .rodeo/harvester-kubeconfig get network-attachment-definitions -A && kubectl --kubeconfig .rodeo/harvester-kubeconfig get VirtualMachineBackup -A
```</span>


<span id="assignment.167" lang="en" no>🚀 What's next on your horizon?
===============================

- 📖 Keep your skills sharp by digging into the deep technical architecture in the [SUSE Virtualization Documentation](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html).

- 🐮 Learn how to manage **fleets of these clusters at scale** (one Rancher Prime managing every <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> cluster in every regional central office) with [<span id="assignment.2.15" lang="nolang" no>SUSE Rancher Prime</span>](https://documentation.suse.com/cloudnative/rancher-manager/latest/en/rancher-manager.html).

- 🧪 Rebuild this at home: <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> is open source. Grab the ISO, install it on any spare x86 box, and run your own VMs.

- 🤝 You are never alone on this trail: SUSE customers consistently rate <span id="assignment.167.1" lang="nolang" no>**SUSE Support**</span> among the best in the industry, and customer feedback directly shapes how the products evolve. Working with SUSE means a seat at the table, not a ticket in a queue. That is the open-source difference.

- 💬 Talk to your SUSE representative about what this story would look like with **your** legacy cluster in the darkest corner of the room.</span>

<div id="903" class="story">

<span id="assignment.168" lang="en" hist="sky-telco">It has been an absolute honor working alongside you!

**Happy migrating!** 🎉</span>

</div>

<span id="assignment.169" lang="en" no>📚 More information
===================

- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Creating <span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)
- [Live Migration](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/live-migration.html)
- [Backup and Restore](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/backup-restore.html)
- [Cluster Networking](https://documentation.suse.com/cloudnative/virtualization/latest/en/networking/cluster-network.html)</span>

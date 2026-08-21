---
slug: the-invisible-intruder-networking
id: 6y9uhwn9zyll
type: challenge
title: "<span id="assignment.100" lang="en" hist="sky-telco">📡 Chapter 5: The Invisible Intruder</span>"
teaser: <span id="assignment.101" lang="en" hist="sky-telco">A 2 AM security alert. The public web server shares a flat network with the
  telco's most sensitive subscriber database. Build a software-defined vault and lock the database
  inside.</span>
tabs:
- id: 69jpoti7gjds
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: hssojxkhutjx
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: pg01vcvbyns3
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: intermediate
timelimit: 3000
enhanced_loading: null
---
<span id="assignment.102" lang="en" hist="sky-telco">📡 Chapter 5: The Invisible Intruder
=====================================</span>

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

<img class="logos" alt="Welcome!" src="../assets/05-chapter-img.png"/>

<div id="501" class="story">

<span id="assignment.103" lang="en" hist="sky-telco">It is now two in the morning. The Network Operations Center is quiet, save for the rhythmic humming of the cooling fans. You are drinking stale coffee and reviewing the daily telemetry logs when your screen flashes red. A critical, high-priority alert from the Security Operations Center overrides your dashboard.

An automated vulnerability scan has detected a severe architectural flaw: the telco's public-facing customer self-care **web server** is sitting on the exact same flat network layer as the highly classified subscriber-fraud-db virtual machine.

If a threat actor were to compromise the public website, they would have a direct, unimpeded lateral path straight into the carrier's most sensitive internal database — the one holding call detail records, billing data, and SIM-swap fraud flags for every subscriber on the network. In a traditional infrastructure, fixing this would require waking up the senior network engineering team, physically re-cabling switch ports in the dark, and risking a routing loop that could take down voice service for half the city.

You don't need physical cables. You have the power of **software-defined networking** at your fingertips. You must construct an impenetrable digital vault and lock the database inside it — before an intrusion can occur.</span>

</div>

<span id="assignment.104" lang="en" no>## Two layers of software-defined networking

<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> gives you the full spectrum, from classic VLAN segmentation to enterprise SDN, capabilities the telco used to pay a separate closed-source SDN license for:

| Layer | Technology | Use tonight |
|-------|-----------|-------------|
| L2 / VLAN bridging | **<span id="assignment.2.14" lang="nolang" no>Multus</span>** | The vault VLAN isolating the database |
| SDN / isolated overlay zones | **<span id="assignment.2.13" lang="nolang" no>Kube-OVN</span>** | Private subnets with no external path, even overlapping CIDRs |



## 🎯 Your Quest Objectives

1. Connect a closed-loop physical network for production
2. Build an equally isolated SDN for development
3. Learn how to move VMs into the new networks



🔐 Login Credentials
====================

The <span id="assignment.69.1" lang="nolang" no>**SUSE Virtualization**</span> UI and <span id="assignment.2.12" lang="nolang" no>**Rancher Prime**</span> UI use the same credentials.</span>

<span id="assignment.10" lang="nolang" no>Username</span>:

<div class="cred">

```txt
admin
```

</div>

<span id="assignment.105" lang="nolang" no>*Password</span>:

<div class="cred">

```txt
[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="kvm-host" ]]
```

</div>



<span id="assignment.106" lang="en" no>🧱 Task 1: Connect a closed loop physical network
=================================================

Our team has set up the <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> nodes with an extra dedicated NIC that is connected in a physically closed loop. Let's use it for our most precious traffic — billing and fraud-detection — and create an isolated production network.

In the</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.107" lang="en" no>, navigate to <span id="assignment.107.1" lang="nolang" no>**Networks**</span> in the left menu, then select <span id="assignment.107.2" lang="nolang" no>**Cluster Network Configuration**</span>:

1. Click <span id="assignment.107.3" lang="nolang" no>**Create a Cluster Network**</span>
2. Set the <span id="assignment.19.4" lang="nolang" no>**Name**</span> to:</span>

<div class="cred">

```txt
closed-loop
```

</div>

<span id="assignment.108" lang="en" no>3. Click <span id="assignment.19.3" lang="nolang" no>**Create**</span>

The new cluster network appears in the list. Now assign it a physical interface: click <span id="assignment.108.1" lang="nolang" no>**Create Network Configuration**</span> on the same row as the closed-loop cluster network, then fill in the following details:

1. Set the <span id="assignment.19.4" lang="nolang" no>**Name**</span> to:</span>

<div class="cred">

```txt
closed-loop
```

</div>

<span id="assignment.109" lang="en" no>Notice the <span id="assignment.27" lang="nolang" no>**Node Selector**</span> section, in here we can specify where the network will be available.

2. Under <span id="assignment.109.1" lang="nolang" no>**Uplink**</span>, set <span id="assignment.109.2" lang="nolang" no>**NICs**</span> to ens5

3. Click <span id="assignment.19.3" lang="nolang" no>**Create**</span>



  


Now define the VM-facing network on top of it. Select <span id="assignment.109.3" lang="nolang" no>**Virtual Machine Networks**</span> and click <span id="assignment.19.3" lang="nolang" no>**Create**</span> to define a new secure perimeter:

- <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: prod
- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>

<div class="cred">

```txt
secure-loop-prod
```

</div>

<span id="assignment.110" lang="en" no>- <span id="assignment.110.1" lang="nolang" no>Basics</span>:
  - <span id="assignment.110.2" lang="nolang" no>**Type**</span>: UntaggedNetwork
  - <span id="assignment.110.3" lang="nolang" no>**Cluster Network**</span>: closed-loop

Click <span id="assignment.19.3" lang="nolang" no>**Create**</span>.


  


Back in the <span id="assignment.109.3" lang="nolang" no>**Virtual Machine Networks**</span> list, secure-loop-prod appears with <span id="assignment.110.4" lang="nolang" no>**Active**</span> status.



🔒 Task 2: Create a closed loop SDN
===================================

Now create the same type of isolation for the development environment. <span id="assignment.110.5" lang="en" hist="sky-telco">Running new fiber and NICs to every rack is expensive, and a development environment doesn't need that kind of dedicated hardware, so this time you will use a **software-defined network**.</span>


  


Go to <span id="assignment.110.6" lang="nolang" no>**Networks > Virtual Machine Networks**</span> and click <span id="assignment.19.3" lang="nolang" no>**Create**</span>, then fill in the following details:

- <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: prod
- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>

<div class="cred">

```txt
secure-loop-dev
```

</div>

<span id="assignment.111" lang="en" no>- <span id="assignment.110.1" lang="nolang" no>Basics</span>:
  - <span id="assignment.110.2" lang="nolang" no>**Type**</span>: OverlayNetwork

Click <span id="assignment.19.3" lang="nolang" no>**Create**</span>.


  


Now create the SDN subnet. Go to <span id="assignment.111.1" lang="nolang" no>**Virtual Private Cloud**</span>, and on the tab of the ovn-cluster Virtual Private Cloud click <span id="assignment.111.2" lang="nolang" no>**Create Subnet**</span>, then fill in the following details:

- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>

<div class="cred">

```txt
secure-vpc-dev
```

</div>

<span id="assignment.112" lang="en" no>- <span id="assignment.112.1" lang="nolang" no>Basic</span>:
  - <span id="assignment.112.2" lang="nolang" no>**CIDR**</span>:</span>

<div class="cred">

```txt
192.168.32.0/24
```

</div>

<span id="assignment.113" lang="en" no>- <span id="assignment.113.1" lang="nolang" no>**Provider**</span>: prod/secure-loop-dev
  - <span id="assignment.113.2" lang="nolang" no>**Gateway IP**</span>:</span>

<div class="cred">

```txt
192.168.32.1
```

</div>

<span id="assignment.114" lang="en" no>- <span id="assignment.114.1" lang="nolang" no>**Dynamic Host Configuration Protocol (DHCP)**</span>: <span id="assignment.114.2" lang="nolang" no><b class="highlightcopy">Enabled</b></span>
  - <span id="assignment.114.3" lang="nolang" no>**Private Subnet**</span>: <span id="assignment.114.2" lang="nolang" no><b class="highlightcopy">Enabled</b></span>

Click <span id="assignment.19.3" lang="nolang" no>**Create**</span>.

Now you can assign the network prod/secure-loop-dev to any VM, and it will only be able to communicate with the VMs on the same network.


If you are curious to see the topology on the tab of the ovn-cluster Virtual Private Cloud click <span id="assignment.114.4" lang="nolang" no>**Topology**</span>, this is specially useful when having multiple subnets,


🎯 Task 3: Configure VMs with the new networks
=====================================================


You have two new isolated networks. Now it is time to show your peers how to attach them to a VM.


  


<span id="assignment.114.5" lang="en" hist="sky-telco">You are not making the change yourself, just walking through how it is done, for that we will choose the customer portal production server:</span>

Return to the <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span> dashboard and locate the target virtual machine ( **custportal-prod** ):

1. Click the  on its row and select <span id="assignment.114.6" lang="nolang" no>**Edit Config**</span>
2. Go to the <span id="assignment.107.1" lang="nolang" no>**Networks**</span> tab
3. Select the network prod/secure-loop-prod for production systems, or prod/secure-loop-dev for development systems
4. Click <span id="assignment.114.7" lang="nolang" no>**Save**</span>
5. Click the  again and select <span id="assignment.114.8" lang="nolang" no>**Restart**</span>

The VM boots connected to the new network. Don't wait for it to finish.



> [!IMPORTANT]
> For most cases if a VM is currently running, you must **stop it first** to activate the hardware modification.



🏋️ Bonus Drills: for the command-line curious (optional)
==========================================================

New to <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Skip ahead freely**: we have the isolated networks already created. These optional drills add an extra isolated network with pure <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> tooling.

**An extra isolated network is needed for QA: <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> network policies.** We need to be able to replicate this setup in QA to make sure there are no surprises when we roll this out network-wide, apply a strict policy that drops unauthorized traffic at the pod level, underneath the VLAN isolation. In the</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.115" lang="en" no>, apply a default deny-all ingress policy to the secure namespace:

```bash,run
cat << EOF | kubectl --kubeconfig .rodeo/harvester-kubeconfig apply -f -
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: default-deny-all
  namespace: prod
spec:
  podSelector: {}
  policyTypes:
    - Ingress
EOF
```

Confirm the policy is enforced:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get networkpolicy -n prod
```


Create a completely independent zone for the forensics team:

```bash,run
cat << EOF | kubectl --kubeconfig .rodeo/harvester-kubeconfig apply -f -
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  name: forensics-zone
  namespace: prod
  labels:
    network.harvesterhci.io/clusternetwork: secure-loop-prod
    network.harvesterhci.io/type: OverlayNetwork
spec:
  config: '{"cniVersion":"0.3.1","name":"forensics-zone","type":"kube-ovn","provider":"forensics-zone.prod.ovn","server_socket":"/run/openvswitch/kube-ovn-daemon.sock"}'
EOF
```

```bash,run
cat << EOF | kubectl --kubeconfig .rodeo/harvester-kubeconfig apply -f -
apiVersion: kubeovn.io/v1
kind: Subnet
metadata:
  name: forensics-zone
spec:
  cidrBlock: "172.16.1.0/24"
  gateway: "172.16.1.1"
  excludeIps:
    - "172.16.1.1"
  protocol: IPv4
  natOutgoing: false
  private: true
  provider: forensics-zone.prod.ovn
  vpc: ovn-cluster
EOF
```

> [!NOTE]
> Each zone gets its own dedicated network (and therefore its own isolated logical switch), which is what makes the isolation real. <span id="assignment.2.13" lang="nolang" no>Kube-OVN</span> still enforces one rule per VPC: no two subnets in the same VPC (`ovn-cluster`) may share a CIDR, even on different networks, which is why `forensics-zone` uses a different block. True overlapping address space between zones is possible too, it just requires a second custom VPC, out of scope for this drill.

Verify both zones exist with `natOutgoing: false`: no path out, no path in:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get subnets.kubeovn.io -o custom-columns=NAME:.metadata.name,CIDR:.spec.cidrBlock,PRIVATE:.spec.private,NAT:.spec.natOutgoing
```

Two vaults, two independent private networks, zero shared packets. A VM attached to either zone can talk to its neighbors in the same subnet and to **nothing else**: micro-segmentation without a proprietary SDN license, built and torn down entirely in software.

💼 Why does this matter?
==============================================

- **Segmentation at 2 AM, in software.** What used to be a re-cabling project with change-control meetings and a possible truck roll became three minutes of configuration, while the threat window was still closed.
- **Defense-in-depth by default.** VLAN isolation at layer 2, network policies at the pod layer, and private SDN subnets: three independent walls from one platform.
- **Compliance evidence built in.** Every network, policy, and subnet is a versionable YAML object: the telecom regulators and security auditors get proof, not promises.

Click <span id="assignment.32.1" lang="nolang" no>**Check**</span> to continue. ⏪

📚 More information
===================</span>

- [Cluster Networking](https://documentation.suse.com/cloudnative/virtualization/latest/en/networking/cluster-network.html)

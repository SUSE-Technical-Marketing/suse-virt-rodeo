---
slug: the-invisible-intruder-networking
id: 6y9uhwn9zyll
type: challenge
title: "\U0001F575️ Chapter 5 — The Invisible Intruder"
teaser: A 2 AM security alert — the public web server shares a flat network with the
  bank's most sensitive database. Build a software-defined vault and lock the database
  inside.
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

🕵️ Chapter 5 — The Invisible Intruder
=====================================

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

<img class="logos" alt="Welcome!" src="../assets/05-chapter-img.png"/>

<div class="storybox">

It is now two in the morning. The datacenter is quiet, save for the rhythmic humming of the cooling fans. You are drinking stale coffee and reviewing the daily telemetry logs when your screen flashes <span class="danger">red</span>. A critical, high-priority alert from the Security Operations Center overrides your dashboard.

An automated vulnerability scan has detected a severe architectural flaw: the bank's public-facing marketing **web server** is sitting on the exact same flat network layer as the highly classified <b class="highlightcopy">insider-threat-db</b> virtual machine.

If a threat actor were to compromise the public website, they would have a direct, unimpeded lateral path straight into the bank's most sensitive internal security database. In a traditional infrastructure, fixing this would require waking up the senior network engineering team, physically re-cabling switch ports in the dark, and risking catastrophic routing loops.

You don't need physical cables. You have the power of **software-defined networking** at your fingertips. You must construct an impenetrable digital vault and lock the database inside it — before an intrusion can occur.

</div>

## <b class="hovereffect">Two layers of software-defined networking</b>

<b class="virt">SUSE Virtualization</b> gives you the full spectrum, from classic VLAN segmentation to enterprise SDN — capabilities the bank used to pay a separate closed-source SDN license for:

| Layer | Technology | Use tonight |
|-------|-----------|-------------|
| L2 / VLAN bridging | **Multus** | The vault VLAN isolating the database |
| SDN / isolated overlay zones | **Kube-OVN** | Private subnets with no external path — even overlapping CIDRs |

<div class="missionbox">

## 🎯 Your Quest Objectives

1. Construct the virtual vault network
2. Isolate the database into the vault
3. Prove the lateral attack vector is severed

</div>

🔐 Login Credentials
====================

The **SUSE Virtualization** UI and **Rancher Prime** UI use the same credentials.

Username:
```txt
admin
```

Password:
```txt
[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="kvm-host" ]]
```



🧱 Task 1: Construct the virtual vault network
==============================================

In the [button label="SUSE Virtualization UI" variant="success"](tab-0), navigate to **Networks** in the left menu, then select **Virtual Machine Networks**. Click **Create** to define a new secure perimeter:

| Setting | Value |
|--------:|:------|
| **Name** | <b class="highlightcopy">secure-vault-vlan</b> |
| **Type** | `L2VlanNetwork` |
| **Cluster Network** | `mgmt` |
| **VLAN ID** | <b class="highlightcopy">100</b> |

Click **Create**.

<div style='align: middle; margin: 15px;'>
  <img class="animatedgif" src="../assets/02-create_vm_network.gif"/>
</div>

Back in the **Virtual Machine Networks** list, <b class="highlightcopy">secure-vault-vlan</b> appears with **VLAN ID 100** and an **Active** status — traffic on this network is tagged separately from the untagged `vmnet` you built earlier.

> [!NOTE]
> In a physical deployment, the upstream switch ports connected to the cluster nodes must have VLAN 100 trunked. In this lab the fabric is virtual, so the tag is honored end to end automatically.

🔒 Task 2: Isolate the database into the vault
==============================================

Return to the **Virtual Machines** dashboard. Locate and edit the <b class="highlightcopy">insider-threat-db</b> virtual machine.

> [!IMPORTANT]
> If it is currently running, you must **stop it first** to modify its hardware configuration.

1. Navigate to the **Networks** tab within the virtual machine configuration
2. **Remove** the default unsegmented network adapter
3. **Add** a new network interface and assign it explicitly to the <b class="highlightcopy">secure-vault-vlan</b> you just created
4. **Save** the configuration and power the virtual machine back on

The database now lives inside the vault. Anything outside VLAN 100 simply cannot see it at layer 2.

🎯 Task 3: Prove the lateral attack vector is severed
=====================================================

Trust nothing you have not tested. Retrieve the IP addresses for both the <b class="highlightcopy">web-frontend</b> and the <b class="highlightcopy">insider-threat-db</b> from the UI.

Simulate the attacker's position: log into the public perimeter by accessing the web server from your terminal (replace `WEB_FRONTEND_IP`):

```bash
ssh opensuse@WEB_FRONTEND_IP
```

From **inside** the web server, attempt to reach the internal database (replace `INSIDER_THREAT_DB_IP`):

```bash
ping INSIDER_THREAT_DB_IP
```

<div class="storybox">

The terminal hangs. The packets simply vanish into the void. The software-defined network boundary is holding firm. The database is **entirely invisible** to the outside world.

</div>

Press `Ctrl+C` to cancel the ping, and type `exit` to return to your Cluster Terminal. You finally allow yourself a sip of the cold coffee. ☕

🏋️ Bonus Drills — for the command-line curious (optional)
==========================================================

New to Kubernetes? **Skip ahead freely** — the vault is already sealed. These optional drills add extra walls with pure Kubernetes tooling.

**Drill 1 — a second wall: Kubernetes network policies.** One wall is good. Two walls are banking-grade. For **defense-in-depth**, apply a strict policy that drops unauthorized traffic at the pod level, underneath the VLAN isolation. In the [button label="Cluster Terminal" variant="success"](tab-1), apply a default deny-all ingress policy to the secure namespace:

```bash,run
cat << EOF | kubectl --kubeconfig .kube/harvester.yaml apply -f -
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: default-deny-all
  namespace: vertex-trust-prod
spec:
  podSelector: {}
  policyTypes:
    - Ingress
EOF
```

Confirm the policy is enforced:

```bash,run
kubectl --kubeconfig .kube/harvester.yaml get networkpolicy -n vertex-trust-prod
```

**Drill 2 — build air-gapped containment zones.** VLANs segment the physical network — but <b class="virt">SUSE Virtualization</b> also ships a full SDN layer (**Kube-OVN**) for overlay networks with private, non-NAT'ed subnets. Build a fully air-gapped zone for the bank's future forensics workloads:

```bash,run
cat << EOF | kubectl --kubeconfig .kube/harvester.yaml apply -f -
apiVersion: kubeovn.io/v1
kind: Subnet
metadata:
  name: vault-zone
spec:
  cidrBlock: "172.16.0.0/24"
  gateway: "172.16.0.1"
  excludeIps:
    - "172.16.0.1"
  protocol: IPv4
  natOutgoing: false
  private: true
EOF
```

Now prove the most counterintuitive capability of the SDN layer: **overlapping address space**. Create a second, completely independent zone for the forensics team — using the *exact same CIDR*:

```bash,run
cat << EOF | kubectl --kubeconfig .kube/harvester.yaml apply -f -
apiVersion: kubeovn.io/v1
kind: Subnet
metadata:
  name: forensics-zone
spec:
  cidrBlock: "172.16.0.0/24"
  gateway: "172.16.0.1"
  excludeIps:
    - "172.16.0.1"
  protocol: IPv4
  natOutgoing: false
  private: true
EOF
```

> [!NOTE]
> Kube-OVN handles overlapping CIDRs via VPC isolation. If the command returns a validation error about duplicate CIDRs, use `172.16.1.0/24` for `forensics-zone` instead — the isolation demonstration still holds, just with different addresses.

Verify both zones exist with `natOutgoing: false` — no path out, no path in:

```bash,run
kubectl --kubeconfig .kube/harvester.yaml get subnets.kubeovn.io -o custom-columns=NAME:.metadata.name,CIDR:.spec.cidrBlock,PRIVATE:.spec.private,NAT:.spec.natOutgoing
```

Two vaults, same IP space, zero shared packets. A VM attached to either zone can talk to its neighbors in the same subnet and to **nothing else** — micro-segmentation without a proprietary SDN license, and without ever running out of address space.

💼 Why does this matter for Vertex Trust Bank?
==============================================

- **Segmentation at 2 AM, in software.** What used to be a re-cabling project with change-control meetings became three minutes of configuration — while the threat window was still closed.
- **Defense-in-depth by default.** VLAN isolation at layer 2, network policies at the pod layer, and private SDN subnets — three independent walls from one platform.
- **Compliance evidence built in.** Every network, policy, and subnet is a versionable YAML object — the security auditors get proof, not promises.

Click **Check** to continue. ⏪

📚 More information
===================

- [Cluster Networking](https://documentation.suse.com/cloudnative/virtualization/latest/en/networking/cluster-network.html)

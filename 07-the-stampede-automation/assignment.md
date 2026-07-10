---
slug: the-stampede-automation
id: euwnv5ojhvfl
type: challenge
title: "\U0001F920 Chapter 7 — The Stampede"
teaser: The markets are in freefall and the quants need the calculation fleet scaled
  from three nodes to five — now. Treat your infrastructure as code with Terraform.
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

*"The three calculation engines are not enough anymore!"* the **Head of Quant** shouts across the room, waving a printed report. *"I need the cluster scaled up to <span class="danger">five nodes immediately</span>, or we fly blind into this market crash!"*

Clicking through a graphical user interface to provision machines is fine for a localized emergency. But to deploy and scale a massive, identical fleet of servers under immense time pressure requires a vastly different approach. Manual configuration invites human error — and right now, human error costs millions of dollars **per second**.

You pull up your terminal. It is time to treat **infrastructure as code**.

</div>

Using **Terraform**, you previously defined the fleet architecture in a simple text file. Now, you will modify that code to dynamically scale the infrastructure out — the same declarative workflow the bank already uses for its cloud accounts, pointed at its own datacenter.

<div class="missionbox">

## 🎯 Your Quest Objectives

1. Inspect the initial infrastructure code
2. Deploy the initial fleet
3. Modify the code to scale the cluster
4. Apply the infrastructure changes
5. Clean up the environment

</div>

📜 Task 1: Inspect the initial infrastructure code
==================================================

In the [button label="Cluster Terminal" variant="success"](tab-1), examine the pre-written Terraform blueprint:

```bash,run
cat main.tf
```

Review the code on the screen. Notice the key elements:

- the **provider** block pointing at the <b class="virt">SUSE Virtualization</b> API (it speaks Kubernetes, so it authenticates with the same kubeconfig you have been using)
- the **resource** definition for the stress-test VMs
- the <b class="highlightcopy">count = 3</b> variable — the single number that defines the fleet size

Initialize the Terraform provider to download the necessary <b class="virt">SUSE Virtualization</b> API plugins:

```bash,run
terraform init
```

🏭 Task 2: Deploy the initial fleet
===================================

Unleash the deployment command to forge the initial servers from code:

```bash,run
terraform apply -auto-approve
```

Switch to the [button label="SUSE Virtualization UI" variant="success"](tab-0) and navigate to **Virtual Machines**. Watch as <b class="highlightcopy">stress-test-node-1</b>, <b class="highlightcopy">stress-test-node-2</b>, and <b class="highlightcopy">stress-test-node-3</b> materialize.

Three identical engines, born from one text file. No tickets. No checklists. No slipped cursors.

📈 Task 3: Modify the code to scale the cluster
===============================================

The Head of Quant needs **five** nodes, not three. Back in the [button label="Cluster Terminal" variant="success"](tab-1), edit the Terraform file to increase the replica count. This command automatically replaces the count variable in the file from 3 to 5:

```bash,run
sed -i 's/count = 3/count = 5/g' main.tf
```

Confirm the change landed:

```bash,run
grep count main.tf
```

That one-line diff **is** the scaling operation. In a real engagement this edit would be a reviewed pull request — the infrastructure change gets the same code review as any application change.

🚀 Task 4: Apply the infrastructure changes
===========================================

Execute a dry-run to see what Terraform plans to do. It should detect the change and plan to **add two new machines without destroying the existing three**:

```bash,run
terraform plan
```

Read the plan summary: `2 to add, 0 to change, 0 to destroy`. This is the safety net manual provisioning never had. Now apply the scaling operation:

```bash,run
terraform apply -auto-approve
```

Switch back to the [button label="SUSE Virtualization UI" variant="success"](tab-0). Watch as <b class="highlightcopy">stress-test-node-4</b> and <b class="highlightcopy">stress-test-node-5</b> dynamically boot up and join the fleet in perfect synchronization.

<div class="storybox">

The risk analysis team begins feeding data into the expanded cluster, stabilizing the bank's market position just in time.

</div>

🏋️ Bonus Drills — trust, but verify (with the API)
===================================================

- **Count the fleet from the command line** — the UI, Terraform state, and the Kubernetes API must all agree:

```bash,run
kubectl get vm -A | grep stress-test
```

- **Inspect Terraform's view of reality:**

```bash,run
terraform state list
```

- **Templating without Terraform:** <b class="virt">SUSE Virtualization</b> also has built-in **VM Templates** for teams that prefer the UI. Explore **Advanced > Templates** in the UI, then list them via the API:

```bash,run
kubectl get virtualmachinetemplates -A
```

  A template captures CPU, memory, disks, networks, and cloud-init in a reusable, versioned object — golden configurations for the next flash crash.

🧹 Task 5: Clean up the environment
===================================

Once the market surge subsides, clean up the environment to save resources:

```bash,run
terraform destroy -auto-approve
```

Verify the stress-test fleet is gone:

```bash,run
kubectl get vm -A | grep stress-test || echo "Fleet decommissioned. Resources returned to the pool."
```

Five machines summoned, used, and returned — and the only artifact left behind is a text file in version control that describes exactly what happened.

💼 Why does this matter for Vertex Trust Bank?
==============================================

- **Elasticity on owned hardware.** Cloud-style scale-out (and scale-in) on the bank's own datacenter — no data residency questions, no egress bills.
- **Human error is engineered out.** Fleets are defined in reviewable code; `terraform plan` shows the blast radius *before* anything changes.
- **Full lifecycle economics.** Decommissioning is one command, so temporary capacity never becomes permanent cost — the exact opposite of the old hypervisor sprawl.

Click **Check** to continue. ⚔️

📚 More information
===================

- [SUSE Virtualization — Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Creating Virtual Machines](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)

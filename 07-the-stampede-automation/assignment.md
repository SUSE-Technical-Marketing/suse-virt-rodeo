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
</style>

<img class="logos" alt="Welcome!" src="../assets/07-chapter-img.png"/>

<div id="701" class="story">

A sudden, aggressive shift in global interest rates sends the financial markets into a chaotic frenzy. <b class="bank">Vertex Trust Bank</b>'s risk analysis algorithms are screaming for more compute capacity to process the incoming flood of volatile market data.

*"One calculation engine is not enough anymore!"* the **Head of Quant** shouts across the room, waving a printed report. *"I need a fleet of <span class="danger">five identical engines immediately</span>, or we fly blind into this market crash!"*

Building five machines by hand, one screen at a time, invites exactly what you cannot afford right now: a mistyped memory size here, a forgotten network there. Configuration drift under pressure — and right now, human error costs millions of dollars **per second**.

You crack your knuckles. What the bank needs is a **golden blueprint**: define the perfect machine once, then stamp out identical copies on demand.

</div>

<b class="virt">SUSE Virtualization</b> has exactly that: **VM Templates**. A template captures CPU, memory, disks, networks, and cloud-init in a single versioned object. Combined with **multi-instance creation**, one blueprint becomes an entire fleet in a single click.

<div class="missionbox">

## 🎯 Your Quest Objectives

1. Forge the golden template
2. Recreate the template from the command line
3. Scale the fleet under pressure
4. Stand the fleet down

</div>

🔐 Login Credentials
====================

The **SUSE Virtualization** UI and **Rancher Prime** UI use the same credentials.

Username:

<div class="cred">

```txt
admin
```

</div>

Password:

<div class="cred">

```txt
[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="kvm-host" ]]
```

</div>



📜 Task 1: Forge the golden template
====================================



You need a template that speeds up the deployment of virtual machines and standardizes them. Navigate to **Advanced > Templates** and click **Create**, then fill in the following details:

- **Namespace**: <b class="highlightcopy">prod</b>
- **Template Name**: <b class="highlightcopy">prod-basic</b>

We need to minimize resource usage, and all the VMs should be reachable using the production SSH key, which is securely guarded.

- Basics:
  - **CPU**: <b class="highlightcopy">1</b>
  - **Memory**: <b class="highlightcopy">1</b>
  - **SSHKey**: <b class="highlightcopy">prod/default</b>

Our default base OS is SLES 16.

- Volumes:
  - **Image**: <b class="highlightcopy">official-images/SLES-16.0-Minimal-VM.x86_64-Cloud-GM.qcow2</b>

We want production servers to offer their services on the production service network.

- Networks:
  - **Network**: <b class="highlightcopy">prod/service</b>

All production VMs should run only on production-ready hosts.

- Node Scheduling:
  1. Select **Run virtual machine on node(s) matching scheduling rules**
  2. Click **Add Node Selector**, then **Add Rule**:
     - **Key**: <b class="highlightcopy">stage</b>
     - **Value**: <b class="highlightcopy">prod</b>

We want the VMs to be properly labeled:

- Labels:
  - Click **Add Label**:
    - **Key**: <b class="highlightcopy">stage</b>
    - **Value**: <b class="highlightcopy">prod</b>

Finally, we want all production machines standardized on a set of packages and settings:

- Advanced Options:
  - **User Data Template**: <b class="highlightcopy">prod/prod</b>

To finalize, click **Create**.

Can you imagine filling in all these details every time? People would give up, and the environment would fill up with inconsistency — and inconsistency makes further automation even more difficult.


> [!NOTE]
> Templates are **versioned**. If you later edit the template, a new version is created while machines built from older versions keep their lineage — a full audit trail of what was deployed from which blueprint, which your regulators will appreciate.

🏭 Task 2: Recreate the template from the command line
=======================================================

As mentioned earlier, SUSE Virtualization runs on Kubernetes, and in Kubernetes *everything* is a defined resource. You may have noticed that many of the menus have an **Edit as YAML** button next to **Create** — what you see there is the YAML-formatted definition of the object you are creating with the UI, and it is exactly what you can pass to kubectl and other tools to automate the management of resources in the Kubernetes cluster: virtual machines, templates, and more.

Since everything can be defined in a text file, it is easy to keep track of changes and to automate operations — no need to click-click every time. For certain tasks the UI does make things much simpler (Virtual Machine Templates are one of them), but let's see how to create the very same template from the command line.

First delete the template you just created. Go to **Advanced > Templates**, and on the row showing <b class="highlightcopy">prod/prod-basic</b> click the **three dots** and select **Delete**.

Now let's recreate it.

For clarity, first create a file with the resource definition formatted in YAML — run the following command in the [button label="Cluster Terminal" variant="success"](tab-1):


```bash,run
cat > virtualMachineTemplate_prod-basic.yaml <<'EOF'
---
apiVersion: harvesterhci.io/v1beta1
kind: VirtualMachineTemplate
metadata:
  name: prod-basic
  namespace: prod
---

apiVersion: harvesterhci.io/v1beta1
kind: VirtualMachineTemplateVersion
metadata:
  labels:
    stage: prod
  name: prod-basic
  namespace: prod
spec:
  templateId: prod/prod-basic
  vm:
    metadata:
      annotations:
        harvesterhci.io/volumeClaimTemplates: '[{"metadata":{"name":"-disk-0-thsxi","annotations":{"harvesterhci.io/imageId":"official-images/image-v62vf"}},"spec":{"accessModes":["ReadWriteMany"],"resources":{"requests":{"storage":"10Gi"}},"volumeMode":"Block","storageClassName":"lh-3311febd-12d9-4ebc-82bc-728e5ccbfbe6"}}]'
      labels:
        harvesterhci.io/os: linux
        stage: prod
    spec:
      runStrategy: RerunOnFailure
      template:
        metadata:
          annotations:
            harvesterhci.io/sshNames: '["prod/default"]'
        spec:
          affinity:
            nodeAffinity:
              requiredDuringSchedulingIgnoredDuringExecution:
                nodeSelectorTerms:
                - matchExpressions:
                  - key: stage
                    operator: In
                    values:
                    - prod
          domain:
            cpu:
              cores: 1
              sockets: 1
              threads: 1
            devices:
              disks:
              - bootOrder: 1
                disk:
                  bus: virtio
                name: disk-0
              - disk:
                  bus: virtio
                name: cloudinitdisk
              inputs:
              - bus: usb
                name: tablet
                type: tablet
              interfaces:
              - bridge: {}
                model: virtio
                name: default
            features:
              acpi:
                enabled: true
            machine:
              type: q35
            resources:
              limits:
                cpu: "1"
                memory: 1Gi
          evictionStrategy: LiveMigrateIfPossible
          networks:
          - multus:
              networkName: prod/service
            name: default
          terminationGracePeriodSeconds: 120
          volumes:
          - name: disk-0
            persistentVolumeClaim:
              claimName: -disk-0-thsxi
          - cloudInitNoCloud:
              networkDataSecretRef:
                name: prod-basic-xcezl
              secretRef:
                name: prod-basic-xcezl
            name: cloudinitdisk
EOF
```

This file could be stored in a Git repository to keep track of changes, and also to feed a CI/CD process that automatically applies changes made to it.

Now create the resource — run the following command:

```bash,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig apply -f virtualMachineTemplate_prod-basic.yaml
```

It creates the two resources needed to set up the template.

Navigate back to the **Templates** list and check that the template is there, with all the same details.



📈 Task 3: Scale the fleet under pressure
=========================================

Because the template already exists, deploying multiple servers takes just a few clicks.

Go to **Virtual Machines** and click **Create**, then fill in the following details:

1. Select **Multiple Instance**
2. Set the **Namespace** to <b class="highlightcopy">prod</b>
3. Set the **Name Prefix** to <b class="highlightcopy">appcluster</b>
4. Set the **Count** to <b class="highlightcopy">2</b>
5. Tick **Use VM Template** and set the **Template** to <b class="highlightcopy">prod/prod-basic</b>
6. Click **Create**


<div id="702" class="story">

The risk analysis team begins feeding data into the expanded fleet, stabilizing the bank's market position just in time.

</div>


🧹 Task 4: Stand the fleet down
===============================

<div id="703" class="story">

The market surge subsides. The virtual machines sit idle, waiting for the next wave — but will it come today? Tomorrow? Next month? For these noble servers, waiting is more painful than doing all the number crunching.

</div>

You no longer need so many virtual machines — delete them all at once (don't worry if they are still starting).

In the **Virtual Machines** section:

1. Tick the **checkboxes** next to all the new virtual machines you created
2. Click **Delete**, tick **Delete All**, and click **Delete**


<div id="704" class="story">

The suffering of these noble virtual machines has stopped. You see the flames, my child? Now they rest in Valhalla.

</div>




🏋️ Bonus Drills — for the command-line curious (optional)
==========================================================

New to Kubernetes? **Skip ahead freely.** Otherwise, prove in the [button label="Cluster Terminal" variant="success"](tab-1) that the UI, the fleet, and the API all agree:

- **Inspect the template as an API object** — templates and their versions are resources too:

```bash,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplates,virtualmachinetemplateversions -n prod
```

- **Retrieve the template definition in yaml format**:

```bash,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplates -n prod prod-basic -o yaml > template_prod-basic.yaml
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplateversions -n prod prod-basic -o yaml >> template_prod-basic.yaml
```

You can examine the file `template_prod-basic.yaml` — it contains a definition similar to the one you used to create the template in Task 2.



💼 Why does this matter?
==============================================

- **Elasticity on owned hardware.** Cloud-style scale-out (and scale-in) on the bank's own datacenter — no data residency questions, no egress bills.
- **Human error is engineered out.** Machines come from a versioned golden blueprint, not from memory and muscle — configuration drift cannot happen at 2 AM.
- **Full lifecycle economics.** Decommissioning is a checkbox and a click, so temporary capacity never becomes permanent cost — the exact opposite of the old hypervisor sprawl.

Click **Check** to continue. ⚔️

📚 More information
===================

- [SUSE Virtualization — Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Creating Virtual Machines](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)

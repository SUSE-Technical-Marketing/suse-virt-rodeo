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



📜 Task 1: Forge the golden template
====================================



We need to create a template to speed up the deployment of Virtual Machines and standardize, we are going to navigate to **Advanced > Templates** and click **Create**.

Please fill in the following details:

- Namespace: harvester-public
- Template Name: prod-basic

We need to minimize resource usage and all the VMs should be available by using the production SSH Key which is securely guarded.

- Basics:
  - CPU: '1'
  - Memory: '1'
  - SSHKey: 'prod/default'

Our default base OS is SLES 16

- Volumes:
  - Image: 'official-images/SLES-16.0-Minimal-VM.x86_64-Cloud-GM.qcow2'

We want production servers to be offering their services on the production service network.

- Networks:
  - Network: 'prod/service'

All production VMs should run only on production ready hosts

- Node Scheduling:
  - Run virtual machine on node(s) matching scheduling rules
    - Click on 'Add Node Selector' --> click on 'Add Rule'
      - Key: stage
      - Value: prod

We want the VMs to be properly labeled:

- Labels:
  - Click 'Add Label'
    - Key: 'stage'
    - Value: 'prod'

Finally, we want all production machines to be standardized on a set of packages and settings

- Advanced Options:
  - User Data Template: 'prod/prod'

To finalize just click on 'Create'

Can you imagine filling up all this details everytime? People would give up and then the environment will be filled up with inconsistency. Inconsistency makes further automation even more difficult.


> [!NOTE]
> Templates are **versioned**. If you later edit the template, a new version is created while machines built from older versions keep their lineage — a full audit trail of what was deployed from which blueprint, which your regulators will appreciate.

🏭 Task 2: Doing the same but without mouse
===========================================

As we mentioned earlier SUSE Virtualization runs on Kubernetes, in Kubernetes *everything* is a defined resource, you may have noticed already many of the menus have an 'Edit as YAML' bottom next to 'Create', what you see there is the YAML formatted definition of the object you are creating with the UI and is what we can pass to kubectl and other tools to automate the management of different resources in the Kubernetes cluster, this includes Virtual machines, templates, etc...


Since everything can be defined with a text file it is easy to keep track of changes and to automate operations, no need to click-click everytime although for certain tasks the UI makes them much simpler, this is the case of the Virtual Machine Templates, but we are going to see an example of how to create the same template we created from the command line.

Let's first delete the template we created. Go to 'Advanced' --> 'Templates', and on the first line where you see 'prod/prod-basic' click on the ... and select 'Delete'.


Now lets recreate it again.


For clarity we are going to first create a file with the resource definition formatted in YAML, run the following command on the [button label="Cluster Terminal" variant="success"](tab-1)


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

This could be stored in a GIT repository to keep track of changes and also to incorporate it into a CI/CD process to automatically apply changes made to it.


Now on the next step we are going to create the resource, run the following command:

```bash,run
kubectl  --kubeconfig .kube/harvester.yaml apply -f virtualMachineTemplate_prod-basic.yaml
```

It should have created the two resources needed to setup the template.


Navigate again to the Templates list and see if it's there and has all the same details.



📈 Task 3: Scale the fleet under pressure
=========================================

Now because the template already exists, deploying multiple servers is just a few clicks process:

Go to Virtual Machines and click **Create** and fill in the following details:

- Select **Multiple Instance**
- **Namespace**: 'prod'
- **Name Prefix**: <b class="highlightcopy">appcluster</b>
- **Count**: <b class="highlightcopy">2</b>
- Tick **Use VM Template**
- **Template**: <b class="highlightcopy">prod/prod-basic</b>
- click on 'Create'


<div class="storybox">

The risk analysis team begins feeding data into the expanded fleet, stabilizing the bank's market position just in time.

</div>


🧹 Task 4: Stand the fleet down
===============================

<div class="storybox">

The market surge subsides, the virtual machines sit idle waiting for the next wave, but, will it be today? tomorrow? next month? waiting is more painful for this noble servers than doing all the number crunching

</div>

We no longer need so many virtual machines, let's delete them at once, don't worry if they are still starting..

Inside the 'Virtual Machines' section:

1. Tick the **checkboxes** next to all the new virtual machines we have created.
2. Click **Delete**, tick 'Delete All' and then click 'Delete'


<div class="storybox">

The suffering of this noble virtual machines has stopped, you see the flames my child? now they rest in valhala.

</div>




🏋️ Bonus Drills — for the command-line curious (optional)
==========================================================

New to Kubernetes? **Skip ahead freely.** Otherwise, prove in the [button label="Cluster Terminal" variant="success"](tab-1) that the UI, the fleet, and the API all agree:

- **Inspect the template as an API object** — templates and their versions are resources too:

```bash,run
kubectl --kubeconfig .kube/harvester.yaml get virtualmachinetemplates,virtualmachinetemplateversions -n prod
```

- **Retrieve the template definition in yaml format**:

```bash,run
kubectl --kubeconfig .kube/harvester.yaml get virtualmachinetemplates -n prod prod-basic > template_prod-basic.yaml
kubectl --kubeconfig .kube/harvester.yaml get virtualmachinetemplatesversions -n prod prod-basic >> template_prod-basic.yaml
```

You can examing the file 'template_prod-basic.yaml, it contains a similar output of what used to generate them in task 2.



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

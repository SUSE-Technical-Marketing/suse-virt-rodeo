---
slug: harvester-autopilot
id: ccntqk9znp4b
type: challenge
title: Suse Virtualization - Autopilot
teaser: Learn how to automatically expand virtual machine disks with Portworx Autopilot
tabs:
- id: 3fbqqpnza6db
  title: Terminal
  type: terminal
  hostname: cloud-client
  cmd: su - root
- id: fnypxaumaxqa
  title: Rancher UI
  type: service
  hostname: cloud-client
  path: /
  port: 91
- id: lantka2bfr6m
  title: Harvester UI
  type: service
  hostname: cloud-client
  path: /
  port: 90
difficulty: basic
timelimit: 28800
enhanced_loading: null
---
Editor's Notes
=====
This assignment should be written by Portworx.

In this lesson, we will be learning about Portworx Autopilot. Autopilot allows you to automatically expand virtual machine disks when they get full.

We have created a VM for you called `vm2`. We can access this VM though SSH using the `vm2` name. Try it now:

```bash,run
ssh vm2 date
```

You should see the date and time displayed.

If you are already logged in, skip to `Scenario - Autopilot` below.

Connecting to SUSE Virtualization
=====

In this lab, we will be interacting with SUSE Virtualization using SUSE Rancher Prime. Rancher Prime provides a unified interface for managing Kubernetes clusters, including SUSE Virtualization.

### Logging in to the Rancher Prime UI

Let's open the [button label="Rancher" variant="success"](tab-1) tab.

Log in to Rancher Prime, if necessary, with the following credentials:

- Username:

```txt
admin
```

- Password:

```txt
[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="cloud-client" ]]
```

### Accessing the SUSE Virtualization Cluster

From the Rancher Prime UI, select the `Virtualization Management` menu item from the left-hand menu. Then select the `harvester` cluster from the menu.

![01-connect_to_cluster.gif](../assets/01-connect_to_cluster.gif)

Configure SUSE Virtualization to Allow Disk Expansion
=====

In order for us to automatically expand our virtual machine disks, we need to configure SUSE virtualization to allow disk expansion.

After accessing our SUSE Virtualization cluster:
- Click on the `Advanced` -> `Settings` menu item from the left-hand menu
- Scroll down and click on the kabob menu (three vertical dots) on the right side of the `csi-online-expand-validation`setting and select `Edit Setting`
- Click the `Add` button to create a new row
- Select the `pxd.portworx.com` from the `Provisioner` dropdown
- Ensure the `Value` is set `true`
- Click the `Save` button




Autopilot
=====

Portworx Autopilot is a rule-based engine that responds to changes from a monitoring source. AutoPilot allows you to specify monitoring conditions along with actions it should take when those conditions occur.


### Task 1: Review the Autopilot Rule

AutoPilot uses a rules engine to determine which persistent volumes need to be expanded and under what conditions.
Before we deploy our autopilot rule, lets review the Autopilot rule we'll be using for this lab by running the following:

```bash,run
ccat autopilotrule.yaml
```

Pay close attention to several parts of the AutoPilot Rule:
 - ***Line 6-9:*** Target PVCs with the Kubernetes label `auto_expand: on`

 - ***Line 10-13:*** Apply the rule to any namespaces with the label `auto_expand: on`

 - ***Lines 15-22:*** Monitor if capacity usage grows to or above 10%

 - ***Line 24-28:*** Automatically grow the volume and underlying filesystem by 100% of the current volume size if the conditions above are met

 - ***Line 29-30:*** Not grow the volume to more than 75Gi

Apply the yaml to create the Portworx Autopilot rule in your OpenShift cluster:
```bash,run
k apply -f autopilotrule.yaml
```

### Task 2: Set the AutoPilot Labels

Under regular circumstances you'd likely deploy your resources with the appropriate labels already configured on them. For example, you might have the `auto_expand: on` label saved in your Kubernetes namespace and PVC manifests. However for this lab we'll be applying labels to existing resources that have already been deployed.

Our Autopilot rule will expand PVCs that have the `auto_expand: on` label applied. So let's apply that label to our virtual machine's PVC.

```bash,run
k label pvc vm2-boot -n default auto_expand=on --overwrite
```

And similarly, this same label is used on our namespaces. Use the command below to set the label on the `pxbbq` namespace.

```bash,run
k label namespace default auto_expand=on --overwrite
```

Expand Storage Capacity
=====

Before we expand the capacity of our persistent volume, let's take a look at how much space is already being used already.

Go to the [button label="Rancher"](tab-1) tab to review the disk space used from the Rancher UI.

From the Rancher UI:
- Select the `Virtual Machines` menu item
- Click on the `vm2` virtual machine
- Click on the `Volumes` menu item
- Note the size of our `vm2-boot` volume. It's 10Gi.

Go back to the [button label="Terminal"](tab-0) and run the following command to see the size of the PVC and the data volumes.

```bash,run
k get pvc vm2-data
```
> [!IMPORTANT]
> Take note of the size of our pvc! It's 5Gi.

### Task 1: Start filling the disk

We'll start filling the disk space up by running this command below.

```bash,run
ssh vm2 'sudo touch /tmp/file; sudo dd if=/dev/urandom of=/tmp/file bs=1M count=4096' &
```


### Task 2: Observe the Portworx Autopilot events
Run the following command to observe the state changes for Portworx Autopilot:
```bash,run
watch kubectl get events --field-selector \
 involvedObject.kind=AutopilotRule,involvedObject.name=volume-resize \
 --all-namespaces --sort-by .lastTimestamp -o custom-columns=MESSAGE:.message
```

> [!IMPORTANT]
> It will take some time for the disk fill command to write data, and for AutoPilot to detect a disk over its defined capacity rule. Not all stages found below may be available right away. Wait until the ActiveActionsTaken event is displayed.

You will see Portworx Autopilot move through the following states as it monitors volumes and takes actions defined in Portworx Autopilot rules:
 - ***Initializing*** (Detected a volume to monitor via applied rule conditions)

 - ***Normal*** (Volume is within defined conditions and no action is necessary)

 - ***Triggered*** (Volume is no longer within defined conditions and action is necessary)

 - ***ActiveActionsPending*** (Corrective action is necessary but not executed yet)

 - ***ActiveActionsInProgress*** (Corrective action is under execution)

 - ***ActiveActionsTaken*** (Corrective action is complete)

Once you see ActiveActionsTaken in the event output, press `CTRL+C` to exit the watch command.

### Task 3: Verify the Volume Expansion
Now let's take a look at our PVC - note the automatic expansion of the volume occurred with no human interaction and no application interruption:

```bash,run
k get pvc vm2-boot
```
> [!IMPORTANT]
> You should see the data volume size has now increased by 100%. `(20Gi)`

AutoPilot has expanded our PersistentVolume automatically, like we intended from our rules. If this was a container running in a Kubernetes Pod, this would be the last step of the process and is fully unattended. However, in this case we're running a virtual machine with an Operating System installed and that means it has its own filesystem. For virtual machines, we then login to the virtual machine and expand its own filesystem to take advantage of this new free space that was created by AutoPilot.

Run the following command to show the filesystem is still the original size.

```bash,run
ssh vm2 'df -h'
```

In the output from the `df -h` command, you can see that `/dev/vda1` virtual device is using `5.7Gi` and the total disk size is still showing roughly `8.7Gi` in total size, which matches our old PVC size.

Now expand the filesystem to consume the additional space in the PVC.

The command below will ssh into the virtual machine and expand the filesystem for us.

```bash,run
ssh vm2 'yes Fix | sudo parted --script --fix /dev/vda print ; yes | sudo parted ---pretend-input-tty /dev/vda resizepart 1 100% ; sudo resize2fs /dev/vda1'
```

Once that command is completed, we can now observe the freespace in our virtual machine by running the `df -h` command again:

```bash,run
ssh vm2 'df -h'
```

Now the `/dev/vda1` virtual device shows `19G` and the total disk size.

You've just configured Portworx Autopilot and observed how it can perform automated capacity management based on rules you configure, and be able to "right size" your underlying persistent storage as it is needed!


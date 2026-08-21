---
slug: the-unthinkable-error-snapshots
id: nkrkc4vyyywt
type: challenge
title: '<span id="assignment.116" lang="en" hist="sky-telco">⏪ Chapter 6: The Unthinkable Error</span>'
teaser: <span id="assignment.117" lang="en" hist="sky-telco">A slipped cursor just wiped out a $100M carrier interconnect settlement record. Turn back the clock
  with VM snapshots, verify the recovery in a safe staging clone, then make protection
  permanent with scheduled off-cluster backups.</span>
tabs:
- id: lygpkmkmyndn
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: gofsbdvdnoyj
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: 4accqnqjfweo
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: intermediate
timelimit: 3600
enhanced_loading: null
---
<span id="assignment.118" lang="en" hist="sky-telco">⏪ Chapter 6: <span id="assignment.118.1" lang="en" no>The Unthinkable Error</span>
===================================</span>

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

<img class="logos" alt="Welcome!" src="../assets/06-chapter-img.png"/>

<div id="601" class="story">

<span id="assignment.119" lang="en" hist="sky-telco">The next morning, the exhausted silence of the night shift is abruptly broken by a muffled groan coming from the junior network operations engineer's desk.

You and Sarah walk over immediately. The junior engineer is staring at his screen in abject horror, his hands shaking over his keyboard. While attempting to clear out stale temporary files on the primary billing-ledger server, his cursor slipped. He accidentally executed a recursive delete command on the wrong directory.

A one hundred million dollar carrier interconnect settlement record, finalized only moments before, has been wiped entirely from the disk.

*"I destroyed it,"* the engineer whispers, trembling. *"The backup tape run does not happen until midnight. The data is just gone."*

Sarah closes her eyes, rubbing her temples, bracing for the devastating impact this will have on the provider's regulatory standing and reputation with roaming partners. But you place a steady hand on the engineer's shoulder.

*"The data isn't gone,"* you say calmly. *"Our new storage architecture relies on distributed block-level snapshots. I took a baseline state capture right before the morning shift started."*

You step up to his terminal. It is time to turn back the clock. But you must be careful: you want to **verify the restored data in a safe sandbox before overwriting production**.</span>

</div>

<span id="assignment.120" lang="en" no>## 🎯 Your Quest Objectives

1. Simulate the creation and destruction of the record
2. Clone a staging environment from the snapshot
3. Verify the data in the staging sandbox
4. Restore the production system
5. Connect the <span id="assignment.120.1" lang="nolang" hist="sky-telco">bank's off-cluster backup vault</span>
6. Put backups on a schedule



🔐 Login Credentials
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



<span id="assignment.121" lang="en" no>💥 Task 1: Simulate the creation and destruction of the record
==============================================================


  


You will replay this morning's events yourself, so you understand exactly what the snapshot protects.

In the</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.122" lang="en" no>, log into the virtual machine (it may take a couple of minutes until the VM starts):

```bash,wrap,run
while [[ "${IPA}" ==  "" ]]; do IPA=`kubectl --kubeconfig .rodeo/harvester-kubeconfig get vmi core-services -n prod -o jsonpath='{.status.interfaces[0].ipAddress}'|grep -v ':'`; sleep 5; echo -n '.'; done ; while [[ "$?" != "0" ]] ; do ssh -T -o StrictHostKeyChecking=accept-new sles@${IPA} 2>/dev/null ; sleep 5; done ; ssh -o StrictHostKeyChecking=accept-new sles@${IPA}

```

Generate the highly sensitive interconnect settlement record onto the disk by typing exactly this:

```bash,wrap,run
echo "CARRIER: WAYNE MOBILE | SETTLEMENT: 100,000,000 | STATUS: CLEARED" > /home/sles/ledger.txt
```

**Now capture the baseline.** Switch to the</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.123" lang="en" no>:

1. Navigate to <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>, then locate the following VM and click the  button next to it:</span>

<div class="cred">

```txt
core-services
```

</div>
<span id="assignment.124" lang="en" no>2. Click on <span id="assignment.124.1" lang="nolang" no>**Take Virtual Machine Snapshot**</span>
3. Name it:</span>

<div class="cred">

```txt
pre-disaster-backup
```

</div>

<span id="assignment.125" lang="en" no>4. Click on <span id="assignment.19.3" lang="nolang" no>**Create**</span>

5. Navigate to <span id="assignment.125.1" lang="nolang" no>**Backup and Snapshots**</span>, then click on <span id="assignment.125.2" lang="nolang" no>**Virtual Machine Snapshots**</span> and wait for one we just created to have the state <span id="assignment.125.3" lang="nolang" no>**Ready**</span>: the rollback point is set


Return to the</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.126" lang="en" no>and simulate the junior engineer's terrible mistake:

```bash,run
rm -f /home/sles/ledger.txt
```

One hundred million dollars in settlement money, gone from the disk. Leave the VM console:

```bash,run
exit
```


🧪 Task 2: Clone a staging environment from the snapshot
========================================================


  


Instead of immediately restoring production, you will build a **clone** to verify the data first, non-destructive recovery is always advised.

In the</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.127" lang="en" no>.

1. Navigate to <span id="assignment.125.1" lang="nolang" no>**Backup and Snapshots**</span>, then click on <span id="assignment.125.2" lang="nolang" no>**Virtual Machine Snapshots**</span>

2. Click on <span id="assignment.127.1" lang="nolang" no>**pre-disaster-backup**</span> snapshot:

3. Click the  next to it and select <span id="assignment.127.2" lang="nolang" no>**Restore New**</span>

4. Name the new virtual machine:</span>


<div class="cred">

```txt
core-services-staging-verify
```

</div>


<span id="assignment.128" lang="en" no>5. Click <span id="assignment.19.3" lang="nolang" no>**Create**</span>


> [!Note]
> Due to the hardware used in this lab this process will take longer than in normal conditions please continue to the next task.



📡 Task 3: Connect the off-cluster backup vault
======================================================


  


Snapshots saved us this morning, but snapshots live on the **same cluster** as the workload. They protect against fat fingers, but not against physical damage or cyber attacks. For real disaster recovery we operate an off-cluster **backup vault**: an NFS share on a separate storage system. Time to plug it in.

In the</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.129" lang="en" no>:

1. Go to <span id="assignment.129.1" lang="nolang" no>**Advanced > Settings**</span> and locate:</span>

<div class="cred">

```txt
backup-target
```

</div>
<span id="assignment.130" lang="en" no>2. Click the  on its row and select <span id="assignment.130.1" lang="nolang" no>**Edit Setting**</span>, add the following:

- <span id="assignment.110.2" lang="nolang" no>**Type**</span>: <span id="assignment.130.2" lang="nolang" no><b class="highlightcopy">NFS</b></span>
- <span id="assignment.130.3" lang="nolang" no>**Endpoint**</span>:</span>

<div class="cred">

```txt
192.168.122.1:/srv/backups/
```

</div>

<span id="assignment.131" lang="en" no>3. Click <span id="assignment.114.7" lang="nolang" no>**Save**</span>

The cluster can now ship complete VM backups off the cluster, the modern equivalent of the midnight tape run, minus the midnight. An **S3** bucket works just as well as an endpoint; in a production deployment this would point to a physically separated facility.


⏰ Task 4: Put backups on a schedule
====================================</span>

<div id="602" class="story">
<span id="assignment.132" lang="en" hist="sky-telco">Ad-hoc snapshots can save the day once; policy keeps the network safe every day after.</span>
</div>

<span id="assignment.133" lang="en" no>Put core-services itself under an automatic backup schedule so nobody ever has to remember to do this by hand again.


In the</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.134" lang="en" no>:

1. Go to <span id="assignment.134.1" lang="nolang" no>**Backup & Snapshot > Virtual Machine Schedules**</span> and click <span id="assignment.134.2" lang="nolang" no>**Create schedule**</span>
2. Set the following details:

  - <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: <span id="assignment.55.2" lang="nolang" no><b class="highlightcopy">prod</b></span>
  - <span id="assignment.134.3" lang="nolang" no>**Virtual Machine Name**</span>: <span id="assignment.134.4" lang="nolang" no><b class="highlightcopy">core-services</b></span>
  - <span id="assignment.134.5" lang="nolang" no>**Basics**</span>:
    - <span id="assignment.134.6" lang="nolang" no>**Retain:**</span> 5
    - <span id="assignment.134.7" lang="nolang" no>**Max Failure:**</span> 2
    - <span id="assignment.134.8" lang="nolang" no>**Cron Schedule:**</span> (at minute 00, every 5 hours)</span>

<div class="cred">

```txt
0 */5 * * *
```

</div>


<span id="assignment.135" lang="en" no>4. Click <span id="assignment.19.3" lang="nolang" no>**Create**</span>

From now on the platform backs the VM up to the NFS vault every five hours, keeps the five most recent copies, and pauses the schedule if two consecutive runs fail. Set once, protected forever.



🔍 Task 5: Verify the data in the staging sandbox
=================================================


  


Now that core-services-staging-verify is up and running, let's verify the file is there.

This time we will use the graphical console, since the VM has no network.

In the</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.136" lang="en" no>:

1. Go to <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>
2. Click <span id="assignment.61.1" lang="nolang" no>**Console**</span> drop-down and select <span id="assignment.136.1" lang="nolang" no>**Open in WebVNC**</span>, a new window will appear with the terminal, feel free to resize it.
3. Login using the following credentials:
   - <span id="assignment.136.2" lang="nolang" no>**username**</span>: 'sles'
   - <span id="assignment.136.3" lang="nolang" no>**password**</span>: '1234'

4. Once inside run the following command:</span>


<div class="cred">

```txt
cat /home/sles/ledger.txt
```

</div>

<span id="assignment.137" lang="en" no>5. It should return:

**CARRIER: WAYNE MOBILE | SETTLEMENT: 100,000,000 | STATUS: CLEARED**


The text prints flawlessly. <span id="assignment.137.1" lang="en" hist="sky-telco">**The data is safe.**</span>


Now let's delete the clone we no longer need.

1. Close the window with the console.
2. Click the  on **core-services-staging-verify** row and select <span id="assignment.137.2" lang="nolang" no>**Delete**</span>, and again <span id="assignment.137.2" lang="nolang" no>**Delete**</span>.



♻️ Task 6: Restore the production system
=========================================


  


Now that you have verified the snapshot's integrity, proceed to restore the production system:

1. Go to **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>**
2. Click the  on **core-services** row and select <span id="assignment.137.3" lang="nolang" no>**Stop**</span>, and again <span id="assignment.74.2" lang="nolang" no>**Apply**</span>.
3. Once it has completely stopped, navigate to <span id="assignment.125.1" lang="nolang" no>**Backup and Snapshots**</span>, then click on <span id="assignment.125.2" lang="nolang" no>**Virtual Machine Snapshots**</span>

4. Click on **pre-disaster-backup** snapshot:

5. Click the  next to it and select <span id="assignment.137.4" lang="nolang" no>**Replace Existing**</span>

6. Click on <span id="assignment.19.3" lang="nolang" no>**Create**</span>

The VM will power itself back up because that is what the run strategy defines.

Optionally, SSH back and `cat` the file one last time, then logout of the VM. <span id="assignment.137.5" lang="en" hist="sky-telco">The record is back where it belongs.</span>


🏋️ Bonus Drills: see the machinery behind the safety net (optional)
======================================================================

- **For the command-line curious:** each VM snapshot is built from volume-level snapshots, and every one of them is an API object, as is your new backup schedule:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get VirtualMachineBackup -A; kubectl --kubeconfig .rodeo/harvester-kubeconfig get volumesnapshots -A; kubectl --kubeconfig .rodeo/harvester-kubeconfig get schedulevmbackups -A
```

> [!NOTE]
> Make sure you logout of the VM before running this commands.


📶 Why does this matter?
==============================================

- **Human error stops being catastrophic.** Recovery went from "wait for midnight tapes and pray" to a five-minute, self-service rollback.
- **Verify before you overwrite.** Restoring to a clone means you never gamble production on an unverified backup, a pattern your auditors and your junior engineers will both sleep better with.
- **Protection is now policy, not heroics.** An off-cluster NFS backup vault and a five-hourly backup schedule mean the safety net runs itself from here on.

Click <span id="assignment.32.1" lang="nolang" no>**Check**</span> to continue. 🤠

📚 More information
===================</span>

- [Virtual Machine Backup and Restore](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/backup-restore.html)

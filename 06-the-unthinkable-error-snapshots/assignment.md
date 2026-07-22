---
slug: the-unthinkable-error-snapshots
id: nkrkc4vyyywt
type: challenge
title: ⏪ Chapter 6 — The Unthinkable Error
teaser: A slipped cursor just deleted a $100M settlement record. Turn back the clock
  with VM snapshots, verify the recovery in a safe staging clone — then make protection
  permanent with scheduled off-cluster backups.
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

⏪ Chapter 6 — The Unthinkable Error
===================================

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

<img class="logos" alt="Welcome!" src="../assets/06-chapter-img.png"/>

<div id="601" class="story">

The next morning, the exhausted silence of the night shift is abruptly broken by a muffled sob coming from the junior database administrator's desk.

You and Sarah walk over immediately. The junior admin is staring at his screen in abject horror, his hands shaking over his keyboard. While attempting to clear out stale temporary files on the primary <b class="highlightcopy">core-services</b> server, his cursor slipped. He accidentally executed a recursive delete command on the wrong directory.

A <span class="danger">one hundred million dollar</span> corporate transaction settlement record, finalized only moments before, has been wiped entirely from the disk.

*"I destroyed it,"* the admin whispers, trembling. *"The backup tape run does not happen until midnight. The data is just gone."*

Sarah closes her eyes, rubbing her temples, bracing for the devastating impact this will have on the bank's stock price and reputation. But you place a steady hand on the admin's shoulder.

*"The data isn't gone,"* you say calmly. *"Our new storage architecture relies on distributed block-level snapshots. I took a baseline state capture right before the morning shift started."*

You step up to his terminal. It is time to turn back the clock. But you must be careful: you want to **verify the restored data in a safe sandbox before overwriting production**.

</div>

<div class="missionbox">

## 🎯 Your Quest Objectives

1. Simulate the creation and destruction of the record
2. Clone a staging environment from the snapshot
3. Verify the data in the staging sandbox
4. Restore the production system
5. Connect the bank's off-cluster backup vault
6. Put backups on a schedule

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



💥 Task 1: Simulate the creation and destruction of the record
==============================================================

You will replay this morning's events yourself, so you understand exactly what the snapshot protects.

In the [button label="Cluster Terminal" variant="success"](tab-1), log into the core-services virtual machine:

```bash
ssh sles@CORE_SERVICES_IP
```

Generate the highly sensitive transaction record onto the disk by typing exactly this:

```bash,run
echo "CLIENT: BRUCE WAYNE | AMOUNT: 100,000,000 | STATUS: CLEARED" > /home/sles/ledger.txt
```

**Now capture the baseline.** Switch to the [button label="SUSE Virtualization UI" variant="success"](tab-0):

1. Navigate to the <b class="highlightcopy">core-services</b> details page
2. Click the **Snapshots** tab
3. Click **Take Snapshot** and name it <b class="highlightcopy">pre-disaster-backup</b>
4. Wait for the storage subsystem to flag the snapshot state as **Active** — the rollback point is set

> [!NOTE]
> Snapshots are **crash-consistent** by default — equivalent to pulling the power cord and booting back up. For **application-consistent** snapshots (filesystem freeze during capture), the QEMU guest agent must be running inside the VM — you will meet it again in a later chapter.

Return to the [button label="Cluster Terminal" variant="success"](tab-1) and simulate the junior admin's terrible mistake:

```bash,run
rm /home/sles/ledger.txt
```

Verify the file is truly gone:

```bash,run
cat /home/sles/ledger.txt
```

`No such file or directory`. One hundred million dollars, gone from the disk. Type `exit` to leave the core-services VM.

🧪 Task 2: Clone a staging environment from the snapshot
========================================================

Instead of immediately restoring production, you will build a **clone** to verify the data first — non-destructive recovery is how professionals turn back time.

In the [button label="SUSE Virtualization UI" variant="success"](tab-0), in the **Snapshots** tab for the <b class="highlightcopy">core-services</b>:

1. Locate <b class="highlightcopy">pre-disaster-backup</b>
2. Click the **three dots** next to it and select **Restore to New Virtual Machine**
3. Name the new virtual machine <b class="highlightcopy">ledger-staging-verify</b>
4. Click **Create**

🔍 Task 3: Verify the data in the staging sandbox
=================================================

Wait for <b class="highlightcopy">ledger-staging-verify</b> to boot and acquire an IP address. In the [button label="Cluster Terminal" variant="success"](tab-1), SSH into this new staging virtual machine:

```bash
ssh sles@STAGING_IP_ADDRESS
```

Verify the file's existence:

```bash,run
cat /home/sles/ledger.txt
```

<div id="602" class="story">

`CLIENT: BRUCE WAYNE | AMOUNT: 100,000,000 | STATUS: CLEARED`

The text prints flawlessly. **The data is safe.**

</div>

Type `exit` to leave the staging server.

♻️ Task 4: Restore the production system
=========================================

Now that you have verified the snapshot's integrity, return to the [button label="SUSE Virtualization UI" variant="success"](tab-0):

1. **Power off** the original <b class="highlightcopy">core-services</b> virtual machine to freeze the corrupted disk state
2. In the **Snapshots** tab, click the action menu next to <b class="highlightcopy">pre-disaster-backup</b>
3. Select **Restore** and confirm the action
4. Power the virtual machine back on

Optionally, SSH back into the production ledger and `cat` the file one last time — the record is back where it belongs.

🏦 Task 5: Connect the bank's off-cluster backup vault
======================================================

Snapshots saved the ledger this morning — but snapshots live on the **same cluster** as the workload. They protect against fat fingers, not against a datacenter fire. For real disaster recovery the bank operates an off-cluster **backup vault**: an NFS share on a separate storage system. Time to plug it in.

In the [button label="SUSE Virtualization UI" variant="success"](tab-0):

1. Go to **Advanced > Settings** and locate <b class="highlightcopy">backup-target</b>
2. Click the **three dots** on its row and select **Edit Setting**
3. Set the **Type** to <b class="highlightcopy">NFS</b>
4. Set the **Endpoint** to <b class="highlightcopy">192.168.122.1:/srv/backups/</b>
5. Click **Save**

The cluster can now ship complete VM backups off the cluster — the modern equivalent of the midnight tape run, minus the midnight. An **S3** bucket works just as well as an endpoint; in a production <b class="bank">Vertex Trust Bank</b> deployment this would point to a separate facility.

⏰ Task 6: Put backups on a schedule
====================================

Ad-hoc snapshots saved the day once; policy keeps the bank safe every day after. Put <b class="highlightcopy">core-services</b> itself under an automatic backup schedule so nobody ever has to remember to do this by hand again.

In the [button label="SUSE Virtualization UI" variant="success"](tab-0):

1. Go to **Backup & Snapshot > Virtual Machine Schedules** and click **Create schedule**
2. Set the **Namespace** to <b class="highlightcopy">prod</b> and the **Virtual Machine Name** to <b class="highlightcopy">core-services</b>
3. On the **Basics** tab, fill in:
   - **Cron Schedule:** <b class="highlightcopy">0 */5 * * *</b> — at minute 00, every 5 hours
   - **Retain:** <b class="highlightcopy">5</b>
   - **Max Failure:** <b class="highlightcopy">2</b>
4. Click **Create**

From now on the platform backs the ledger up to the NFS vault every five hours, keeps the five most recent copies, and pauses the schedule if two consecutive runs fail. Set once, protected forever.

🏋️ Bonus Drills — see the machinery behind the safety net (optional)
======================================================================

- **See the replication with your own eyes.** Open the **Longhorn** dashboard (via **Support > Access Embedded Longhorn UI**, as in Chapter 1), go to the **Volume** page, and click any volume. The diagram shows its replicas spread across different nodes — one node can burn down and the ledger keeps serving.

- **For the command-line curious:** each VM snapshot is built from volume-level snapshots, and every one of them is an API object — as is your new backup schedule:

```bash,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get vmsnapshots -A; kubectl --kubeconfig .rodeo/harvester-kubeconfig get volumesnapshots -A; kubectl --kubeconfig .rodeo/harvester-kubeconfig get schedulevmbackups -A
```

- **Clean up the sandbox.** The staging clone did its job; delete <b class="highlightcopy">ledger-staging-verify</b> from the **Virtual Machines** page to return its resources to the pool.

💼 Why does this matter for Vertex Trust Bank?
==============================================

- **Human error stops being catastrophic.** Recovery went from "wait for midnight tapes and pray" to a five-minute, self-service rollback.
- **Verify before you overwrite.** Restoring to a clone means you never gamble production on an unverified backup — a pattern your auditors and your junior admins will both sleep better with.
- **Protection is now policy, not heroics.** An off-cluster NFS backup vault and a five-hourly backup schedule mean the safety net runs itself from here on.

Click **Check** to continue. 🤠

📚 More information
===================

- [Virtual Machine Backup and Restore](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/backup-restore.html)

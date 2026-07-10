---
slug: the-unthinkable-error-snapshots
id: nkrkc4vyyywt
type: challenge
title: ⏪ Chapter 6 — The Unthinkable Error
teaser: A slipped cursor just deleted a $100M settlement record. Turn back the clock
  with VM snapshots — and verify the recovery in a safe staging clone before touching
  production.
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
timelimit: 3000
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

<div class="storybox">

The next morning, the exhausted silence of the night shift is abruptly broken by a muffled sob coming from the junior database administrator's desk.

You and Sarah walk over immediately. The junior admin is staring at his screen in abject horror, his hands shaking over his keyboard. While attempting to clear out stale temporary files on the primary <b class="highlightcopy">transaction-ledger</b> server, his cursor slipped. He accidentally executed a recursive delete command on the wrong directory.

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

</div>

💥 Task 1: Simulate the creation and destruction of the record
==============================================================

You will replay this morning's events yourself, so you understand exactly what the snapshot protects.

In the [button label="Cluster Terminal" variant="success"](tab-1), log into the ledger virtual machine (find `TRANSACTION_LEDGER_IP` in the UI):

```bash
ssh opensuse@TRANSACTION_LEDGER_IP
```

Generate the highly sensitive transaction record onto the disk by typing exactly this:

```bash,run
echo "CLIENT: BRUCE WAYNE | AMOUNT: 100,000,000 | STATUS: CLEARED" > /home/opensuse/ledger.txt
```

**Now capture the baseline.** Switch to the [button label="SUSE Virtualization UI" variant="success"](tab-0):

1. Navigate to the <b class="highlightcopy">transaction-ledger</b> details page
2. Click the **Snapshots** tab
3. Click **Take Snapshot** and name it <b class="highlightcopy">pre-disaster-backup</b>
4. Wait for the storage subsystem to flag the snapshot state as **Active**

You can confirm the checkpoint from the API as well — in a second terminal or after the next step:

```bash,run
kubectl get vmsnapshots -A
```

The snapshot should report `ReadyToUse: true`. The rollback point is set.

> [!NOTE]
> Snapshots are **crash-consistent** by default — equivalent to pulling the power cord and booting back up. For **application-consistent** snapshots (filesystem freeze during capture), the QEMU guest agent must be running inside the VM — you will meet it again in a later chapter.

Return to the [button label="Cluster Terminal" variant="success"](tab-1) and simulate the junior admin's terrible mistake:

```bash,run
rm /home/opensuse/ledger.txt
```

Verify the file is truly gone:

```bash,run
cat /home/opensuse/ledger.txt
```

`No such file or directory`. One hundred million dollars, gone from the disk. Type `exit` to leave the ledger VM.

🧪 Task 2: Clone a staging environment from the snapshot
========================================================

Instead of immediately restoring production, you will build a **clone** to verify the data first — non-destructive recovery is how professionals turn back time.

In the [button label="SUSE Virtualization UI" variant="success"](tab-0), in the **Snapshots** tab for the <b class="highlightcopy">transaction-ledger</b>:

1. Locate <b class="highlightcopy">pre-disaster-backup</b>
2. Click the **three dots** next to it and select **Restore to New Virtual Machine**
3. Name the new virtual machine <b class="highlightcopy">ledger-staging-verify</b>
4. Click **Create**

🔍 Task 3: Verify the data in the staging sandbox
=================================================

Wait for <b class="highlightcopy">ledger-staging-verify</b> to boot and acquire an IP address. In the [button label="Cluster Terminal" variant="success"](tab-1), SSH into this new staging virtual machine:

```bash
ssh opensuse@STAGING_IP_ADDRESS
```

Verify the file's existence:

```bash,run
cat /home/opensuse/ledger.txt
```

<div class="storybox">

`CLIENT: BRUCE WAYNE | AMOUNT: 100,000,000 | STATUS: CLEARED`

The text prints flawlessly. **The data is safe.**

</div>

Type `exit` to leave the staging server.

♻️ Task 4: Restore the production system
=========================================

Now that you have verified the snapshot's integrity, return to the [button label="SUSE Virtualization UI" variant="success"](tab-0):

1. **Power off** the original <b class="highlightcopy">transaction-ledger</b> virtual machine to freeze the corrupted disk state
2. In the **Snapshots** tab, click the action menu next to <b class="highlightcopy">pre-disaster-backup</b>
3. Select **Restore** and confirm the action
4. Power the virtual machine back on

Optionally, SSH back into the production ledger and `cat` the file one last time — the record is back where it belongs.

🏋️ Bonus Drills — from snapshots to a real protection strategy
===============================================================

- **Tier your protection policies.** Every ledger disk currently gets **3 replicas** — one per node. Inspect the default policy in the UI under **Advanced > Storage Classes** (click `harvester-longhorn` and note `numberOfReplicas: "3"`). Not everything deserves banking-grade replication, though — create a lighter 2-replica tier for the bank's dev and staging workloads:

```bash,run
cat << EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: harvester-longhorn-2rep
  annotations:
    storageclass.kubernetes.io/is-default-class: "false"
provisioner: driver.longhorn.io
allowVolumeExpansion: true
reclaimPolicy: Delete
volumeBindingMode: Immediate
parameters:
  numberOfReplicas: "2"
  staleReplicaTimeout: "30"
  fromBackup: ""
  fsType: ext4
EOF
```

```bash,run
kubectl get storageclass
```

  Two policies now exist: `harvester-longhorn` (3 replicas — production ledgers) and `harvester-longhorn-2rep` (2 replicas — dev and staging).

- **See the replication with your own eyes.** Check how Longhorn spreads each volume's replicas across different nodes — one node can burn down and the ledger keeps serving:

```bash,run
kubectl get replicas.longhorn.io -n longhorn-system -o custom-columns=NAME:.metadata.name,NODE:.spec.nodeID,VOLUME:.spec.volumeName,STATE:.status.currentState
```

- **Look one layer deeper** — each VM snapshot is built from volume-level snapshots in Longhorn:

```bash,run
kubectl get volumesnapshots -A
```

- **Clean up the sandbox.** The staging clone did its job; delete <b class="highlightcopy">ledger-staging-verify</b> from the **Virtual Machines** page to return its resources to the pool.

> [!IMPORTANT]
> Snapshots live on the **same cluster** as the workload — they protect against fat fingers, not against a datacenter fire. For real disaster recovery, <b class="virt">SUSE Virtualization</b> also supports **VM backups** to an external S3 or NFS backup target, plus scheduled snapshot/backup policies. Inspect where it plugs in:

```bash,run
kubectl get settings.harvesterhci.io backup-target -o yaml
```

> In a production <b class="bank">Vertex Trust Bank</b> deployment, this would point to an S3 bucket or NFS share at a separate facility — the modern equivalent of the midnight tape run, minus the midnight.

💼 Why does this matter for Vertex Trust Bank?
==============================================

- **Human error stops being catastrophic.** Recovery went from "wait for midnight tapes and pray" to a five-minute, self-service rollback.
- **Verify before you overwrite.** Restoring to a clone means you never gamble production on an unverified backup — a pattern your auditors and your junior admins will both sleep better with.
- **The same mechanism scales up.** Ad-hoc snapshots today; scheduled, off-cluster backups for every ledger tomorrow.

Click **Check** to continue. 🤠

📚 More information
===================

- [Virtual Machine Backup and Restore](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/backup-restore.html)

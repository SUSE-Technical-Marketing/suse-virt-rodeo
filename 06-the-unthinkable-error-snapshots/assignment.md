---
slug: the-unthinkable-error-snapshots
id: nkrkc4vyyywt
type: challenge
title: '<span id="assignment.116" lang="zh-TW" hist="vertrex-bank">⏪ 第六章：難以想像的錯誤</span>'
teaser: <span id="assignment.117" lang="zh-TW" hist="vertrex-bank">游標手滑，剛刪除了一筆 1 億美元的結算紀錄。透過 VM 快照倒轉時光，在安全的預備環境複本中驗證復原，再透過排程的叢集外備份讓防護永久生效。</span>
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
<span id="assignment.118" lang="zh-TW" hist="vertrex-bank">⏪ 第 6 章：<span id="assignment.118.1" lang="zh-TW" no>難以想像的錯誤</span>
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

<span id="assignment.119" lang="zh-TW" hist="vertrex-bank">隔天清晨，大夜班那疲憊的寂靜，被初階資料庫管理員座位上傳來的一陣壓抑抽泣聲驟然打破。

您和 Sarah 立刻走了過去。這位初階管理員驚恐萬分地盯著螢幕，雙手在鍵盤上方顫抖著。他剛才試圖清除主要交易帳本伺服器 transaction-ledger 上的過期暫存檔時游標滑了一下，不小心在錯誤的目錄下執行了遞迴刪除指令。

一筆幾分鐘前才剛完成結算、金額高達一億美元的企業交易紀錄，就這樣從磁碟中被徹底抹除。

「我把它毀了，」管理員渾身發抖地低語著，「磁帶備份要到午夜才會執行。資料就這樣全沒了。」

Sarah 閉上雙眼，揉著太陽穴，準備迎接這件事對銀行股價與聲譽帶來的毀滅性打擊。但您伸手穩穩地按在管理員的肩膀上。

「資料沒有消失，」您平靜地說道，「我們新的儲存架構採用分散式區塊層級快照。在早班開始之前，我才剛擷取了基準狀態。」

您走向他的終端機。該是讓時鐘倒轉的時候了。但您必須謹慎行事：**在覆寫正式環境之前，必須先在安全的沙箱中驗證復原的資料**。</span>

</div>

<span id="assignment.120" lang="zh-TW" no>## 🎯 您的任務目標

1. 模擬紀錄的建立與銷毀
2. 從快照複製出預備環境
3. 驗證預備沙箱中的資料
4. 還原正式系統
5. 連接 <span id="assignment.120.1" lang="nolang" hist="vertrex-bank">bank's off-cluster backup vault</span>
6. 設定備份排程



🔐 登入憑證
====================

<span id="assignment.69.1" lang="nolang" no>**SUSE Virtualization**</span> UI 與 **Rancher Prime** UI 使用相同的憑證。</span>

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



<span id="assignment.121" lang="zh-TW" no>💥 任務 1：模擬紀錄的建立與銷毀
==============================================================


  


您將親自重現今天早上的事件，以確切了解快照所保護的內容。

在</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.122" lang="zh-TW" no>，登入虛擬機器（虛擬機器啟動可能需要幾分鐘）：

```bash,wrap,run
while [[ "${IPA}" ==  "" ]]; do IPA=`kubectl --kubeconfig .rodeo/harvester-kubeconfig get vmi core-services -n prod -o jsonpath='{.status.interfaces[0].ipAddress}'|grep -v ':'`; sleep 5; echo -n '.'; done ; while [[ "$?" != "0" ]] ; do ssh -T -o StrictHostKeyChecking=accept-new sles@${IPA} 2>/dev/null ; sleep 5; done ; ssh -o StrictHostKeyChecking=accept-new sles@${IPA}

```

請完全依照以下內容輸入，將高度敏感的交易紀錄產生至磁碟：

```bash,wrap,run
echo "CLIENT: BRUCE WAYNE | AMOUNT: 100,000,000 | STATUS: CLEARED" > /home/sles/ledger.txt
```

**現在擷取基準**。切換至</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.123" lang="zh-TW" no>：

1. 前往 <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>，然後找到下列 VM，並按一下其旁邊的 ⋮ 按鈕：</span>

<div class="cred">

```txt
core-services
```

</div>
<span id="assignment.124" lang="zh-TW" no>
2. 按一下 <span id="assignment.124.1" lang="nolang" no>**Take Virtual Machine Snapshot**</span>
3. 為其命名：</span>

<div class="cred">

```txt
pre-disaster-backup
```

</div>

<span id="assignment.125" lang="zh-TW" no>4. 按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span>

5. 前往 <span id="assignment.125.1" lang="nolang" no>**Backup and Snapshots**</span>，然後按一下 <span id="assignment.125.2" lang="nolang" no>**Virtual Machine Snapshots**</span>，並等待我們剛建立的項目狀態變為 <span id="assignment.125.3" lang="nolang" no>**Ready**</span>：還原點已設定


回到</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.126" lang="zh-TW" no>並模擬初階管理員所犯下的可怕錯誤：

```bash,run
rm -f /home/sles/ledger.txt
```

一億美元，就這樣從磁碟中消失了。離開 VM 主控台：

```bash,run
exit
```


🧪 任務 2：從快照複製出預備環境
========================================================


  


您不會立即還原正式環境，而是先建立一個**複本**（clone）來驗證資料；我們一律建議採用非破壞性的復原方式。

在</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.127" lang="zh-TW" no>：

1. 前往 <span id="assignment.125.1" lang="nolang" no>**Backup and Snapshots**</span>，然後按一下 <span id="assignment.125.2" lang="nolang" no>**Virtual Machine Snapshots**</span>

2. 按一下 <span id="assignment.127.1" lang="nolang" no>**pre-disaster-backup**</span> 快照：

3. 按一下其旁邊的 ⋮ 圖示，並選取 <span id="assignment.127.2" lang="nolang" no>**Restore New**</span>

4. 為新的虛擬機器命名：</span>


<div class="cred">

```txt
core-services-staging-verify
```

</div>


<span id="assignment.128" lang="zh-TW" no>5. 點選 <span id="assignment.19.3" lang="nolang" no>**Create**</span>


> [!Note]
> 由於本實驗所使用的硬體設備，此作業所需的時間會比一般情況更長，請繼續進行下一項任務。



🏦 任務 3：連接叢集外備份保存庫
======================================================


  


快照在今天早上拯救了我們，但快照與工作負載位於**同一個叢集**上。它們能防範人為操作失誤，但無法抵禦實體損壞或網路攻擊。為了做到真正的災難復原，我們維運一座叢集外的**備份保存庫**：位於另一套獨立儲存系統上的 NFS 共用資料夾。是時候將它接上了。

在</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.129" lang="zh-TW" no>：

1. 前往 <span id="assignment.129.1" lang="nolang" no>**Advanced > Settings**</span> 並找到：</span>

<div class="cred">

```txt
backup-target
```

</div>
<span id="assignment.130" lang="zh-TW" no>
2. 按一下該列上的 ⋮ 圖示，並選取 <span id="assignment.130.1" lang="nolang" no>**Edit Setting**</span>，新增下列內容：

- <span id="assignment.110.2" lang="nolang" no>**Type**</span>：<span id="assignment.130.2" lang="nolang" no><b class="highlightcopy">NFS</b></span>
- <span id="assignment.130.3" lang="nolang" no>**Endpoint**</span>：</span>

<div class="cred">

```txt
192.168.122.1:/srv/backups/
```

</div>

<span id="assignment.131" lang="zh-TW" no>3. 按一下 <span id="assignment.114.7" lang="nolang" no>**Save**</span>

該叢集現在可以將完整的 VM 備份傳送至叢集外部，這相當於現代版的午夜磁帶備份作業，只是不需要等到半夜。**S3** 儲存貯體同樣適合作為端點；在正式環境部署中，這將會指向實體隔離的設施。


⏰ 任務 4：設定備份排程
====================================</span>

<div id="602" class="story">
<span id="assignment.132" lang="zh-TW" hist="vertrex-bank">臨時快照能解一時之危，策略則能確保銀行往後日日平安。</span>
</div>

<span id="assignment.133" lang="zh-TW" no>將 core-services 本身納入自動備份排程，這樣就再也沒有人需要記得手動執行這項操作了。


在</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.134" lang="zh-TW" no>：

1. 前往 <span id="assignment.134.1" lang="nolang" no>**Backup & Snapshot > Virtual Machine Schedules**</span> 並按一下 <span id="assignment.134.2" lang="nolang" no>**Create schedule**</span>
2. 設定下列詳細資訊：

  - <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: <span id="assignment.55.2" lang="nolang" no><b class="highlightcopy">prod</b></span>
  - <span id="assignment.134.3" lang="nolang" no>**Virtual Machine Name**</span>: <span id="assignment.134.4" lang="nolang" no><b class="highlightcopy">core-services</b></span>
  - <span id="assignment.134.5" lang="nolang" no>**Basics**</span>:
    - <span id="assignment.134.6" lang="nolang" no>**Retain:**</span> 5
    - <span id="assignment.134.7" lang="nolang" no>**Max Failure:**</span> 2
    - <span id="assignment.134.8" lang="nolang" no>**Cron Schedule:**</span>（每 5 小時一次，於第 00 分執行）</span>

<div class="cred">

```txt
0 */5 * * *
```

</div>


<span id="assignment.135" lang="zh-TW" no>4. 按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span>

從現在起，平台將每五個小時把虛擬機器備份至 NFS 保存庫，保留最新的五份複本，並在連續兩次執行失敗時暫停排程。一次設定，永久保護。



🔍 任務 5：驗證預備沙箱中的資料
=================================================


  


既然 core-services-staging-verify 已經啟動並執行，我們來確認該檔案是否存在。

由於此虛擬機器沒有網路，這次我們將使用圖形主控台。

在</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.136" lang="zh-TW" no>：

1. 前往 <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>
2. 按一下 <span id="assignment.61.1" lang="nolang" no>**Console**</span> 下拉式選單並選取 <span id="assignment.136.1" lang="nolang" no>**Open in WebVNC**</span>，隨後會出現終端機的新視窗，您可以隨意調整視窗大小。
3. 使用下列憑證登入：
   - <span id="assignment.136.2" lang="nolang" no>**username**</span>: 'sles'
   - <span id="assignment.136.3" lang="nolang" no>**password**</span>: '1234'

4. 進入後，執行下列指令：</span>


<div class="cred">

```txt
cat /home/sles/ledger.txt
```

</div>

<span id="assignment.137" lang="zh-TW" no>5. 應該會顯示：

**CLIENT: BRUCE WAYNE | AMOUNT: 100,000,000 | STATUS: CLEARED**


文字完整無誤地顯示出來。<span id="assignment.137.1" lang="zh-TW" hist="vertrex-bank">**資料很安全。**</span>


現在讓我們刪除不再需要的複本。

1. 關閉主控台視窗。
2. 按一下 **core-services-staging-verify** 列上的 ⋮ 圖示，然後選取 <span id="assignment.137.2" lang="nolang" no>**Delete**</span>，並再次選取 <span id="assignment.137.2" lang="nolang" no>**Delete**</span>。



♻️ 任務 6：還原正式系統
=========================================


  


既然您已驗證快照的完整性，請接著還原正式系統：

1. 前往 **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>**
2. 按一下 **core-services** 列上的 ⋮ 圖示，然後選取 <span id="assignment.137.3" lang="nolang" no>**Stop**</span>，並再次選取 <span id="assignment.74.2" lang="nolang" no>**Apply**</span>。
3. 完全停止後，前往 <span id="assignment.125.1" lang="nolang" no>**Backup and Snapshots**</span>，然後按一下 <span id="assignment.125.2" lang="nolang" no>**Virtual Machine Snapshots**</span>

4. 按一下 **pre-disaster-backup** 快照：

5. 按一下其旁的 ⋮ 圖示，然後選取 <span id="assignment.137.4" lang="nolang" no>**Replace Existing**</span>

6. 按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span>

虛擬機器會自行重新開機，因為它的執行策略（run strategy）就是這樣定義的。

（選用）再次透過 SSH 連線並最後一次 `cat` 該檔案，然後登出虛擬機器。<span id="assignment.137.5" lang="zh-TW" hist="vertrex-bank">這項紀錄回到了屬於它的地方。</span>


🏋️ 加碼練習：了解安全防護網背後的運作機制（選做）
======================================================================

- **適合對命令列感到好奇的使用者：** 每個虛擬機器快照都是由磁碟區層級的快照組成，而這些快照每一個都是 API 物件，您剛建立的備份排程也一樣：

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get VirtualMachineBackup -A; kubectl --kubeconfig .rodeo/harvester-kubeconfig get volumesnapshots -A; kubectl --kubeconfig .rodeo/harvester-kubeconfig get schedulevmbackups -A
```

> [!NOTE]
> 在執行這些指令之前，請確認您已登出虛擬機器。


💼 為什麼這很重要？
==============================================

- **人為疏失不再釀成災難。** 復原工作從「苦等午夜磁帶並祈禱」變成只需五分鐘、自己就能完成的還原。
- **覆寫前先驗證。** 先還原到複本，代表您永遠不必拿正式環境去賭一份未經驗證的備份，這種做法能讓您的稽核人員和初階管理員都睡得更安穩。
- **保護從此靠制度，不再靠英雄救援。** 有了叢集外的 NFS 備份保存庫和每五小時一次的備份排程，從現在開始安全防護網會自動運作。

按一下 <span id="assignment.32.1" lang="nolang" no>**Check**</span> 以繼續。🤠

📚 更多資訊
===================</span>

- [Virtual Machine Backup and Restore](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/backup-restore.html)

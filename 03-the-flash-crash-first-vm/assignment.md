---
slug: the-flash-crash-first-vm
id: 09d4eiczcvaw
type: challenge
title: '<span id="assignment.33" lang="zh-TW" hist="vertrex-bank">⚡ 第三章：閃電崩盤</span>'
teaser: <span id="assignment.34" lang="zh-TW" hist="vertrex-bank">亞洲市場正在崩盤，量化分析師現在就需要運算引擎。只需幾分鐘即可部署包含儲存空間與憑證、已完整設定的虛擬機器，而不是耗費數天。</span>
tabs:
- id: 6byxu4pxkfpm
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: 381amyptjwzi
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: wxzurljjianr
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: basic
timelimit: 3000
enhanced_loading: null
---
<span id="assignment.35" lang="zh-TW" hist="vertrex-bank">⚡ 第三章：閃電崩盤
=============================</span>

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
    justify-content: center;
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

<img class="logos" alt="Welcome!" src="../assets/03-chapter-img.png"/>

<div id="301" class="story">

<span id="assignment.36" lang="zh-TW" hist="vertrex-bank">您坐在資料中心外頭的臨時辦公室裡，網路拓撲剛審查到一半，頭頂上的緊急警示燈突然閃爍起刺眼的黃光。您的無線電傳來一陣雜音後啟動，那是**量化交易主管**的聲音，聽起來驚慌失措。

*「亞洲市場出現重大異常！」*在狂亂交易大廳嘈雜的背景噪音中，他大聲喊道。*「我們目前的演算法模型無法及時解析湧入的資料串流。我們需要立即部署一台新的專屬高效能運算引擎，並配備次要高速資料磁碟區，否則接下來十分鐘內我們就會虧損數百萬！」*

過去在 Vertex Trust Bank，要處理這種緊急請求意味著必須開立高優先層級的工單、等待基礎架構團隊劃分儲存配額，並手動安裝作業系統。這是一個需要耗費**數天**的過程。

您沒有數天的時間。**您只有幾分鐘。**



您完全跳過傳統的工單系統，準備在短短數秒內部署一台已完整設定的 <span id="assignment.2.6" lang="nolang" no>Linux</span> 虛擬機器（包含已注入的安全憑證與掛載的儲存空間）。</span>
</div>


<span id="assignment.37" lang="zh-TW" no>## 🎯 您的任務目標

1. 驗證作業系統映像檔
2. 佈建 <span id="assignment.37.1" lang="zh-TW" hist="vertrex-bank">運算引擎</span>
3. 存取 Web 主控台



🔐 登入憑證
====================

**<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>** UI 與 **Rancher Prime** UI 使用相同的登入憑證。</span>

<span id="assignment.10" lang="nolang" no>Username</span>:

<div class="cred">

```txt
admin
```

</div>

<span id="assignment.11" lang="nolang" no>Password</span>:

<div class="cred">

```txt
[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="kvm-host" ]]
```

</div>




<span id="assignment.38" lang="zh-TW" no>📀 任務 1：驗證作業系統映像檔
============================================

前往</span> [button label="<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> UI" variant="success"](tab-0) <span id="assignment.39" lang="zh-TW" no>，在左側面板點選 **<span id="assignment.6.3" lang="nolang" no>Images</span>**，並確認基礎 <span id="assignment.39.1" lang="nolang" no>**SLES-16.0-Minimal-VM.x86_64-Cloud-GM.qcow2**</span> 作業系統映像檔存在且標記為 **<span id="assignment.6.17" lang="nolang" no>Active</span>**。

> [!NOTE]
> <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 中的 <span id="assignment.6.3" lang="nolang" no>Images</span> 是全叢集的黃金主映像檔（golden master）。您從此映像檔開機的每個 VM 都會獲得各自的寫入時複製（copy-on-write）磁碟。映像檔本身絕不會被修改。

**如果缺少該映像檔**，您可以在幾秒鐘內自行新增，無需等待儲存管理員。

透過 <span id="assignment.39.2" lang="nolang" no>**Images > Create**</span>，映像檔可以從 URL 建立、從您的工作站上傳，或從現有磁碟區匯出：


  


例如，讓我們新增一個映像檔：

1. 前往左側面板的 **<span id="assignment.6.3" lang="nolang" no>Images</span>** 並按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span>，然後填寫以下詳細資訊：
   - <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>：official-images
   - <span id="assignment.19.4" lang="nolang" no>**Name**</span>：自動填入
   - Basics：
     - <span id="assignment.39.4" lang="nolang" no>**URL**</span>：</span>

<div class="cred">

```txt
http://192.168.122.1:8889/SLES15-SP7-Minimal-VM.x86_64-Cloud-GM.qcow2
```

</div>


<span id="assignment.40" lang="zh-TW" no>2. 按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span>

您剛建立的映像檔會出現在清單中，狀態為 <span id="assignment.40.1" lang="nolang" no>**Downloading**</span>。您可以在進度欄中追蹤其進度。

請前往下一項任務；下載完成後，畫面右上角的**通知鈴鐺**會顯示提醒。


> [!NOTE]
> 下載是在伺服器端執行，來自此實驗室自身網路上的本機鏡像站，因此只需數秒即可完成。一旦 <span id="assignment.2.8" lang="nolang" no>Longhorn</span> 完成複寫，映像檔狀態即會變更為 **<span id="assignment.6.17" lang="nolang" no>Active</span>**。


🚀 任務 2：佈建運算引擎
===========================================


在此任務中，我們將建立第一部 VM。


> [!NOTE]
> 在收到指示之前，請勿按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span>。


  



導覽至 <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span> 並按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span> 按鈕。

<span id="assignment.40.3" lang="zh-TW" hist="vertrex-bank">完全依照量化分析師的需求設定引擎：</span>

- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>
<div class="cred">

```txt
the-engine-01
```

</div>

<span id="assignment.41" lang="nolang" no>
- **Namespace**:
</span>
<div class="cred">

```txt
prod
```

</div>


<span id="assignment.42" lang="zh-TW" no>如果 namespace 不存在，請建立它。

- <span id="assignment.42.1" lang="nolang" no>**CPU**</span>:</span>
<div class="cred">

```txt
2
```

</div>


<span id="assignment.43" lang="nolang" no>
- **Memory**:
</span>
<div class="cred">

```txt
2
```

</div>


<span id="assignment.44" lang="zh-TW" hist="vertrex-bank">請注意這裡配給的資源非常少：我們未來的量化團隊技術高超，且他們的應用程式已針對低延遲與低資源佔用進行了極致最佳化。</span>

<span id="assignment.45" lang="zh-TW" no>- <span id="assignment.45.1" lang="nolang" no>**SSHKey**</span>: prod/default




在 <span id="assignment.6.4" lang="nolang" no>Volumes</span> 分頁（綠色，請勿與黑色的混淆）下，填入以下詳細資料：

- <span id="assignment.45.2" lang="nolang" no>**Image**</span>: official-images/SLES-16.0-Minimal-VM.x86_64-Cloud-GM.qcow2
- <span id="assignment.45.3" lang="nolang" no>**Size**</span>:</span>
<div class="cred">

```txt
5
```

</div>

<span id="assignment.46" lang="zh-TW" no>然後按一下 <span id="assignment.46.1" lang="nolang" no>**Add Volume**</span> 新增磁碟區，並填寫下列詳細資訊：

- <span id="assignment.19.4" lang="nolang" no>**Name**</span>：</span>
<div class="cred">

```txt
market-data-vol
```

</div>

<span id="assignment.47" lang="nolang" no>
- **Size**:
</span>
<div class="cred">

```txt
1
```

</div>

<span id="assignment.48" lang="zh-TW" hist="vertrex-bank">現在將引擎連接到銀行的網路。</span><span id="assignment.49" lang="zh-TW" no>在 <span id="assignment.49.1" lang="nolang" no><b style="color:#30ba78;">Networks</b></span> 分頁（綠色，請勿與黑色的混淆）下：

- <span id="assignment.49.2" lang="nolang" no>**Network**</span>：<span id="assignment.49.3" lang="nolang" no><b class="highlightcopy">prod/service</b></span></span>
<div id="302" class="story">


<span id="assignment.50" lang="zh-TW" hist="vertrex-bank">這滿足了交易員對次要高速資料磁碟機的需求。在幕後，兩個磁碟會成為複寫的 <span id="assignment.2.8" lang="nolang" no>Longhorn</span> 磁碟區，即使實體磁碟在交易中途損壞，市場資料依然完好無損。</span>

</div>


<span id="assignment.51" lang="zh-TW" no>由於這是一個混合環境叢集，讓我們確保虛擬機器只在生產節點上執行。

按一下 <span id="assignment.51.1" lang="nolang" no><b style="color:#30ba78;">Node Scheduling</b></span>：<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 提供三個選項：

- <span id="assignment.51.2" lang="nolang" no>**Any available node**</span>：由 <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> 排程器選擇放置虛擬機器的位置，且**即時遷移保持啟用**
- <span id="assignment.51.3" lang="nolang" no>**Specific node**</span>：將虛擬機器釘選至單一節點（無法進行遷移）
- <span id="assignment.51.4" lang="nolang" no>**Scheduling rules**</span>：以節點標籤為基礎的親和性規則（GPU 功能、NUMA 拓撲、網路區域…）

設定生產規則：

1. 選取 <span id="assignment.51.5" lang="nolang" no>**Run virtual machine on node(s) matching scheduling rules**</span>
2. 按一下 <span id="assignment.51.6" lang="nolang" no>**Add Node Selector**</span>，然後按一下 <span id="assignment.51.7" lang="nolang" no>**Add Rule**</span>：

- <span id="assignment.51.8" lang="nolang" no>**Key**</span>：</span>
<div class="cred">

```txt
stage
```

</div>

<span id="assignment.52" lang="nolang" no>
- **Value**:
</span>
<div class="cred">

```txt
prod
```

</div>


<span id="assignment.53" lang="zh-TW" no>現在為其指派一個標籤：

前往 <span id="assignment.53.1" lang="nolang" no><b style="color:#30ba78;">Labels</b></span> 分頁（請勿與 <span id="assignment.53.2" lang="nolang" no>"Instance Labels"</span> 混淆），然後點選 <span id="assignment.53.3" lang="nolang" no>**Add Label**</span>：

- <span id="assignment.51.8" lang="nolang" no>**Key**</span>:</span>
<div class="cred">

```txt
stage
```

</div>

<span id="assignment.52" lang="nolang" no>
- **Value**:
</span>
<div class="cred">

```txt
prod
```

</div>

<span id="assignment.54" lang="zh-TW" no>這將有助於我們在日後透過自動化來管理 VM。


前往 <span id="assignment.54.1" lang="nolang" no><b style="color:#30ba78;">Advanced Options</b></span>（請勿與左側欄的 <span id="assignment.54.2" lang="nolang" no>'Advanced'</span> 混淆），然後選取 <span id="assignment.54.3" lang="nolang" no>**Cloud Configuration**</span>，以確保系統啟動時已套用所有必要設定並已安裝相關套件。

按一下 <span id="assignment.54.4" lang="nolang" no>**User Data Template**</span> 並選取 <span id="assignment.54.5" lang="nolang" no>**Create New**</span> 以定義標準範本。將其命名為：

- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>
<div class="cred">

```txt
prod
```

</div>


<span id="assignment.55" lang="zh-TW" no>在 <span id="assignment.55.1" lang="nolang" no>**User Data**</span> 輸入：

```yaml
#cloud-config
packages:
  - qemu-guest-agent
runcmd:
  - - systemctl
    - enable
    - --now
    - qemu-guest-agent.service
write_files:
  - path: /etc/issue
    content: |
      \e{red}Production\e{reset}
    append: true
ssh_authorized_keys:
  - ssh-ed25519
    AAAAC3NzaC1lZDI1NTE5AAAAIFdt8wX4G0WGg/l4uDq/LntBO7WiNyqh0+pNUzF/NfMa
```

點選 <span id="assignment.19.3" lang="nolang" no>**Create**</span>（範本方塊內）以儲存範本

由於該範本位於 <span id="assignment.55.2" lang="nolang" no><b class="highlightcopy">prod</b></span> namespace 中，且本身命名為 <span id="assignment.55.2" lang="nolang" no><b class="highlightcopy">prod</b></span>，因此它會變成 prod/prod：即正式環境標準，可隨時供每台虛擬機器使用。</span>
<div id="303" class="story">
<span id="assignment.56" lang="zh-TW" hist="vertrex-bank">交易室的防火牆團隊還有一個要求：</span>
</div>

<span id="assignment.57" lang="zh-TW" no>引擎必須在**可預測的位址**上啟動，而不是使用 DHCP 分配的任何位址。請在 <span id="assignment.57.1" lang="nolang" no>**Network Data**</span> 欄位中輸入：

```yaml
version: 2
ethernets:
  enp1s0:
    addresses:
      - 192.168.122.50/24
    gateway4: 192.168.122.1
    nameservers:
      addresses:
        - 192.168.122.1
```

Cloud-init 會在首次開機時套用兩者：<span id="assignment.57.2" lang="nolang" no><b class="highlightcopy">the-engine-01</b></span> 將在 `192.168.122.50` 上線，完全無需在部署後進行手動設定。

> [!NOTE]
> 這是 **cloud-init**，與各大主流公有雲所使用的業界標準機制相同。
> 在實際情況下，會針對此伺服器的用途提供更完整的自動化流程和專屬範本。


現在我們已完成設定，請按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span>，開始部署虛擬機器。

無需等待開機完成，請直接進行下一個任務。</span>

<div id="304" class="story">
<span id="assignment.58" lang="zh-TW" hist="vertrex-bank">排程規則可讓您將關鍵系統與其他工作負載分開，例如將交易引擎固定至低延遲節點，同時讓批次作業共用其餘節點。在此保留「任何可用節點」至關重要：這正是下一章能夠達成零停機撤離的關鍵所在。</span>

</div>

<span id="assignment.59" lang="zh-TW" hist="vertrex-bank">> [!NOTE]
> **當微秒即是金錢：**高頻交易團隊所要求的，將不僅僅是放置規則與專屬硬體。<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 可以**將專屬 CPU 核心釘選**至虛擬機器、將硬體直通給虛擬機器、使用 **SR-IOV** 進行硬體虛擬化（同時適用於網卡與 GPU），並將資料中心 GPU 切割為硬體隔離的 **MIG 分割區**，使多台虛擬機器在沒有吵鬧鄰居干擾的情況下共享單一 GPU。為虛擬機器分配專屬實體資源，換來的是**可預測且一致的延遲**。本練習僅供教學用途，並非建置高頻交易應用程式的建議做法。</span>

<span id="assignment.60" lang="zh-TW" no>> [!IMPORTANT]
> 由於此實驗環境執行於**巢狀組態**上，I/O 效能會比平常稍慢一些，且佈建過程需要幾分鐘的時間。在您的虛擬機器啟動期間，我們為您準備了一些精彩內容！請前往加碼練習（Bonus Drills），了解如何使用 CLI 與 <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> API 進行互動。<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 中的一切都是 <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> 物件，這意味著您可以透過底層的 RKE2 叢集經由 <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> API 進行管理。
> 完成後，請回到任務 3。

🖥️ 任務 3：存取 Web 主控台
=================================

監控</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.61" lang="zh-TW" no>直到虛擬機器轉換為 **Running** 狀態。


  



1. 按一下虛擬機器該列的 <span id="assignment.61.1" lang="nolang" no>**Console**</span> 按鈕以開啟 VNC 網頁主控台
2. 觀察我們可以透過此方法在沒有網路連線的情況下存取系統，**無須等待安裝完成，直接進行下一步即可**。
3. 關閉主控台視窗



🏋️ 加碼練習：看透抽象層（選做，給對命令列好奇的您）
========================================================================================

剛接觸 <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> 嗎？**歡迎直接跳過**。否則，回到</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.62" lang="zh-TW" no>，看看平台實際上為您建立了什麼：

- **黃金映像檔也是 API 物件：**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachineimages -A
```

- **VM 是一個 <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> 資源：**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachines -n prod
```

- **執行中的執行個體，包含其節點與 IP**（也就是您用於 SSH 的同一個 IP）：

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get vmi -n prod -o wide
```

- **磁碟是由 <span id="assignment.2.8" lang="nolang" no>Longhorn</span> 作為後端的一般 <span id="assignment.62.1" lang="nolang" no>PersistentVolumeClaims</span>：**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get pvc -n prod
```

您應該能在清單中認出 `market-data-vol`：<span id="assignment.62.2" lang="zh-TW" hist="vertrex-bank">以雲端原生儲存形式呈現的銀行資料磁碟</span>。

💼 為什麼這很重要？
========================

- **數天縮短為數分鐘。** 原本透過工單驅動、涉及多個團隊的佈建流程，大幅縮減為只需兩分鐘的自助式工作流程，<span id="assignment.62.3" lang="zh-TW" hist="vertrex-bank">而且是在市場危機正在發生的當下。</span>
- **由架構確保的一致性。** 黃金映像檔加上 cloud-init，意味著量化分析師請求的每個引擎在開機時都是完全一致、已設定完成並隨時就緒的。
- **不會有閒置儲存空間。** <span id="assignment.6.4" lang="nolang" no>Volumes</span> 會依需求從共用的 <span id="assignment.2.8" lang="nolang" no>Longhorn</span> 集區中劃分出來。</span>

<div id="305" class="story">

<span id="assignment.63" lang="zh-TW" hist="vertrex-bank">您透過無線電向交易室回報。*「你們的引擎已上線，資料磁碟區已掛載。」* 危機得以化解——但這一天還遠遠沒有結束。</span>

</div>

<span id="assignment.64" lang="zh-TW" no>點選 <span id="assignment.32.1" lang="nolang" no>**Check**</span> 繼續。 🌊

📚 更多資訊
===================</span>

- [Creating <span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)
- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)

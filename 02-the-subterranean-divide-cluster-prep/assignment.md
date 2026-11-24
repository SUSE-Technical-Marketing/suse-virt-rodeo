---
slug: the-subterranean-divide-cluster-prep
id: tmmoesxdhg4b
type: challenge
title: "<span id="assignment.12" lang="zh-TW" hist="vertrex-bank">🛗 第二章：地底鴻溝</span>"
teaser: "<span lang="zh-TW" hist="vertrex-bank" id="ts2">兩個硬體孤島，兩個幾乎不相往來的團隊。深入資料中心，繪製節點拓撲，並為架構中的每顆硬碟標上銀行能接受的價格。</span>"
tabs:
- id: gix6w5fqkxd6
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: duhbmh2ml3qo
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: zgpgmllqoznu
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: basic
timelimit: 2400
enhanced_loading: null
---
<span lang="zh-TW" hist="vertrex-bank" id="ts2">兩個硬體孤島，兩個幾乎不相往來的團隊。深入資料中心，繪製節點拓撲，並為架構中的每顆硬碟標上銀行能接受的價格。</span>

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
  .cred-sparkle {
    animation: cred-sparkle 0.8s ease-out;
  }
  @keyframes cred-sparkle {
    0%   { text-shadow: 0 0 2px #fff, 0 0 10px #30ba78, 0 0 20px #ffd700; }
    100% { text-shadow: none; }
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
<script>
document.querySelectorAll('.cred .my-3 > div:first-child button').forEach(function(btn){
  if (btn.dataset.sparkleBound) return;
  btn.dataset.sparkleBound = '1';
  btn.addEventListener('click', function(){
    var pre = btn.closest('.my-3').querySelector('pre');
    if (!pre) return;
    pre.classList.remove('cred-sparkle');
    void pre.offsetWidth;
    pre.classList.add('cred-sparkle');
    setTimeout(function(){ pre.classList.remove('cred-sparkle'); }, 800);
  });
});
</script>
<img class="logos" alt="Welcome!" src="../assets/02-chapter-img.png"/>

<div id="201" class="story">

<span id="assignment.13" lang="zh-TW" hist="vertrex-bank">莎拉帶領你離開安靜的高階主管辦公區，走進一部安全電梯，一路下行來到銀行的地下資料中心。當身後沉重的鋼製生物辨識門上鎖時，室溫驟降。整座機房迴盪著工業冷卻系統震耳欲聾且持續不斷的轟鳴聲。

她指向機房左側，那裡一排排流線型、密集排列的伺服器機箱正閃爍著快速跳動的藍光。「那些運作著我們的行動銀行 API，」她在風扇的噪音中大聲喊道。「純微服務架構，完全容器化且敏捷。」

接著，她指向機房右側，那裡被龐大而陳舊的伺服器機櫃所占據，散發著令人不適的熱氣。「而那些則是存放核心交易帳本的傳統單體式虛擬機。兩個完全不同的世界、兩種不同的硬體孤島、兩支甚至幾乎互不說話的工程團隊。」

你走在兩排機櫃之間，感受著截然不同的溫差。「這樣的隔閡今天就此結束，」你對她說。</span>

</div>

<span id="assignment.14" lang="zh-TW" no>## 兩個世界，單一架構

您將說明 <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 的優雅架構：透過在 **<span id="assignment.2.2" lang="nolang" no>Kubernetes</span> 基礎**上運用先進的開源技術，該平台不僅僅是*包容*虛擬機器，更將它們視為**容器生態系統的原生公民**。重量級的虛擬機器將與輕巧靈活的容器並肩運行，並由完全相同的編排引擎進行管理：

| 虛擬化世界 | <span id="assignment.14.1" lang="nolang" no>Container</span> 世界 | 統一於 <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> |
|---------------------|----------------|-------------------------------|
| Hypervisor 主機 | <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> 節點 | **由同一組節點同時運行兩者** |
| Hypervisor 管理控制台 | 容器工具 | **底層為單一平台**。<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 運行虛擬機器，Rancher Prime 統管叢集與容器 |
| SAN 儲存陣列 | <span id="assignment.2.9" lang="nolang" no>CSI</span> 磁碟區 | **<span id="assignment.2.8" lang="nolang" no>Longhorn</span> 同時為虛擬機器與 Pod 提供服務** |

最後一行正是您的起點。每個虛擬機器磁碟、每個容器的永續性磁碟區（Persistent Volume），全都建構在相同的分散式儲存架構之上，而且並非所有工作負載都需要相同的成本定價。



## 🎯 您的任務目標

1. 檢查實體節點拓撲
2. 準備專用工作空間
3. 了解 <span id="assignment.2.8" lang="nolang" no>Longhorn</span> 如何複寫您的資料
4. 為開發團隊建立具成本效益分級的儲存類別（Storage Class）



🔐 登入憑證
====================

**<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>** UI 與 <span id="assignment.2.12" lang="nolang" no>**Rancher Prime**</span> UI 使用相同的登入憑證。</span>

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


<span id="assignment.15" lang="zh-TW" no>☁️ 什麼是 <span id="assignment.2.8" lang="nolang" no>Longhorn</span>？
====================

<span id="assignment.2.8" lang="nolang" no>Longhorn</span> 是內建於 <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 中可供您使用的分散式儲存系統。它會集結位於每個節點上的原始磁碟，並將其轉化為單一共享儲存網狀架構。

預設情況下，其建立的每個磁碟區都會複寫到多個節點，因此磁碟故障或節點重新開機絕不會讓您遺失資料。無需 SAN、無需獨立的儲存團隊，一套系統即可同時適用於虛擬機器與容器。

它隨時可供您使用，但如果您想使用其他 <span id="assignment.2.9" lang="nolang" no>CSI</span>，也可以自由選用，絕無廠商鎖定。


🖥️ 任務 1：檢查實體節點拓撲
=============================================



  



前往</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.16" lang="zh-TW" no>，前往左側選單，並點選 **<span id="assignment.6.1" lang="nolang" no>Hosts</span>**。

1. 點選清單中**其中一台主機**的名稱
2. 瀏覽使用者介面並查看不同的選項，以更深入了解其運作方式。觀察原始區塊裝置是如何佈建給虛擬機器磁碟的。您在此處看到的每個磁碟都會成為 <span id="assignment.2.8" lang="nolang" no>Longhorn</span> 分散式儲存集區 <span id="assignment.16.1" lang="zh-TW" hist="vertrex-bank">將存放銀行的帳冊</span> 的一部分。</span>


<div id="203" class="story">
<span id="assignment.17" lang="zh-TW" hist="vertrex-bank">銀行在成長，這套架構亦然。空間不足不再是複雜的升級問題。只需將新節點上架，將其原始磁碟加入集區，<span id="assignment.2.8" lang="nolang" no>Longhorn</span> 便會自動在擴展後的架構中重新平衡複本，完全無需停機，也不必在週末進行資料遷移。儲存容量的擴充方式就如同運算資源：循序漸進、隨需擴展。</span>
</div>


<span id="assignment.18" lang="zh-TW" no>🏗️ 任務 2：準備專用工作區
========================================






此平台將工作負載隔離在**命名空間**中，這是同一個叢集上獨立且可控管的工作區。

在</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.19" lang="zh-TW" no>，從左側選單中選取 <span id="assignment.19.1" lang="nolang" no>**Namespaces**</span>。您會注意到 prod 已經列在清單中。<span id="assignment.19.2" lang="zh-TW" hist="vertrex-bank">平台團隊在你抵達之前就已將其佈建完成，而這裡將是該銀行正式環境工作負載運行的地方。</span>

現在建立其用於開發的對應項目：

1. 按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span>
2. 將 <span id="assignment.19.4" lang="nolang" no>**Name**</span> 設定為：</span>

<div class="cred">

```txt
dev
```

</div>

<span id="assignment.20" lang="zh-TW" no>3. 將 <span id="assignment.20.1" lang="nolang" no>**Description**</span> 設定為：</span>

<div class="cred">

```txt
VMs from dev
```

</div>


<span id="assignment.21" lang="zh-TW" no>4. 按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span>

開發人員工作區現已準備就緒，未來我們可以為其指派配額、原則與存取控制。

💾 任務 3：了解 <span id="assignment.2.8" lang="nolang" no>Longhorn</span> 如何複寫您的資料
========================================================






讓我們來看看儲存後端是*如何*維持狀況良好的。<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 提供給 VM 或 pod 的每個磁碟都是 **<span id="assignment.2.8" lang="nolang" no>Longhorn</span> 磁碟區**，而每個 <span id="assignment.2.8" lang="nolang" no>Longhorn</span> 磁碟區都是由 <span id="assignment.21.1" lang="nolang" no>**StorageClass**</span> 建立的：這是一項決定了（除了其他項目外）在任何指定時間您的資料會存在多少份複本的原則。

在</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.22" lang="zh-TW" no>, 前往 <span id="assignment.22.1" lang="nolang" no>**Advanced > Storage Classes**</span> 並點選 harvester-longhorn。

請注意 <span id="assignment.22.2" lang="nolang" no>**Number Of Replicas**</span> 欄位：其設定為 **3**。從此類別建立的每個磁碟區都會獲得三個完整複本，並分散在三個不同的節點上。</span>

<div id="204" class="story">
<span id="assignment.23" lang="zh-TW" hist="vertrex-bank">這對交易帳本來說確實如此——即便失去一個節點，甚至在寫入中途損壞磁碟，資料依然完好無損。</span>
</div>

<span id="assignment.24" lang="zh-TW" no>讓我們深入底層，看看 <span id="assignment.2.8" lang="nolang" no>Longhorn</span> 是如何儲存資料的：

1. 前往</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.25" lang="zh-TW" no>並透過 SSH 連線至其中一台 <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 主機：
```bash,run
rodeo ssh harvester1
```
2. 檢查 <span id="assignment.25.1" lang="nolang" no>harvester1</span> 節點上的 <span id="assignment.2.8" lang="nolang" no>Longhorn</span> 資料夾：您會看到一些資料夾和檔案：
```bash,run
ls /var/lib/harvester/defaultdisk
```
3. 在 replicas 資料夾內，此節點持有的每個磁碟區複本都會有一個對應的資料夾：
```bash,wrap,run
ls /var/lib/harvester/defaultdisk/replicas/
```
4. 輸入 exit 離開主機：
```bash,run
exit
```

> [!NOTE]
> 三個複本意味著三倍的磁碟空間佔用。對於正式環境的花費來說，這是合理的取捨。但對於開發人員在週五前就會刪除的拋棄式測試虛擬機器而言，這十分浪費。複本數量是一項**策略**，而非物理法則，且策略可以針對個別工作負載進行調整。

🧅 任務 4：為開發團隊建立成本分層的儲存類別
=====================================================================



  



開發團隊的沙箱環境並不需要正式環境等級的複寫，他們需要的是低成本且快速的迭代。<span id="assignment.25.2" lang="zh-TW" hist="vertrex-bank">你會提供給他們專屬的儲存層級，定價反映其真實本質：用完即丟。</span>

在</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.26" lang="zh-TW" no>，在 <span id="assignment.22.1" lang="nolang" no>**Advanced > Storage Classes**</span> 下：

1. 按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span>
2. 將 <span id="assignment.19.4" lang="nolang" no>**Name**</span> 設定為：</span>

<div class="cred">

```txt
harvester-longhorn-1rep
```

</div>


3. Set <span id="assignment.22.2" lang="nolang" no>**Number Of Replicas**</span> to:


<div class="cred">

```txt
1
```

</div>

4. Set <span id="assignment.27" lang="nolang" no>**Node Selector**</span> to: <span id="assignment.28" lang="nolang" no>**dev**</span> so that it is only scheduled on dev nodes.


5. Click <span id="assignment.19.3" lang="nolang" no>**Create**</span>

Two StorageClasses sit side by side in the list: `harvester-longhorn` (3 replicas, production) and <b class="highlightcopy">harvester-longhorn-1rep</b> (1 replica for dev sandboxes, at a third of the disk cost). <span id="assignment.29" lang="zh-TW" hist="vertrex-bank">在接下來的章節中，開發團隊每次啟動拋棄式虛擬機時，都會選用這個層級。</span>

> [!NOTE]
> One replica means **zero redundancy**, lose that single node and the volume is gone. That is an acceptable risk for a sandbox nobody depends on overnight, and a very deliberate trade-off you are making on the record, not an accident. Storage classes can also encode disk tags to steer workloads to specific hardware, production on fast NVMe, development on cheaper spindles.

🏋️ Bonus Drills: for the command-line curious (optional)
==========================================================

<div style='align: middle; margin: 15px;'>
  <img class="animatedgif" src="../assets/chapter2_video5.gif"/>
</div>


New to <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Skip ahead freely.** If you are curious, everything you just did in the UI is also visible through the <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> API, open the </span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.30" lang="zh-TW" no>- **以 API 物件形式檢視您的 UI 儲存類別**：工作區以及這兩個儲存層：

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get namespace dev -o wide; kubectl --kubeconfig .rodeo/harvester-kubeconfig get storageclasses;
```

- **為新的工作區加上標籤**，以便未來的自動化流程能輕鬆鎖定它：

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig label namespace dev stage=dev
```

💼 為什麼這很重要？
==============================================

- **孤島不復存在。** VM 與容器共享節點、儲存以及同一個維運團隊。資料中心的「冷熱隔閡」已然消失。
- **沒有重新培訓的斷崖。** 容器團隊的 <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> 技能現在也能用來管理 VM 資產；VM 團隊則能使用由 <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> API 支援的熟悉點選式 UI。
- **命名空間帶來治理能力。** 金融工作負載運行於 `prod` 中，擁有專屬的配額、政策與存取控制。稽核人員一定會對此讚不絕口。
- **儲存現在有了價目表。** 複寫就像可微調的旋鈕，而非固定的預設值。生產環境資料保留三份複本，因為這是必須的；拋棄式沙盒只保留一份，因為其成本不應超出必要範圍。</span>

<div id="202" class="story">

<span id="assignment.31" lang="zh-TW" hist="vertrex-bank">莎拉從你肩頭看著，新的工作區與兩個儲存層接連出現在儀表板上。她的臉上浮現出一抹淺淺的微笑。*「基礎很穩固。我們開始工作吧。」*</span>

</div>

<span id="assignment.32" lang="zh-TW" no>點選 <span id="assignment.32.1" lang="nolang" no>**Check**</span> 以繼續。⚡


📚 更多資訊
===================</span>

- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Storage: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/storage/overview.html)

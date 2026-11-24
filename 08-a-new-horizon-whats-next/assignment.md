---
slug: a-new-horizon-whats-next
id: qzmycpm7jtwa
type: challenge
title: "<span id="assignment.158" lang="zh-TW" no>🌅 第八章：嶄新的地平線</span>"
teaser: <span id="assignment.159" lang="zh-TW" hist="vertrex-bank">這家銀行完全在 <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 上運行。
  繞場慶祝一番，回顧你所掌握的一切，並規劃你的新技能可以帶領你自己的資料中心走向何方。</span>
tabs:
- id: jw4tji5y1jbv
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: gjstzqppnxay
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: ohjx4w0pk1mb
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: basic
timelimit: 1800
enhanced_loading: null
---
<span id="assignment.160" lang="zh-TW" no>🌅 第八章：嶄新的地平線
============================</span>
<style type="text/css">
  * {
    font-family: suse;
    src: url('https://fonts.google.com/specimen/SUSE');
  }
  .suse { color: #30ba78; }
  .virt { color: #30ba78; }
  .bank { color: #d4af37; }
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


</style>

<img class="logos" alt="Welcome!" src="../assets/chapter-img-a_new_horizon.png"/>

<div id="901" class="story">

<span id="assignment.161" lang="zh-TW" hist="vertrex-bank">塵埃終於落定。資料中心一片寧靜，沐浴在完美協同運作的 <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 節點所散發的柔和綠光之中。

Vertex 信託銀行不再受過去的枷鎖束縛。如今，它完全運作在精簡、高效能的雲端原生虛擬化技術堆疊之上。

莎拉站在你身旁，看著主螢幕上的整合儀表板。*「我原本以為這不可能辦到，」*她難以置信地搖了搖頭承認道。*「我們居然在完全相同的底層架構上，同時運行容器化微服務與單體式帳本。我們的儲存是分散式的，網路是軟體定義的，而我們的授權成本更是剛剛直線暴跌。」*

她轉向你並伸出手。*「謝謝你。你拯救的不僅僅是我們的基礎架構——你拯救了整間銀行。」*</span>

</div>

<span id="assignment.162" lang="zh-TW" no>## 🏆 您的事蹟

在此期間，您克服了難以想像的重重難關：

| 章節 | 危機 | 您所掌握的技能 |
|:--------|:-------|:-------------------|
| 🏦 抵達現場 | 瀕臨滅頂的傳統資料中心 | 檢視平台儀表板、<span id="assignment.2.8" lang="nolang" no>Longhorn</span> 儲存空間與 Rancher Prime |
| 🛗 地底隔閡 | 兩個各自為政的硬體孤島 | 在單一 <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> 架構上整合虛擬機與容器 |
| ⚡ 閃電崩盤 | 市場崩盤危機 | 透過映像檔、磁碟區與 cloud-init 在數分鐘內部署虛擬機 |
| 🌊 浪潮來襲 | 淹水的伺服器機架 | 零停機即時移轉與一鍵節點撤離 |
| 🕵️ 隱形入侵者 | 橫向攻擊路徑 | 軟體定義 VLAN 與隔離的 SDN 子網路 |
| ⏪ 難以挽回的失誤 | 一筆價值一億美元的資料遭誤刪 | 快照、暫存複本、儲存分層與排程叢集外備份 |
| 🤠 狂奔之災 | 運算資源匱乏 | 黃金 VM 範本，依需求迅速批量建立完全相同的機群 |</span>


<div id="902" class="story">

<span id="assignment.163" lang="zh-TW" hist="vertrex-bank">您在 Vertex Trust Bank 的工作已告完成——但數位疆域廣闊且持續演進。永遠都有新的架構等待設計，也永遠都有新的系統有待現代化。</span>

</div>


<span id="assignment.164" lang="zh-TW" no>🔐 登入憑證
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



<span id="assignment.165" lang="zh-TW" no>🧭 勝利巡禮：實驗室仍屬於您
=======================================

實驗室環境將維持啟用狀態，直到您的計時結束為止。歡迎隨意深入探索儀表板，並對您所建置的基礎架構進行實驗。以下是一些想法：

- **為您打造的帝國做最後的盤點。** 瀏覽</span>[button label="SUSE Virtualization UI" variant="success"](tab-0)<span id="assignment.166" lang="zh-TW" no>：<span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span> 頁面、您所定義的 **Networks**、**Templates** 藍圖，以及 **Backup & Snapshot** 歷史紀錄：本週的每場危機都在這裡留下了印記。

- **設計您自己的危機。**從頭開始建立一台新的 VM：挑選映像檔、設定規格大小、進行 cloud-init 配置、建立快照、執行即時遷移。這次沒有操作指示。您已經知道該怎麼做了。

- **給對命令列好奇的人（選填）：**API 任您探索：

```bash,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get vm -A && kubectl  --kubeconfig .rodeo/harvester-kubeconfig get network-attachment-definitions -A && kubectl --kubeconfig .rodeo/harvester-kubeconfig get VirtualMachineBackup -A
```</span>


<span id="assignment.167" lang="zh-TW" no>🚀 接下來有何展望？
===============================

- 📖 研讀 [SUSE 虛擬化說明文件](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html) 中的深度技術架構，持續精進您的專業技能。

- 🐮 透過 [<span id="assignment.2.15" lang="nolang" no>SUSE Rancher Prime</span>](https://documentation.suse.com/cloudnative/rancher-manager/latest/en/rancher-manager.html) 學習如何**大規模管理這些叢集艦隊**（透過單一 Rancher Prime 管理每個分支資料中心的所有 <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 叢集）。

- 🧪 在家中自行重現：<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 為開源軟體。取得 ISO 檔，安裝在任何閒置的 x86 主機上，即可執行您專屬的虛擬機器。

- 🤝 在這條路上您絕不孤單：SUSE 客戶始終將 <span id="assignment.167.1" lang="nolang" no>**SUSE Support**</span> 評為業界頂尖，且客戶回饋會直接形塑產品的演進方向。與 SUSE 合作，意味著您擁有一席參與決策的席位，而不僅僅是佇列中的一張支援工單。這就是開源的與眾不同之處。

- 💬 請洽詢您的 SUSE 代表，了解若將這個轉型歷程套用至您機房最幽暗角落裡的**老舊叢集**，將會呈現出怎樣的嶄新樣貌。</span>

<div id="903" class="story">

<span id="assignment.168" lang="zh-TW" hist="vertrex-bank">能與您共事絕對是我的莫大榮幸！

**祝遷移順利！** 🎉</span>

</div>

<span id="assignment.169" lang="zh-TW" no>📚 更多資訊
===================

- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>：概觀](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [建立 <span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)
- [即時移轉](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/live-migration.html)
- [備份與還原](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/backup-restore.html)
- [叢集網路](https://documentation.suse.com/cloudnative/virtualization/latest/en/networking/cluster-network.html)</span>

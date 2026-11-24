---
slug: the-rising-tide-live-migration
id: xjv2r0tfyztq
type: challenge
title: "<span id="assignment.65" lang="zh-TW" hist="vertrex-bank">🌊 第四章：漲潮</span>"
teaser: <span id="assignment.66" lang="zh-TW" hist="vertrex-bank">冷卻液外洩正在淹沒託管支付閘道的機櫃。在硬體短路前執行零停機即時遷移，同時確保交易持續進行。</span>
tabs:
- id: fpgxlmifoynn
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: dltxk4yfrhwa
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: js6k1cai9uqc
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: intermediate
timelimit: 2400
enhanced_loading: null
---
<span id="assignment.67" lang="zh-TW" hist="vertrex-bank">🌊 第四章：漲潮
==============================</span>
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
    padding: 4px 8px;
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
    max-height: 3vh;
    max-width: 3vh;
    margin: 0;
    padding: 0;
    display: inline-block;
  }

</style>

<img class="logos" alt="Welcome!" src="../assets/04-chapter-img.png"/>

<div id="401" class="story">

<span id="assignment.68" lang="zh-TW" hist="vertrex-bank">交易大廳事件所帶來的腎上腺素尚未完全自體內退去，一聲低沉的金屬悲鳴便已在資料中心的牆體間迴盪。你和莎拉同時轉向 **4 號機櫃**。頭頂上方的主冷卻液閥門破裂，一股經過化學處理的冰冷水流正源源不絕地直接傾瀉在承載著銀行主要**支付閘道**的實體伺服器機箱上。

*「如果那台伺服器短路，閘道就會中斷，」* 莎拉看著逐漸積聚的水灘，聲音中透出難以掩飾的恐慌。*「如果閘道中斷，Vertex 信託銀行的每一筆信用卡交易都會失敗。到了早上，我們就得面臨聯邦監管機構的調查。」*

*「我們不會讓它中斷的，」* 你回答，雙手飛快地在鍵盤上敲擊。</span>

</div>

<span id="assignment.69" lang="zh-TW" no>你無法透過關機來搬遷這台機器；交易串流極為關鍵，每秒都在處理數千個請求。你必須在**零停機**的情況下執行**即時移轉**，將運行中的虛擬機器（包含記憶體與所有狀態）移至不同的實體節點。

但首先，為確保緊急移轉能獲得最大頻寬，你決定先暫停附近一台非關鍵的批次處理伺服器。



## 🎯 你的任務目標

1. 暫停非關鍵工作負載以釋出資源
2. 建立服務活動訊號
3. 執行即時移轉
4. 監控無縫移轉過程
5. 恢復正常運作
6. 將受損的機架移交給維修小組



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



<span id="assignment.72" lang="zh-TW" no>⏸️ 任務 1：暫停非關鍵工作負載以釋放資源
===========================================================


  



在</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.73" lang="zh-TW" no>，前往 <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>：

1. 找出名為下列名稱的虛擬機器：</span>

<div class="cred">

```txt
daily-batch-processor
```

</div>

<span id="assignment.74" lang="zh-TW" no>2. 點選其資料列右側的 
3. 選取 <span id="assignment.74.1" lang="nolang" no>**Pause**</span>，並在出現確認提示後點選 <span id="assignment.74.2" lang="nolang" no>**Apply**</span>。
4. 等候其狀態變更為 <span id="assignment.74.3" lang="nolang" no>**Paused**</span>

這會暫停其 CPU 週期，將最大的硬體資源專用於您的緊急作業。

> [!NOTE]
> 這其實並非必要，我們已經為即時移轉流量設定了專用網路，此處僅供教學目的</span>



<span id="assignment.75" lang="zh-TW" no>📡 任務 2：建立服務心跳
========================================


  


切換至</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.76" lang="zh-TW" no>. 您需要一個持續的心跳監控器，以證明在撤離過程中網路連線保持不中斷。

從 <span id="assignment.76.1" lang="nolang" no><b class="highlightcopy">webserver-prod</b></span> 啟動心跳監控器：

```bash,run
ssh -o StrictHostKeyChecking=accept-new  sles@[[ Instruqt-Var key="PAYMENT_GATEWAY_IP" hostname="kvm-host" ]] 'ping 192.168.122.1'

```

> [!IMPORTANT]
> 讓 ping 在終端機中持續執行。**請勿停止。**這串不斷捲動的回應就是零停機時間的證明。將焦點切換回 <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> UI。</span>

<span id="assignment.77" lang="zh-TW" no>🚚 任務 3：執行即時移轉
=====================================


  


在</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.78" lang="zh-TW" no>，前往 **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>** 並找出下列執行個體：</span>

<div class="cred">

```txt
webserver-prod
```

</div>

<span id="assignment.79" lang="zh-TW" no>1. 查看 <span id="assignment.79.1" lang="nolang" no>**Node**</span> 欄位並**記下**閘道正在哪個節點上執行：你會需要它已移動的證明
2. 點擊該列最右側的 
3. 從快顯功能表中選取 <span id="assignment.79.2" lang="nolang" no>**Migrate**</span>
4. 從下拉式清單中選擇另一個安全的目標節點
5. 點擊 <span id="assignment.74.2" lang="nolang" no>**Apply**</span>

在幕後，<span id="assignment.2.3" lang="nolang" no>KubeVirt</span> 會透過網路將 VM 的即時記憶體分頁複製到目標節點，持續追蹤並重新複製忙碌的閘道在傳輸過程中所修改的任何分頁，直到它能在幾分之一秒內凍結、切換並在新節點上恢復執行。</span>

<span id="assignment.80" lang="zh-TW" no>👀 任務 4：監控無縫轉移
========================================


  


立即切換回</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.81" lang="zh-TW" no>分頁並觀察 ping 序列。</span>

<div id="402" class="story">

<span id="assignment.82" lang="zh-TW" hist="vertrex-bank">當 <span id="ch1.intro1.1" lang="nolang" no>hypervisor</span> 協調龐大的記憶體透過網路傳輸時，你屏住了呼吸。Ping 訊息持續在螢幕上向下捲動，**完全未曾中斷**。就在第 4 號機架中因進水受損的機箱開始迸出火花之際，虛擬機器已無縫出現在新的實體節點上。</span>

</div>

<span id="assignment.83" lang="zh-TW" no>按下 `Ctrl+C` 即可終止 ping。</span>

<div id="403" class="story">
<span id="assignment.84" lang="zh-TW" hist="vertrex-bank">你重重地吐了一口氣。交易流程撐過來了。</span>
</div>


<span id="assignment.85" lang="zh-TW" no>嚴格來說，*確實*存在交接的時刻：一旦記憶體複製收斂，VM 就會在最後一瞬間凍結，同時將執行切換至新節點，這是一種微中斷。在規格配置妥當的基礎設施上，這完全不會被察覺；即使在這個運行著虛擬化*之中*的虛擬化*之中*的虛擬化的實驗室裡，你最多也只會發現 ping 的延遲時間略微增加。

回到</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.86" lang="zh-TW" no>, webserver-prod 的 <span id="assignment.79.1" lang="nolang" no>**Node**</span> 欄位現在顯示了與您寫下的**不同的節點**。</span><span id="assignment.87" lang="zh-TW" hist="vertrex-bank">該閘道器在實體上搬移了，而其客戶卻從未察覺。</span>

<div id="404" class="story">
<span id="assignment.88" lang="zh-TW" hist="vertrex-bank">現在提供莎拉將轉交給監管機構的證據——客體系統的運作時間計數器從未重設，這意味著作業系統從未停止運作：</span>
</div>

```bash,wrap,run
ssh -o StrictHostKeyChecking=accept-new  sles@[[ Instruqt-Var key="PAYMENT_GATEWAY_IP" hostname="kvm-host" ]] "hostname && uptime"
```

<span id="assignment.89" lang="zh-TW" no>▶️ 任務 5：恢復正常運作
===================================


  


返回至</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.90" lang="zh-TW" no>. 找出您稍早暫停的虛擬機器：</span>

<div class="cred">

```txt
daily-batch-processor
```

</div>

<span id="assignment.91" lang="zh-TW" no>1. 按一下其資料列上的 
2. 選取 <span id="assignment.91.1" lang="nolang" no>**Unpause**</span> 以允許非關鍵工作恢復執行

🛠️ 任務 6：將損壞的機架交給維修小組
====================================================</span>


<div id="405" class="story">
<span id="assignment.92" lang="zh-TW" hist="vertrex-bank">閘道安全無虞——但進水受損的節點仍在滴水，上面可能還有較小的工作負載在運行。在地面積水不斷蔓延之際，你總不可能一個個去遷移它們。讓平台來處理吧。</span>
</div>


<span id="assignment.93" lang="zh-TW" no>在</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.94" lang="zh-TW" no>，前往 <span id="assignment.94.1" lang="nolang" no>**Hosts**</span>：

1. 找出在遷移**前**執行 webserver-prod 的節點，也就是您寫下的那個。</span>

<i id="406" class="story"><span id="assignment.95" lang="zh-TW" hist="vertrex-bank">那是那台泡水機。</span></i>

<span id="assignment.96" lang="zh-TW" no>2. 按一下該列上的 ，並選取 <span id="assignment.96.1" lang="nolang" no>**Enable Maintenance Mode**</span>，然後選取 <span id="assignment.96.2" lang="nolang" no>confirm</span>

現在查看 **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>** 頁面：仍留在受損節點上的每部 VM 都會**自動**即時移轉離開該節點。平台會挑選狀況良好的目標節點，逐一搬移工作負載，並清空該節點。不需要試算表，不需要手動挑選目標，也不會有被遺漏的 VM。

> [!NOTE]
> 在此實驗室環境中，這可能需要一些時間。

當節點顯示 <span id="assignment.96.3" lang="nolang" no>**Maintenance**</span> 且其 VM 數量歸零時，（虛擬）維修人員便會更換（虛擬）冷卻閥。讓節點重新上線提供服務：

3. 再次按一下該列上的 ，並選取 <span id="assignment.96.4" lang="nolang" no>**Uncordon**</span>，然後選取 <span id="assignment.96.5" lang="nolang" no>**Disable Maintenance Mode**</span>

該節點重新加入架構網狀網路，準備好再次接收工作負載。

> [!NOTE]
> 同樣的智慧機制在另一個方向也同樣有效：每次建立新的 VM 時，排程器都會將其放置在負載最輕的合適節點上，使叢集自然保持平衡，不需要人工大玩俄羅斯方塊。在建立時的自動配置與撤離時的自動疏散之間，人類只需決定要執行*什麼*；平台則會決定要在*哪裡*執行。</span>

<span id="assignment.97" lang="zh-TW" no>🏋️ 加碼練習：遷移追蹤紀錄（選修，給對命令列好奇的人）
======================================================================================


  


剛接觸 <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> 嗎？**請隨意跳過。**否則：每個遷移本身都是一個 <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> 物件，這代表它是可被稽核的。在</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.98" lang="zh-TW" no>- **查看遷移記錄**（移動的對象、時間、來源與目的地）：

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachineinstancemigrations -A
```

- **檢查已完成遷移的詳細資訊：**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig describe virtualmachineinstancemigrations -A | grep -A 10 "Status"
```

- **預先思考：**如果*節點*在任何人來得及遷移之前毫無預警地故障，會發生什麼事？檢查每個 VM 的執行策略：<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 可以自動從故障的主機重新排程 VM：

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get vm -A -o custom-columns=NAME:.metadata.name,RUNSTRATEGY:.spec.runStrategy
```

> [!NOTE]
> **不只是運算資源：**相同的零停機概念也適用於*磁碟*。<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 支援**就地儲存即時遷移**（在不停止 VM 的情況下，於儲存後端之間移動運行中 VM 的磁碟區，例如從 <span id="assignment.2.8" lang="nolang" no>Longhorn</span> 移動至外部 <span id="assignment.2.9" lang="nolang" no>CSI</span> 陣列）。今晚撤離運算資源，下季撤離儲存資源，而閘道器對這兩者皆毫無所覺。</span>

<span id="assignment.99" lang="zh-TW" no>💼 為什麼這很重要？
==============================================

- **硬體故障不再等於服務中斷。**無論是冷卻液外洩、韌體更新還是主機重新開機，在服務持續運作的同時，工作負載能直接平順移轉至狀況良好的節點。
- **告別深夜維護時段的計畫性維護。**只要按一下**維護模式**，即可自動排空整個節點。例行修補可以在下午 2 點進行，而不必等到凌晨 2 點，也再也不需要用試算表記錄哪台 VM 位於何處。
- **監管機構看得懂的稽核軌跡。**每一次移轉都是記錄在案的 API 物件，不再需要透過主控台螢幕截圖來拼湊還原事發經過。

按一下**檢查**以繼續。 🕵️

📚 更多資訊
===================</span>

- [Live Migration](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/live-migration.html)

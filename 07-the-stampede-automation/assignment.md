---
slug: the-stampede-automation
id: euwnv5ojhvfl
type: challenge
title: "<span id="assignment.138" lang="zh-TW" no>🤠 第七章：狂奔</span>"
teaser: <span id="assignment.139" lang="zh-TW" hist="vertrex-bank">市場全面暴跌，量化團隊需要立刻將運算機群從三個節點擴充至五個。打造黃金 VM 範本，並依需求快速複製出完全相同的機器。</span>
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
<span id="assignment.140" lang="zh-TW" no>🤠 第七章：狂奔
===========================</span>
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

<img class="logos" alt="Welcome!" src="../assets/07-chapter-img.png"/>

<div id="701" class="story">

<span id="assignment.141" lang="zh-TW" hist="vertrex-bank">全球利率驟然劇變，讓金融市場陷入一片混亂的狂潮之中。Vertex Trust Bank 的風險分析演算法頻頻告急，急需更多運算能力來處理排山倒海而來的劇烈市場波動資料。

*「光靠一台運算引擎已經不夠用了！」* **量化主管**揮舞著列印出來的報告，隔著辦公室大喊。*「我需要立刻部署五台一模一樣的引擎，否則我們就等於閉著眼睛衝進這場市場崩盤之中！」*

手動一台接著一台、一個畫面接著一個畫面地建立五台機器，只會招致您現在絕對承受不起的後果：這裡打錯了記憶體大小，那裡遺漏了網路設定。這就是高壓之下的設定漂移——而在這個當下，人為失誤**每秒**都會造成數百萬美元的損失。

您活動了一下指關節。銀行現在需要的，是一份**黃金藍圖**：只需定義一次完美的機器規格，就能依需求快速複製出完全相同的副本。</span>

</div>

<span id="assignment.142" lang="zh-TW" no><span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 正好具備這項功能：**VM 範本**。範本將 CPU、記憶體、磁碟、網路與 cloud-init 整合至單一具備版本控制的物件中。結合**多執行個體建立**功能，只需按一下，一張藍圖就能化為整支機群。



## 🎯 您的任務目標

1. 打造黃金範本
2. 在壓力下擴展機群
3. 撤除機群



🔐 登入憑證
====================

<span id="assignment.69.1" lang="nolang" no>**SUSE Virtualization**</span> UI 與 **Rancher Prime** UI 使用相同的登入憑證。</span>

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



<span id="assignment.143" lang="zh-TW" no>📜 任務 1：打造黃金範本
====================================


  


您需要一個能加速虛擬機器部署並將其標準化的範本。
在</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.144" lang="zh-TW" no>前往 <span id="assignment.144.1" lang="nolang" no>**Advanced > Templates**</span> 並點選 <span id="assignment.19.3" lang="nolang" no>**Create**</span>，然後填寫以下詳細資訊：

- <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: prod
- <span id="assignment.144.2" lang="nolang" no>**Template Name**</span>:</span>

<div class="cred">

```txt
prod-basic
```

</div>

<span id="assignment.145" lang="zh-TW" no>我們需要盡可能減少資源使用量，且所有虛擬機器都應可使用受到安全保護的正式環境 SSH 金鑰連線。

- Basics:
  - <span id="assignment.42.1" lang="nolang" no>**CPU**</span>: 1
  - <span id="assignment.145.1" lang="nolang" no>**Memory**</span>: 1
  - <span id="assignment.45.1" lang="nolang" no>**SSHKey**</span>: prod/default

我們預設的基礎作業系統是 SLES 16。

- <span id="assignment.6.4" lang="nolang" no>Volumes</span>:
  - <span id="assignment.45.2" lang="nolang" no>**Image**</span>: official-images/SLES-16.0-Minimal-VM.x86_64-Cloud-GM.qcow2
  - <span id="assignment.45.3" lang="nolang" no>**Size**</span>: 5

我們希望生產伺服器在生產服務網路上提供其服務。

- <span id="assignment.49.1" lang="nolang" no>Networks</span>:
  - <span id="assignment.49.2" lang="nolang" no>**Network**</span>: prod/service

所有生產虛擬機器應僅在生產就緒的主機上執行。

- <span id="assignment.51.1" lang="nolang" no>Node Scheduling</span>:
  1. 選取 <span id="assignment.51.5" lang="nolang" no>**Run virtual machine on node(s) matching scheduling rules**</span>
  2. 按一下 <span id="assignment.51.6" lang="nolang" no>**Add Node Selector**</span>，然後按一下 <span id="assignment.51.7" lang="nolang" no>**Add Rule**</span>：


- <span id="assignment.51.8" lang="nolang" no>**Key**</span>:</span>

<div class="cred">

```txt
stage
```

</div>

<span id="assignment.52" lang="zh-TW" no>- **Value**:</span>

<div class="cred">

```txt
prod
```

</div>


<span id="assignment.146" lang="zh-TW" no>我們希望虛擬機器能夠被正確標記：

- <span id="assignment.53.1" lang="nolang" no>Labels</span>:
  - 點選 <span id="assignment.53.3" lang="nolang" no>**Add Label**</span>:


- <span id="assignment.51.8" lang="nolang" no>**Key**</span>:</span>
<div class="cred">

```txt
stage
```

</div>

<span id="assignment.52" lang="zh-TW" no>- **Value**:</span>
<div class="cred">

```txt
prod
```

</div>


<span id="assignment.147" lang="zh-TW" no>最後，我們希望所有正式環境機器都能以一組套件與設定進行標準化：

- <span id="assignment.54.1" lang="nolang" no>Advanced Options</span>:
  - <span id="assignment.54.4" lang="nolang" no>**User Data Template**</span>: prod/prod

若要完成，請按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span>。

您能想像每次都要填寫所有這些詳細資訊嗎？大家一定會受不了而放棄，環境中也會充斥著各種不一致，而不一致更會讓後續的自動化難上加難。


> [!NOTE]
> 範本具備**版本控制**功能。如果您日後編輯範本，系統會建立新版本，而根據舊版本建置的機器仍會保留其歷程關聯：完整記錄從何種藍圖部署了哪些內容的稽核軌跡，這正是法規監管機構所樂見的。


📈 任務 2：在壓力下擴展機群
=========================================

因為範本已經建立，只需按幾下即可部署多部伺服器。


  


在</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.148" lang="zh-TW" no>前往 **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>** 並點選 <span id="assignment.19.3" lang="nolang" no>**Create**</span>，然後填寫以下詳細資料：

1. 選取 <span id="assignment.148.1" lang="nolang" no>**Multiple Instance**</span>
2. 將 <span id="assignment.39.3" lang="nolang" no>**Namespace**</span> 設定為 prod
3. 將 <span id="assignment.148.2" lang="nolang" no>**Name Prefix**</span> 設定為：</span>

<div class="cred">

```txt
appcluster
```

</div>


<span id="assignment.149" lang="zh-TW" no>4. 將 <span id="assignment.149.1" lang="nolang" no>**Count**</span> 設定為 2
5. 勾選 <span id="assignment.149.2" lang="nolang" no>**Use VM Template**</span> 並將 <span id="assignment.149.3" lang="nolang" no>**Template**</span> 設定為 prod/prod-basic
6. 按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span></span>




<div id="702" class="story">

<span id="assignment.150" lang="zh-TW" hist="vertrex-bank">風險分析團隊開始將資料輸入擴充後的機群，及時穩定了該銀行的市場地位。</span>

</div>


<span id="assignment.151" lang="zh-TW" no>🧹 任務 3：撤除機群
===============================</span>

<div id="703" class="story">

<span id="assignment.152" lang="zh-TW" hist="vertrex-bank">市場的狂潮逐漸平息。虛擬機器閒置著，等待著下一波浪潮——但它會在今天到來嗎？明天？還是下個月？對這些高貴的伺服器而言，等待比埋頭處理繁重的數字運算還要痛苦。</span>

</div>

<span id="assignment.153" lang="zh-TW" no>您不再需要這麼多虛擬機器，一次將它們全部刪除（就算它們仍在啟動中也別擔心）。


  



在</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.154" lang="zh-TW" no>前往 <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span> 區段：

1. 勾選您所建立的所有新虛擬機器旁的 <span id="assignment.154.1" lang="nolang" no>**checkboxes**</span>
2. 按一下 <span id="assignment.137.2" lang="nolang" no>**Delete**</span>，勾選 <span id="assignment.154.2" lang="nolang" no>**Delete All**</span>，然後按一下 <span id="assignment.154.3" lang="nolang" no>**Delete**
</span></span>

<div id="704" class="story">

<span id="assignment.155" lang="zh-TW" hist="vertrex-bank">這些高貴虛擬機器的苦難已經結束了。你看見那火焰了嗎，我的孩子？現在它們在英靈殿安息了。</span>

</div>




<span id="assignment.156" lang="zh-TW" no>🏋️ 加碼練習：給對命令列好奇的您（選做）
==========================================================

剛接觸 <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> 嗎？**歡迎直接跳過**。否則，請在</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.157" lang="zh-TW" no>中證明 UI、機群與 API 三者完全一致：

- **將範本視為 API 物件進行檢查**：範本及其版本也都是資源：

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplates,virtualmachinetemplateversions -n prod
```

- **以 YAML 格式擷取範本定義**：

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplates -n prod prod-basic -o yaml > template_prod-basic.yaml
template_version_name=`kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplateversions -n prod -o name |grep '/prod-basic-'`
kubectl --kubeconfig .rodeo/harvester-kubeconfig get -n prod ${template_version_name} -o yaml >> template_prod-basic.yaml
```

您可以檢視 `template_prod-basic.yaml` 檔案：


```bash,wrap,run
less template_prod-basic.yaml
```


它包含的定義與您在任務 2 中用來建立範本的定義相似。



💼 為什麼這很重要？
==============================================

- **自有硬體上的彈性。** <span id="assignment.157.1" lang="zh-TW" hist="vertrex-bank">在銀行自有的資料中心做到雲端般的水平擴充（與縮減）：沒有資料存放地點的法規疑慮，也沒有對外傳輸流量的帳單。</span>
- **透過工程設計消除人為錯誤。** 機器皆源自具備版本控制的黃金藍圖，而非憑記憶與手動操作：凌晨兩點絕不會發生組態漂移。
- **全生命週期經濟效益。** 除役只需勾選再按一下，因此暫時性的容量絕不會變成永久的成本，這與舊有的 <span id="ch1.intro1.1" lang="nolang" no>hypervisor</span> 蔓延現象截然相反。

按一下 <span id="assignment.32.1" lang="nolang" no>**Check**</span> 繼續。⚔️

📚 更多資訊
===================</span>

- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Creating <span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)

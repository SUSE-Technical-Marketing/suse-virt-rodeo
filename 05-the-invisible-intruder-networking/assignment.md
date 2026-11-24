---
slug: the-invisible-intruder-networking
id: 6y9uhwn9zyll
type: challenge
title: "<span id="assignment.100" lang="zh-TW" hist="vertrex-bank">🕵️ 第五章：隱形入侵者</span>"
teaser: <span id="assignment.101" lang="zh-TW" hist="vertrex-bank">凌晨 2 點的資安警報。對外公開的網站伺服器與銀行最機密的資料庫共用扁平化網路。打造一座軟體定義金庫，將資料庫鎖入其中。</span>
tabs:
- id: 69jpoti7gjds
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: hssojxkhutjx
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: pg01vcvbyns3
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: intermediate
timelimit: 3000
enhanced_loading: null
---
<span id="assignment.102" lang="zh-TW" hist="vertrex-bank">🕵️ 第五章：隱形入侵者
=====================================</span>

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

<img class="logos" alt="Welcome!" src="../assets/05-chapter-img.png"/>

<div id="501" class="story">

<span id="assignment.103" lang="zh-TW" hist="vertrex-bank">現在是凌晨兩點。資料中心一片寂靜，只聽得見散熱風扇規律的運轉低鳴。你一邊喝著走味的咖啡，一邊審視每日遙測日誌，此時螢幕突然閃起紅光。一則來自資安監控中心（SOC）的高優先順序重大警報覆蓋了你的儀表板。

自動化弱點掃描偵測到一個嚴重的架構缺陷：銀行對外的行銷**網站伺服器**，竟然與高度機密的 insider-threat-db 虛擬機器處於完全相同的扁平化網路層。

一旦有威脅行為者攻破公開網站，他們就能暢行無阻地透過橫向路徑，直搗銀行最敏感的內部安全資料庫。在傳統基礎架構中，要修復這個問題得叫醒資深網路工程團隊、摸黑手動重新插拔交換器連接埠的實體線路，並承擔引發災難性路由迴圈的風險。

但你不需要實體線路。**軟體定義網路**的強大力量就在你的指尖。你必須在入侵發生之前，建造一座堅不可摧的數位金庫，將該資料庫鎖在其中。</span>

</div>

<span id="assignment.104" lang="zh-TW" no>## 軟體定義網路的兩大層級

<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 為您提供完整的全方位支援，從傳統的 VLAN 區隔到企業級 SDN，這些功能過去銀行都必須額外購買專屬的閉源 SDN 授權：

| 層級 | 技術 | 今晚用途 |
|-------|-----------|-------------|
| L2 / VLAN 橋接 | **<span id="assignment.2.14" lang="nolang" no>Multus</span>** | 用於隔離資料庫的金庫 VLAN |
| SDN / 隔離的 Overlay 區域 | **<span id="assignment.2.13" lang="nolang" no>Kube-OVN</span>** | 無外部路徑的私有子網路，甚至支援重疊的 CIDR |



## 🎯 您的任務目標

1. 為正式環境連線閉迴路實體網路
2. 為開發環境建置具備同等隔離程度的 SDN
3. 學習如何將虛擬機（VM）移至新網路中



🔐 登入憑證
====================

<span id="assignment.69.1" lang="nolang" no>**SUSE Virtualization**</span> UI 與 <span id="assignment.2.12" lang="nolang" no>**Rancher Prime**</span> UI 使用相同的登入憑證。</span>

<span id="assignment.10" lang="nolang" no>Username</span>:

<div class="cred">

```txt
admin
```

</div>

<span id="assignment.105" lang="nolang" no>*Password</span>:

<div class="cred">

```txt
[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="kvm-host" ]]
```

</div>



<span id="assignment.106" lang="zh-TW" no>🧱 任務 1：連接封閉迴路實體網路
=================================================

我們的團隊已為 <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 節點配置了一張額外的專用 NIC，並以實體封閉迴路相連。讓我們將它用於傳輸最寶貴的流量，並建立一個隔離的生產網路。

在</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.107" lang="zh-TW" no>，前往左側選單中的 <span id="assignment.107.1" lang="nolang" no>**Networks**</span>，然後選取 <span id="assignment.107.2" lang="nolang" no>**Cluster Network Configuration**</span>：

1. 按一下 <span id="assignment.107.3" lang="nolang" no>**Create a Cluster Network**</span>
2. 將 <span id="assignment.19.4" lang="nolang" no>**Name**</span> 設定為：</span>

<div class="cred">

```txt
closed-loop
```

</div>

<span id="assignment.108" lang="zh-TW" no>3. 按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span>

新的叢集網路會出現在清單中。現在為其指派實體介面：在閉環叢集網路所在的同一列按一下 <span id="assignment.108.1" lang="nolang" no>**Create Network Configuration**</span>，然後填寫以下詳細資料：

1. 將 <span id="assignment.19.4" lang="nolang" no>**Name**</span> 設定為：</span>

<div class="cred">

```txt
closed-loop
```

</div>

<span id="assignment.109" lang="zh-TW" no>請注意 <span id="assignment.27" lang="nolang" no>**Node Selector**</span> 區段，我們可以在此指定網路的可用位置。

2. 在 <span id="assignment.109.1" lang="nolang" no>**Uplink**</span> 下，將 <span id="assignment.109.2" lang="nolang" no>**NICs**</span> 設定為 ens5

3. 按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span>



  


現在於其基礎上定義面向 VM 的網路。選取 <span id="assignment.109.3" lang="nolang" no>**Virtual Machine Networks**</span> 並按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span> 來定義新的安全周界：

- <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: prod
- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>

<div class="cred">

```txt
secure-loop-prod
```

</div>

<span id="assignment.110" lang="zh-TW" no>- <span id="assignment.110.1" lang="nolang" no>Basics</span>:
  - <span id="assignment.110.2" lang="nolang" no>**Type**</span>: UntaggedNetwork
  - <span id="assignment.110.3" lang="nolang" no>**Cluster Network**</span>: closed-loop

按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span>。


  


回到 <span id="assignment.109.3" lang="nolang" no>**Virtual Machine Networks**</span> 清單，secure-loop-prod 會顯示為 <span id="assignment.110.4" lang="nolang" no>**Active**</span> 狀態。



🔒 任務 2：建立閉迴路 SDN
===================================

現在請為開發環境建立相同類型的隔離。<span id="assignment.110.5" lang="zh-TW" hist="vertrex-bank">新增網路卡與佈線相當昂貴，開發環境不需要那麼多專用資源，因此這次你將使用**軟體定義網路**。</span>


  


前往 <span id="assignment.110.6" lang="nolang" no>**Networks > Virtual Machine Networks**</span> 並按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span>，然後填入以下詳細資料：

- <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: prod
- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>

<div class="cred">

```txt
secure-loop-dev
```

</div>

<span id="assignment.111" lang="zh-TW" no>- <span id="assignment.110.1" lang="nolang" no>Basics</span>:
  - <span id="assignment.110.2" lang="nolang" no>**Type**</span>: OverlayNetwork

按一下 <span id="assignment.19.3" lang="nolang" no>**Create**</span>。


  


現在建立 SDN 子網路。前往 <span id="assignment.111.1" lang="nolang" no>**Virtual Private Cloud**</span>，並在 ovn-cluster 虛擬私有雲的分頁上按一下 <span id="assignment.111.2" lang="nolang" no>**Create Subnet**</span>，然後填寫以下詳細資料：

- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>

<div class="cred">

```txt
secure-vpc-dev
```

</div>

<span id="assignment.112" lang="zh-TW" no>- <span id="assignment.112.1" lang="nolang" no>Basic</span>:
  - <span id="assignment.112.2" lang="nolang" no>**CIDR**</span>:</span>

<div class="cred">

```txt
192.168.32.0/24
```

</div>

<span id="assignment.113" lang="zh-TW" no>- <span id="assignment.113.1" lang="nolang" no>**Provider**</span>: prod/secure-loop-dev
  - <span id="assignment.113.2" lang="nolang" no>**Gateway IP**</span>:</span>

<div class="cred">

```txt
192.168.32.1
```

</div>

<span id="assignment.114" lang="zh-TW" no>- <span id="assignment.114.1" lang="nolang" no>**Dynamic Host Configuration Protocol (DHCP)**</span>：<span id="assignment.114.2" lang="nolang" no><b class="highlightcopy">Enabled</b></span>
  - <span id="assignment.114.3" lang="nolang" no>**Private Subnet**</span>：<span id="assignment.114.2" lang="nolang" no><b class="highlightcopy">Enabled</b></span>

按一下<span id="assignment.19.3" lang="nolang" no>**Create**</span>。

現在您可以將 prod/secure-loop-dev 網路指派給任何虛擬機器，且它只能與相同網路上的虛擬機器進行通訊。


如果您想在 ovn-cluster 虛擬私人雲端的分頁上檢視拓撲，請按一下<span id="assignment.114.4" lang="nolang" no>**Topology**</span>，這在擁有多個子網路時特別有用，


🎯 任務 3：使用新網路設定虛擬機器
=====================================================


您現在擁有兩個新的隔離網路。現在該向您的同仁展示如何將它們連接到虛擬機器了。


  


<span id="assignment.114.5" lang="zh-TW" hist="vertrex-bank">您並不是要親自進行變更，只是逐步了解其操作方式，為此我們將選擇正式伺服器：</span>

返回 <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span> 儀表板並找到目標虛擬機器（**webserver-prod**）：

1. 按一下該列上的 ，然後選取<span id="assignment.114.6" lang="nolang" no>**Edit Config**</span>
2. 前往<span id="assignment.107.1" lang="nolang" no>**Networks**</span>分頁
3. 生產系統請選取網路 prod/secure-loop-prod，開發系統請選取 prod/secure-loop-dev
4. 按一下<span id="assignment.114.7" lang="nolang" no>**Save**</span>
5. 再次按一下 ，然後選取<span id="assignment.114.8" lang="nolang" no>**Restart**</span>

虛擬機器開機並連線至新網路。無需等待其完成。



> [!IMPORTANT]
> 在大多數情況下，如果虛擬機器目前正在執行，您必須**先將其停止**才能使硬體修改生效。



🏋️ 加碼演練：適合對命令列感興趣的人（可選）
==========================================================

剛接觸 <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> 嗎？**歡迎直接跳過**：我們已經建立了隔離網路。這些可選的演練將純粹使用 <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> 工具來新增一個額外的隔離網路。

**QA 需要額外的隔離網路：<span id="assignment.2.2" lang="nolang" no>Kubernetes</span> 網路原則。**我們需要在 QA 中複製此設定，以確保進入生產環境時不會出現意外狀況，並套用嚴格的原則，在 VLAN 隔離之下的 Pod 層級丟棄未經授權的流量。在</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.115" lang="zh-TW" no>，套用預設拒絕所有傳入流量的原則至安全命名空間：

```bash,run
cat << EOF | kubectl --kubeconfig .rodeo/harvester-kubeconfig apply -f -
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: default-deny-all
  namespace: prod
spec:
  podSelector: {}
  policyTypes:
    - Ingress
EOF
```

確認原則已生效：

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get networkpolicy -n prod
```


為鑑識團隊建立一個完全獨立的區域：

```bash,run
cat << EOF | kubectl --kubeconfig .rodeo/harvester-kubeconfig apply -f -
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  name: forensics-zone
  namespace: prod
  labels:
    network.harvesterhci.io/clusternetwork: secure-loop-prod
    network.harvesterhci.io/type: OverlayNetwork
spec:
  config: '{"cniVersion":"0.3.1","name":"forensics-zone","type":"kube-ovn","provider":"forensics-zone.prod.ovn","server_socket":"/run/openvswitch/kube-ovn-daemon.sock"}'
EOF
```

```bash,run
cat << EOF | kubectl --kubeconfig .rodeo/harvester-kubeconfig apply -f -
apiVersion: kubeovn.io/v1
kind: Subnet
metadata:
  name: forensics-zone
spec:
  cidrBlock: "172.16.1.0/24"
  gateway: "172.16.1.1"
  excludeIps:
    - "172.16.1.1"
  protocol: IPv4
  natOutgoing: false
  private: true
  provider: forensics-zone.prod.ovn
  vpc: ovn-cluster
EOF
```

> [!NOTE]
> 每個區域都會獲得專屬的獨立網路（因此也有專屬的隔離邏輯交換器），這正是實現真正隔離的關鍵。<span id="assignment.2.13" lang="nolang" no>Kube-OVN</span> 仍會對每個 VPC 強制執行一項規則：同一個 VPC（`ovn-cluster`）內的任兩個子網路不得共用 CIDR，即使在不同的網路中亦同，這就是為什麼 `forensics-zone` 使用不同的網段。在區域之間使用完全重疊的位址空間也是可行的，只是需要第二個自訂 VPC，這超出了本次演練的範圍。

確認兩個區域皆存在且設定為 `natOutgoing: false`：無傳出路徑，無傳入路徑：

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get subnets.kubeovn.io -o custom-columns=NAME:.metadata.name,CIDR:.spec.cidrBlock,PRIVATE:.spec.private,NAT:.spec.natOutgoing
```

兩個保管庫、兩個獨立的私有網路、零共享封包。連接到任一區域的虛擬機器只能與相同子網路中的鄰近節點通訊，且**無法與其他任何目標通訊**：完全透過軟體建立與銷毀的微切分，無須專有的 SDN 授權。

💼 為什麼這很重要？
==============================================

- **凌晨兩點透過軟體進行切分。** 過去需要重新拉線並召開變更控制會議的工作，如今只需三分鐘的設定即可完成，同時將威脅窗口維持在關閉狀態。
- **預設深度防禦。** 第 2 層的 VLAN 隔離、Pod 層的網路原則，以及私有 SDN 子網路：由單一平台提供的三道獨立防護牆。
- **內建合規證據。** 每個網路、原則與子網路都是可進行版本控制的 YAML 物件：資安稽核員獲得的是實質證明，而非口頭承諾。

按一下 <span id="assignment.32.1" lang="nolang" no>**Check**</span> 繼續。⏪

📚 更多資訊
===================</span>

- [Cluster Networking](https://documentation.suse.com/cloudnative/virtualization/latest/en/networking/cluster-network.html)

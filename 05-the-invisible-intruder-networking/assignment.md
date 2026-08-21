---
slug: the-invisible-intruder-networking
id: 6y9uhwn9zyll
type: challenge
title: "<span id="assignment.100" lang="ja" hist="vertrex-bank">第5章:見えない侵入者</span>"
teaser: <span id="assignment.101" lang="ja" hist="vertrex-bank">午前2時のアラート。公開Webサーバーと最重要データベースが同じフラットネットワークを共有中。ソフトウェア定義のボールトを構築し、DBを隔離せよ。</span>
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
<span id="assignment.102" lang="ja" hist="vertrex-bank">🕵️ 第5章:見えない侵入者
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

<span id="assignment.103" lang="ja" hist="vertrex-bank">午前二時。データセンターは静まり返り、冷却ファンのリズミカルな唸り音だけが響いている。あなたは古くなったコーヒーを飲みながら日次テレメトリログを確認していると、画面が赤く点滅する。セキュリティオペレーションセンターからの重大かつ最優先のアラートが、ダッシュボードを上書きする。

自動脆弱性スキャンにより、深刻なアーキテクチャ上の欠陥が検出された。銀行の一般公開向けマーケティング**ウェブサーバー**が、極めて機密性の高いインサイダー脅威データベース仮想マシンとまったく同じフラットなネットワーク層に存在しているのだ。

もし脅威アクターが公開ウェブサイトを侵害すれば、銀行の最も機密性の高い内部セキュリティデータベースへの直接的で無防備な横方向の経路を得ることになる。従来のインフラであれば、これを修正するにはシニアネットワークエンジニアリングチームを深夜に叩き起こし、暗闇の中で物理的にスイッチポートの配線をやり直し、壊滅的なルーティングループのリスクを冒す必要があっただろう。

物理ケーブルは不要だ。あなたの手の中には**ソフトウェア定義ネットワーキング**の力がある。侵入が発生する前に、難攻不落のデジタル金庫を構築し、データベースをその中に封じ込めなければならない。</span>

</div>

<span id="assignment.104" lang="ja" no>## 2 種類のソフトウェア定義ネットワーキング

<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> は、古典的な VLAN セグメンテーションからエンタープライズ SDN まで、その全領域をカバーします。これは銀行がかつて別途クローズドソースの SDN ライセンス費用を払っていた機能です。

| レイヤー | 技術 | 今夜使うもの |
|-------|-----------|-------------|
| L2 / VLAN ブリッジング | **<span id="assignment.2.14" lang="nolang" no>Multus</span>** | データベースを隔離するボールト VLAN |
| SDN / 分離オーバーレイゾーン | **<span id="assignment.2.13" lang="nolang" no>Kube-OVN</span>** | 外部への経路を持たないプライベートサブネット、CIDR が重複していても可 |



## 🎯 クエストの目標

1. 本番用のクローズドループ物理ネットワークを接続する
2. 開発用に同等に隔離された SDN を構築する
3. VM を新しいネットワークに移行する方法を学ぶ



🔐 ログイン認証情報
====================

<span id="assignment.69.1" lang="nolang" no>**SUSE Virtualization**</span> UI と <span id="assignment.2.12" lang="nolang" no>**Rancher Prime**</span> UI は同じ認証情報を使用します。</span>

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



<span id="assignment.106" lang="ja" no>🧱 タスク1: 閉ループ物理ネットワークを接続する
=================================================

私たちのチームは、物理的に閉ループで接続された専用の追加NICを備えた<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>ノードを構築しました。この最も重要なトラフィックのためにこれを使用し、分離された本番ネットワークを作成しましょう。

この中で</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.107" lang="ja" no>左メニューの<span id="assignment.107.1" lang="nolang" no>**Networks**</span>に移動し、<span id="assignment.107.2" lang="nolang" no>**Cluster Network Configuration**</span>を選択します。

1. <span id="assignment.107.3" lang="nolang" no>**Create a Cluster Network**</span>をクリックします
2. <span id="assignment.19.4" lang="nolang" no>**Name**</span>を次のように設定します:</span>

<div class="cred">

```txt
closed-loop
```

</div>

<span id="assignment.108" lang="ja" no>3. <span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックします

一覧に新しいクラスターネットワークが表示されます。次に、物理インターフェースを割り当てます。閉ループクラスターネットワークと同じ行にある<span id="assignment.108.1" lang="nolang" no>**Create Network Configuration**</span>をクリックし、以下の詳細を入力します。

1. <span id="assignment.19.4" lang="nolang" no>**Name**</span>を次のように設定します。</span>

<div class="cred">

```txt
closed-loop
```

</div>

<span id="assignment.109" lang="ja" no><span id="assignment.27" lang="nolang" no>**Node Selector**</span>のセクションに注目してください。ここでネットワークを利用可能にする場所を指定できます。

2. <span id="assignment.109.1" lang="nolang" no>**Uplink**</span>の下で、<span id="assignment.109.2" lang="nolang" no>**NICs**</span>をens5に設定します

3. <span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックします



  


次に、その上にVM向けネットワークを定義します。<span id="assignment.109.3" lang="nolang" no>**Virtual Machine Networks**</span>を選択し、<span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックして新しいセキュアペリメーターを定義します:

- <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: prod
- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>

<div class="cred">

```txt
secure-loop-prod
```

</div>

<span id="assignment.110" lang="ja" no>- <span id="assignment.110.1" lang="nolang" no>Basics</span>:
  - <span id="assignment.110.2" lang="nolang" no>**Type**</span>: UntaggedNetwork
  - <span id="assignment.110.3" lang="nolang" no>**Cluster Network**</span>: closed-loop

<span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックします。


  


<span id="assignment.109.3" lang="nolang" no>**Virtual Machine Networks**</span>のリストに戻ると、secure-loop-prod が<span id="assignment.110.4" lang="nolang" no>**Active**</span>ステータスで表示されます。



🔒 タスク2: クローズドループSDNの作成
===================================

次に、開発環境に対して同じ種類の分離を作成します。<span id="assignment.110.5" lang="ja" hist="vertrex-bank">新しいNICの追加や配線には費用がかかります。開発環境ではそれほど多くの専用リソースは必要ないため、今回は**ソフトウェア定義ネットワーク**を使用します。</span>


  


<span id="assignment.110.6" lang="nolang" no>**Networks > Virtual Machine Networks**</span>に移動して<span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックし、以下の詳細を入力します。

- <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: prod
- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>

<div class="cred">

```txt
secure-loop-dev
```

</div>

<span id="assignment.111" lang="ja" no>- <span id="assignment.110.1" lang="nolang" no>Basics</span>:
  - <span id="assignment.110.2" lang="nolang" no>**Type**</span>: OverlayNetwork

<span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックします。


  


次に、SDNサブネットを作成します。<span id="assignment.111.1" lang="nolang" no>**Virtual Private Cloud**</span>に移動し、ovn-cluster仮想プライベートクラウドのタブで<span id="assignment.111.2" lang="nolang" no>**Create Subnet**</span>をクリックし、次の詳細を入力します。

- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>

<div class="cred">

```txt
secure-vpc-dev
```

</div>

<span id="assignment.112" lang="ja" no>- <span id="assignment.112.1" lang="nolang" no>Basic</span>:
  - <span id="assignment.112.2" lang="nolang" no>**CIDR**</span>:</span>

<div class="cred">

```txt
192.168.32.0/24
```

</div>

<span id="assignment.113" lang="ja" no>- <span id="assignment.113.1" lang="nolang" no>**Provider**</span>: prod/secure-loop-dev
  - <span id="assignment.113.2" lang="nolang" no>**Gateway IP**</span>:</span>

<div class="cred">

```txt
192.168.32.1
```

</div>

<span id="assignment.114" lang="ja" no>- <span id="assignment.114.1" lang="nolang" no>**Dynamic Host Configuration Protocol (DHCP)**</span>: <span id="assignment.114.2" lang="nolang" no><b class="highlightcopy">Enabled</b></span>
  - <span id="assignment.114.3" lang="nolang" no>**Private Subnet**</span>: <span id="assignment.114.2" lang="nolang" no><b class="highlightcopy">Enabled</b></span>

<span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックします。

これで、ネットワーク prod/secure-loop-dev を任意の VM に割り当てることができ、そのVMは同じネットワーク上の VM とのみ通信できるようになります。


ovn-cluster仮想プライベートクラウドのタブでトポロジーを確認したい場合は<span id="assignment.114.4" lang="nolang" no>**Topology**</span>をクリックしてください。これは複数のサブネットがある場合に特に便利です。


🎯 タスク3: 新しいネットワークでVMを設定する
=====================================================


新しく分離された2つのネットワークができました。次は、それらをVMにアタッチする方法を仲間に示す番です。


  


<span id="assignment.114.5" lang="ja" hist="vertrex-bank">あなたが変更を行うわけではなく、その手順を説明するだけです。そのために、本番サーバーを選択します。</span>

<span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>ダッシュボードに戻り、対象の仮想マシン(**webserver-prod**)を見つけます:

1. その行の をクリックし、<span id="assignment.114.6" lang="nolang" no>**Edit Config**</span>を選択します
2. <span id="assignment.107.1" lang="nolang" no>**Networks**</span>タブに移動します
3. 本番システムの場合はネットワーク prod/secure-loop-prod を、開発システムの場合は prod/secure-loop-dev を選択します
4. <span id="assignment.114.7" lang="nolang" no>**Save**</span>をクリックします
5. 再度 をクリックし、<span id="assignment.114.8" lang="nolang" no>**Restart**</span>を選択します

VMは新しいネットワークに接続された状態で起動します。完了を待つ必要はありません。



> [!IMPORTANT]
> ほとんどの場合、VMが現在実行中であれば、ハードウェアの変更を有効にするために**まず停止する**必要があります。



🏋️ ボーナスドリル: コマンドライン派のための(任意)
==========================================================

<span id="assignment.2.2" lang="nolang" no>Kubernetes</span>は初めてですか?**遠慮なく読み飛ばしてください**: 分離ネットワークはすでに作成済みです。このオプションのドリルでは、純粋な<span id="assignment.2.2" lang="nolang" no>Kubernetes</span>ツールを使って分離ネットワークをもう一つ追加します。

**QA用に分離されたネットワークがもう一つ必要です: <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>ネットワークポリシー。** 本番環境に移行する際にサプライズがないことを確認するため、この構成をQAで再現できる必要があります。VLAN分離の下層で、ポッドレベルで不正なトラフィックを遮断する厳格なポリシーを適用します。以下の</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.115" lang="ja" no>、セキュアな名前空間にデフォルトの全拒否ingressポリシーを適用します。

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

ポリシーが適用されていることを確認します。

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get networkpolicy -n prod
```


フォレンジックチーム用に完全に独立したゾーンを作成します。

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
> それぞれのゾーンには専用のネットワーク(つまり独立した論理スイッチ)が割り当てられており、これが本当の意味での分離を実現しています。<span id="assignment.2.13" lang="nolang" no>Kube-OVN</span> は依然としてVPCごとに1つのルールを強制します。つまり、同じVPC(`ovn-cluster`)内の2つのサブネットは、たとえ異なるネットワーク上にあっても同じCIDRを共有できません。そのため`forensics-zone`は別のブロックを使用しています。ゾーン間で本当にアドレス空間を重複させることも可能ですが、それには2つ目のカスタムVPCが必要になり、この演習の範囲外です。

両方のゾーンが `natOutgoing: false` で存在することを確認します。外への経路も内への経路もありません。

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get subnets.kubeovn.io -o custom-columns=NAME:.metadata.name,CIDR:.spec.cidrBlock,PRIVATE:.spec.private,NAT:.spec.natOutgoing
```

2つの金庫、2つの独立したプライベートネットワーク、共有パケットはゼロ。いずれかのゾーンに接続されたVMは、同じサブネット内の隣接VMとは通信できますが、**それ以外とは一切通信できません**。専有SDNライセンスなしで実現するマイクロセグメンテーション、すべてソフトウェアで構築・破棄が完結します。

💼 なぜこれが重要なのか?
==============================================

- **深夜2時のセグメンテーションも、ソフトウェアで。** かつては変更管理会議を伴う配線のやり直しプロジェクトだったものが、脅威の窓が閉じたままわずか3分の設定作業になりました。
- **デフォルトで多層防御。** レイヤー2のVLAN分離、ポッド層のネットワークポリシー、プライベートSDNサブネット:1つのプラットフォームから3つの独立した壁が生まれます。
- **コンプライアンス証跡が標準装備。** すべてのネットワーク、ポリシー、サブネットはバージョン管理可能なYAMLオブジェクトです。セキュリティ監査担当者に約束ではなく証拠を提供できます。

続けるには <span id="assignment.32.1" lang="nolang" no>**Check**</span> をクリックしてください。⏪

📚 詳細情報
===================</span>

- [Cluster Networking](https://documentation.suse.com/cloudnative/virtualization/latest/en/networking/cluster-network.html)

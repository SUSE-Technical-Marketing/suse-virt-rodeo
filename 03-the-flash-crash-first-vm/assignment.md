---
slug: the-flash-crash-first-vm
id: 09d4eiczcvaw
type: challenge
title: '<span id="assignment.33" lang="ja" hist="vertrex-bank">⚡ 第3章:フラッシュ・クラッシュ</span>'
teaser: <span id="assignment.34" lang="ja" hist="vertrex-bank">アジア市場が暴落しており、クオンツは今すぐ計算エンジンを必要としています。数日ではなく数分で、ストレージと認証情報を完全に構成した仮想マシンをデプロイします。</span>
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
<span id="assignment.35" lang="ja" hist="vertrex-bank">⚡ 第3章:フラッシュ・クラッシュ
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

<span id="assignment.36" lang="ja" hist="vertrex-bank">アジア市場で大規模な異常が発生しています!」トレーディングフロアの騒然とした喧騒の中、彼は叫びます。「現行のアルゴリズムモデルでは、流入するデータストリームを十分な速さで解析できていません。今すぐ専用の高性能計算エンジンを、高速セカンダリデータボリューム付きで展開する必要があります。さもなければ、今後10分で数百万ドルの損失を出すことになります!」

過去、Vertex Trust Bankでこの緊急要請に対応するには、優先チケットを開き、インフラチームがストレージ割り当てを確保するのを待ち、手動でオペレーティングシステムをインストールする必要がありました。それには**数日**かかるプロセスでした。

数日の余裕はありません。**あるのは数分だけです。**

あなたは旧来のチケットシステムを完全に迂回し、フルに構成された<span id="assignment.2.6" lang="nolang" no>Linux</span>仮想マシン(セキュリティ資格情報の注入とストレージのアタッチ済み)を、わずか数秒でデプロイする準備を整えます。</span>
</div>


<span id="assignment.37" lang="ja" no>## 🎯 クエストの目的

1. オペレーティングシステムイメージを確認する
2. <span id="assignment.37.1" lang="ja" hist="vertrex-bank">計算エンジン</span>をプロビジョニングする
3. Webコンソールにアクセスする



🔐 ログイン認証情報
====================

**<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>** UIと**Rancher Prime** UIは同じ認証情報を使用します。</span>

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




<span id="assignment.38" lang="ja" no>📀 課題1: OSイメージを確認する
============================================

移動する</span> [button label="<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> UI" variant="success"](tab-0) <span id="assignment.39" lang="ja" no>、左側パネルの**<span id="assignment.6.3" lang="nolang" no>Images</span>**に移動し、ベースの<span id="assignment.39.1" lang="nolang" no>**SLES-16.0-Minimal-VM.x86_64-Cloud-GM.qcow2**</span>オペレーティングシステムイメージが存在し、**<span id="assignment.6.17" lang="nolang" no>Active</span>**とマークされていることを確認します。

> [!NOTE]
> <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>における<span id="assignment.6.3" lang="nolang" no>Images</span>は、クラスタ全体で共有されるゴールデンマスターです。このイメージから起動する各VMは、それぞれ独自のコピーオンライトディスクを持ちます。イメージ自体が変更されることはありません。

**イメージが存在しない場合**、ストレージ管理者を待つことなく、自分で数秒で追加できます。

イメージは、URLから作成する、ワークステーションからアップロードする、または<span id="assignment.39.2" lang="nolang" no>**Images > Create**</span>経由で既存のボリュームからエクスポートすることができます。


  


例として、新しいイメージを追加してみましょう。

1. 左側パネルの**<span id="assignment.6.3" lang="nolang" no>Images</span>**に移動し、<span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックして、以下の詳細を入力します。
   - <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: official-images
   - <span id="assignment.19.4" lang="nolang" no>**Name**</span>: 自動的に入力されます
   - 基本情報:
     - <span id="assignment.39.4" lang="nolang" no>**URL**</span>:</span>

<div class="cred">

```txt
http://192.168.122.1:8889/SLES15-SP7-Minimal-VM.x86_64-Cloud-GM.qcow2
```

</div>


<span id="assignment.40" lang="ja" no>2. <span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックします

作成したばかりのイメージが、状態<span id="assignment.40.1" lang="nolang" no>**Downloading**</span>で一覧に表示されます。進捗列でその状況を確認できます。

次のタスクに進んでください。ダウンロードが完了すると、画面右上の**通知ベル**にアラートが表示されます。


> [!NOTE]
> ダウンロードはサーバー側で、このラボ自身のネットワーク上にあるローカルミラーから実行されるため、数秒で完了します。イメージは<span id="assignment.2.8" lang="nolang" no>Longhorn</span>にレプリケートされると**<span id="assignment.6.17" lang="nolang" no>Active</span>**になります。


🚀 タスク2: 計算エンジンをプロビジョニングする
===========================================


このタスクでは、最初のVMを作成します。


> [!NOTE]
> 指示があるまで<span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックしないでください。


  



<span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>に移動し、<span id="assignment.19.3" lang="nolang" no>**Create**</span>ボタンをクリックします。

<span id="assignment.40.3" lang="ja" hist="vertrex-bank">クオンツが必要としている通りにエンジンを設定してください。</span>

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


<span id="assignment.42" lang="ja" no>Namespaceが存在しない場合は作成してください。

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


<span id="assignment.44" lang="ja" hist="vertrex-bank">非常に少ないリソースにご注目ください。私たちの未来のクオンツチームは高いスキルを持っており、彼らのアプリケーションは低レイテンシと低リソース使用に向けて極限まで最適化されています。</span>

<span id="assignment.45" lang="ja" no>- <span id="assignment.45.1" lang="nolang" no>**SSHKey**</span>: prod/default




<span id="assignment.6.4" lang="nolang" no>Volumes</span>タブ(緑色。黒色のものと混同しないように)で、以下の詳細を入力してください:

- <span id="assignment.45.2" lang="nolang" no>**Image**</span>: official-images/SLES-16.0-Minimal-VM.x86_64-Cloud-GM.qcow2
- <span id="assignment.45.3" lang="nolang" no>**Size**</span>:</span>
<div class="cred">

```txt
5
```

</div>

<span id="assignment.46" lang="ja" no>それでは、<span id="assignment.46.1" lang="nolang" no>**Add Volume**</span>をクリックして新しいボリュームを追加し、以下の詳細を入力します。

- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>
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

<span id="assignment.48" lang="ja" hist="vertrex-bank">今度はそのエンジンを銀行のネットワークに接続します。</span><span id="assignment.49" lang="ja" no><span id="assignment.49.1" lang="nolang" no><b style="color:#30ba78;">Networks</b></span> タブ(緑色、黒いタブと混同しないように)の下:

- <span id="assignment.49.2" lang="nolang" no>**Network**</span>: <span id="assignment.49.3" lang="nolang" no><b class="highlightcopy">prod/service</b></span></span>
<div id="302" class="story">


<span id="assignment.50" lang="ja" hist="vertrex-bank">トレーダーの高速セカンドデータドライブの要求はこれで満たされます。裏側では、両方のディスクがレプリケートされた<span id="assignment.2.8" lang="nolang" no>Longhorn</span>ボリュームになり、取引中に物理ディスクが1台故障しても、市場データは失われません。</span>

</div>


<span id="assignment.51" lang="ja" no>このクラスターは混在環境なので、VMが本番ノードでのみ実行されるようにしましょう。

<span id="assignment.51.1" lang="nolang" no><b style="color:#30ba78;">Node Scheduling</b></span>をクリックすると、<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>で3つの選択肢が表示されます:

- <span id="assignment.51.2" lang="nolang" no>**Any available node**</span>: <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>スケジューラーがVMの配置場所を選択し、**ライブマイグレーションは有効のまま**になります
- <span id="assignment.51.3" lang="nolang" no>**Specific node**</span>: VMを1つのノードに固定します(マイグレーションは不可)
- <span id="assignment.51.4" lang="nolang" no>**Scheduling rules**</span>: ノードラベル(GPU機能、NUMAトポロジー、ネットワークゾーンなど)に基づくアフィニティルール

本番用ルールを設定します:

1. <span id="assignment.51.5" lang="nolang" no>**Run virtual machine on node(s) matching scheduling rules**</span>を選択
2. <span id="assignment.51.6" lang="nolang" no>**Add Node Selector**</span>をクリックし、続いて<span id="assignment.51.7" lang="nolang" no>**Add Rule**</span>をクリック:

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


<span id="assignment.53" lang="ja" no>ラベルを割り当てます:

<span id="assignment.53.1" lang="nolang" no><b style="color:#30ba78;">Labels</b></span> タブに移動し(<span id="assignment.53.2" lang="nolang" no>"Instance Labels"</span> と混同しないように注意してください)、<span id="assignment.53.3" lang="nolang" no>**Add Label**</span> をクリックします:

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

<span id="assignment.54" lang="ja" no>これは今後の自動化でこのVMを管理するのに役立ちます。

<span id="assignment.54.1" lang="nolang" no><b style="color:#30ba78;">Advanced Options</b></span>に移動し(左側の列にある<span id="assignment.54.2" lang="nolang" no>'Advanced'</span>と間違えないよう注意してください)、<span id="assignment.54.3" lang="nolang" no>**Cloud Configuration**</span>を選択して、必要な設定とパッケージがすべてインストールされた状態でシステムが起動することを確認します。

<span id="assignment.54.4" lang="nolang" no>**User Data Template**</span>をクリックし、<span id="assignment.54.5" lang="nolang" no>**Create New**</span>を選択して標準テンプレートを定義します。次の名前を付けます:

- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>
<div class="cred">

```txt
prod
```

</div>


<span id="assignment.55" lang="ja" no><span id="assignment.55.1" lang="nolang" no>**User Data**</span>には、以下を入力します。

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

<span id="assignment.19.3" lang="nolang" no>**Create**</span>（テンプレートボックス内）をクリックして、テンプレートを保存します。


このテンプレートは<span id="assignment.55.2" lang="nolang" no><b class="highlightcopy">prod</b></span>名前空間に存在し、それ自体が<span id="assignment.55.2" lang="nolang" no><b class="highlightcopy">prod</b></span>という名前であるため、prod/prodとなります。これはあらゆるVMに使用できる、本番環境の標準テンプレートです。</span>
<div id="303" class="story">
<span id="assignment.56" lang="ja" hist="vertrex-bank">取引デスクのファイアウォールチームからもう一つ要求があります。</span>
</div>

<span id="assignment.57" lang="ja" no>エンジンは DHCP が割り当てるアドレスではなく、**予測可能なアドレス**で起動する必要があります。<span id="assignment.57.1" lang="nolang" no>**Network Data**</span> フィールドに、次を入力します。

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

Cloud-init は初回起動時に両方を適用します。<span id="assignment.57.2" lang="nolang" no><b class="highlightcopy">the-engine-01</b></span> はデプロイ後の手動設定を一切行うことなく、`192.168.122.50` でオンラインになります。

> [!NOTE]
> これは**cloud-init**であり、あらゆる主要パブリッククラウドで使用されている業界標準の仕組みと同じものです。
> 実際のケースでは、このサーバーの用途に応じたより完全な自動化と専用テンプレートが用意されるでしょう。


設定が完了しましたので、<span id="assignment.19.3" lang="nolang" no>**Create**</span> をクリックして仮想マシンのデプロイを開始してください。

起動が完了するのを待たずに、次のタスクに進んでください。</span>

<div id="304" class="story">
<span id="assignment.58" lang="ja" hist="vertrex-bank">スケジューリングルールを使うと、重要なシステムを他のワークロードから分離できます。たとえば、トレーディングエンジンを低レイテンシーのノードに固定し、バッチジョブは残りのノードを共有させる、といった具合です。ここで「利用可能な任意のノード」としておくことが重要です。それこそが、次章でのゼロダウンタイムでの退避を可能にするものだからです。</span>

</div>

<span id="assignment.59" lang="ja" hist="vertrex-bank">> [!NOTE]
> **マイクロ秒がお金になるとき:** ハイフリークエンシートレーディングデスクが求めるのは、配置ルールや専用ハードウェアだけではありません。<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> は、VMに**専用CPUコアを固定割り当て**したり、ハードウェアを直接パススルーしたり、**SR-IOV**を使ってハードウェア(NICとGPUの両方)を仮想化したり、データセンターGPUをハードウェアで分離された**MIGパーティション**に分割して複数のVMが1つのGPUをノイジーネイバーなしで共有できるようにしたりすることができます。物理リソースをVMに専有させることで、**予測可能で一貫性のあるレイテンシー**が得られます。この演習は教育目的のみのものであり、ハイフリークエンシートレーディングアプリケーションの構築方法を推奨するものではありません。</span>

<span id="assignment.60" lang="ja" no>> [!IMPORTANT]
> このラボは**ネスト構成**で動作しているため、I/Oパフォーマンスは通常より少し遅く、プロビジョニングプロセスには数分かかります。VMが起動する間、皆さんを楽しませるコンテンツをご用意しました!Bonus Drillsに移動して、CLIを使って<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> APIを操作する方法を学びましょう。<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>内のすべては<span id="assignment.2.2" lang="nolang" no>Kubernetes</span>オブジェクトであるため、基盤となるRKE2クラスターを通じて<span id="assignment.2.2" lang="nolang" no>Kubernetes</span> API経由で管理できます。
> 完了したら、Task 3に戻りましょう。

🖥️ Task 3: Access the Web Console
=================================

Monitor the</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.61" lang="ja" no>仮想マシンが **Running** 状態に移行するまで。

1. 仮想マシン行の<span id="assignment.61.1" lang="nolang" no>**Console**</span>ボタンをクリックしてVNC Webコンソールを開く
2. この方法で接続なしでシステムにアクセスできることを確認する。**インストールの完了を待たずに次に進んでください**。
3. コンソールウィンドウを閉じる

🏋️ ボーナスドリル: 抽象化の裏側を見る(オプション、コマンドラインに興味がある方向け)
========================================================================================

<span id="assignment.2.2" lang="nolang" no>Kubernetes</span>は初めてですか?**遠慮なく読み飛ばしてください。** そうでない場合は、</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.62" lang="ja" no>、実際にプラットフォームがあなたのために何を作成したかを見てみましょう:

- **ゴールデンイメージもAPIオブジェクトです:**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachineimages -A
```

- **VMは<span id="assignment.2.2" lang="nolang" no>Kubernetes</span>リソースです:**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachines -n prod
```

- **実行中のインスタンス、そのノードとIP**(SSHで使用したものと同じIP):

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get vmi -n prod -o wide
```

- **ディスクは<span id="assignment.2.8" lang="nolang" no>Longhorn</span>にバックアップされた通常の<span id="assignment.62.1" lang="nolang" no>PersistentVolumeClaims</span>です:**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get pvc -n prod
```

リストの中に`market-data-vol`があることに気づくはずです: <span id="assignment.62.2" lang="ja" hist="vertrex-bank">銀行データドライブ(クラウドネイティブストレージとして表現されるもの)</span>。

💼 なぜこれが重要なのか?
========================

- **数日が数分に変わる。** チケット駆動型の複数チームにまたがるプロビジョニングプロセスが、2分間のセルフサービスワークフローに凝縮されました。<span id="assignment.62.3" lang="ja" hist="vertrex-bank">ライブ市場危機の最中に。</span>
- **構造による一貫性。** ゴールデンイメージとcloud-initにより、クオンツが要求するすべてのエンジンが同一の構成で起動し、すぐに使用可能になります。
- **孤立したストレージがない。** <span id="assignment.6.4" lang="nolang" no>Volumes</span>は、共有された<span id="assignment.2.8" lang="nolang" no>Longhorn</span>プールからオンデマンドで切り出されます。</span>

<div id="305" class="story">

<span id="assignment.63" lang="ja" hist="vertrex-bank">無線でトレーディングフロアに連絡する。*「エンジンは稼働中で、データボリュームも接続済みだ」*。危機は回避された——しかし、この一日はまだ終わらない。</span>

</div>

<span id="assignment.64" lang="ja" no>続けるには <span id="assignment.32.1" lang="nolang" no>**Check**</span> をクリックしてください。🌊

📚 詳細情報
===================</span>

- [Creating <span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)
- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)

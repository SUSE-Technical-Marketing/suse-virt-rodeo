---
slug: the-stampede-automation
id: euwnv5ojhvfl
type: challenge
title: "<span id="assignment.138" lang="ja" no>🐤 第7章:スタンピード</span>"
teaser: <span id="assignment.139" lang="ja" hist="vertrex-bank">市場は暴落しており、クオンツは計算用フリートを3ノードから5ノードへ今すぐスケールする必要がある。ゴールデンVMテンプレートを作成し、必要に応じて同一のマシンを量産せよ。</span>
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
<span id="assignment.140" lang="ja" no>🤠 第7章:大暴走
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

<span id="assignment.141" lang="ja" hist="vertrex-bank">突然の、激しい世界的な金利変動が金融市場を大混乱に陥れる。ヴァーテックス・トラスト銀行のリスク分析アルゴリズムは、押し寄せる不安定な市場データを処理するために、さらなる計算能力を求めて悲鳴を上げている。

*「計算エンジンが一台だけではもう足りない!」* **クオンツ部門長**が印刷されたレポートを振りかざしながら、部屋の向こうから叫ぶ。*「今すぐ同一構成のエンジンを5台用意してくれ、さもないとこの市場暴落の中を計器なしで飛ぶことになる!」*

5台のマシンを手作業で、一画面ずつ構築することは、今まさに避けなければならない事態を招く。ここでのメモリサイズの入力ミス、あそこでのネットワークの設定漏れ。プレッシャーの中での構成のズレ——そして今、ヒューマンエラーは**1秒ごとに**数百万ドルの損失を生む。

あなたは指の関節を鳴らす。銀行が必要としているのは**黄金の設計図**だ。完璧なマシンを一度定義すれば、あとは要求に応じて同一のコピーを量産できる。</span>

</div>

<span id="assignment.142" lang="ja" no><span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>には、まさにそれがあります: **VMテンプレート**。テンプレートは、CPU、メモリ、ディスク、ネットワーク、cloud-initを単一のバージョン管理されたオブジェクトにキャプチャします。**マルチインスタンス作成**と組み合わせることで、1つの設計図がワンクリックで完全なフリートになります。



## 🎯 クエストの目標

1. 黄金のテンプレートを鍛える
2. プレッシャーの中でフリートをスケールする
3. フリートを停止する



🔐 ログイン認証情報
====================

<span id="assignment.69.1" lang="nolang" no>**SUSE Virtualization**</span>のUIと**Rancher Prime**のUIは、同じ認証情報を使用します。</span>

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



<span id="assignment.143" lang="ja" no>📜 タスク1：ゴールデンテンプレートを作成する
====================================


  


仮想マシンのデプロイを高速化し、標準化するためのテンプレートが必要です。
In</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.144" lang="ja" no><span id="assignment.144.1" lang="nolang" no>**Advanced > Templates**</span>に移動し、<span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックしてから、以下の詳細を入力します。

- <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: prod
- <span id="assignment.144.2" lang="nolang" no>**Template Name**</span>:</span>

<div class="cred">

```txt
prod-basic
```

</div>

<span id="assignment.145" lang="ja" no>リソース使用量を最小限に抑える必要があり、すべてのVMは厳重に保護された本番SSHキーを使ってアクセスできる必要があります。

- 基本設定:
  - <span id="assignment.42.1" lang="nolang" no>**CPU**</span>: 1
  - <span id="assignment.145.1" lang="nolang" no>**Memory**</span>: 1
  - <span id="assignment.45.1" lang="nolang" no>**SSHKey**</span>: prod/default

デフォルトのベースOSはSLES 16です。

- <span id="assignment.6.4" lang="nolang" no>Volumes</span>:
  - <span id="assignment.45.2" lang="nolang" no>**Image**</span>: official-images/SLES-16.0-Minimal-VM.x86_64-Cloud-GM.qcow2
  - <span id="assignment.45.3" lang="nolang" no>**Size**</span>: 5

本番サーバーには、本番サービスネットワーク上でサービスを提供させたいと考えています。

- <span id="assignment.49.1" lang="nolang" no>Networks</span>:
  - <span id="assignment.49.2" lang="nolang" no>**Network**</span>: prod/service

すべての本番VMは、本番運用可能なホスト上でのみ稼働させる必要があります。

- <span id="assignment.51.1" lang="nolang" no>Node Scheduling</span>:
  1. <span id="assignment.51.5" lang="nolang" no>**Run virtual machine on node(s) matching scheduling rules**</span> を選択します
  2. <span id="assignment.51.6" lang="nolang" no>**Add Node Selector**</span> をクリックし、続いて <span id="assignment.51.7" lang="nolang" no>**Add Rule**</span>:


- <span id="assignment.51.8" lang="nolang" no>**Key**</span>:</span>

<div class="cred">

```txt
stage
```

</div>

<span id="assignment.52" lang="ja" no>- **値**:</span>

<div class="cred">

```txt
prod
```

</div>


<span id="assignment.146" lang="ja" no>VMのラベルを適切に設定します:

- <span id="assignment.53.1" lang="nolang" no>Labels</span>:
  - クリック <span id="assignment.53.3" lang="nolang" no>**Add Label**</span>:


- <span id="assignment.51.8" lang="nolang" no>**Key**</span>:</span>
<div class="cred">

```txt
stage
```

</div>

<span id="assignment.52" lang="ja" no>- **値**:</span>
<div class="cred">

```txt
prod
```

</div>


<span id="assignment.147" lang="ja" no>最終的に、すべての本番マシンをパッケージと設定の統一セットに標準化したいと考えています。

- <span id="assignment.54.1" lang="nolang" no>Advanced Options</span>:
  - <span id="assignment.54.4" lang="nolang" no>**User Data Template**</span>: prod/prod

完了するには、<span id="assignment.19.3" lang="nolang" no>**Create**</span> をクリックします。

これらすべての詳細を毎回入力することを想像できますか？ 誰もが諦めてしまい、環境には一貫性のなさが蔓延し、その一貫性のなさがさらなる自動化をより困難にしてしまうでしょう。


> [!NOTE]
> テンプレートは**バージョン管理**されています。後でテンプレートを編集すると、新しいバージョンが作成されますが、古いバージョンから構築されたマシンはその系統を保持します。つまり、どのブループリントから何がデプロイされたかの完全な監査証跡が残り、規制当局もこれを歓迎するでしょう。


📈 タスク2：負荷下でのフリート拡張
=========================================

テンプレートがすでに存在するため、複数のサーバーをデプロイするのはほんの数クリックで済みます。


  


In</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.148" lang="ja" no>**<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>** に移動し、<span id="assignment.19.3" lang="nolang" no>**Create**</span> をクリックして、以下の詳細を入力します。

1. <span id="assignment.148.1" lang="nolang" no>**Multiple Instance**</span> を選択します
2. <span id="assignment.39.3" lang="nolang" no>**Namespace**</span> を prod に設定します
3. <span id="assignment.148.2" lang="nolang" no>**Name Prefix**</span> を次のように設定します。</span>

<div class="cred">

```txt
appcluster
```

</div>


<span id="assignment.149" lang="ja" no>4. <span id="assignment.149.1" lang="nolang" no>**Count**</span>を2に設定します
5. <span id="assignment.149.2" lang="nolang" no>**Use VM Template**</span>にチェックを入れ、<span id="assignment.149.3" lang="nolang" no>**Template**</span>をprod/prod-basicに設定します
6. <span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックします</span>




<div id="702" class="story">

<span id="assignment.150" lang="ja" hist="vertrex-bank">リスク分析チームは拡大した艦隊にデータを投入し始め、間一髪のところで銀行の市場での地位を安定させた。</span>

</div>


<span id="assignment.151" lang="ja" no>🧹タスク3:艦隊を停止する
===============================</span>

<div id="703" class="story">

<span id="assignment.152" lang="ja" hist="vertrex-bank">市場の急騰は静まる。仮想マシンは次の波を待ちながらアイドル状態にある――だが、それは今日来るのか?明日か?それとも来月か?この高潔なサーバーたちにとって、待つことは数値計算をすべてこなすことよりも辛いのだ。</span>

</div>

<span id="assignment.153" lang="ja" no>もう仮想マシンはそんなに必要ありません。まだ起動中でも構わないので、すべて一度に削除してください。</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.154" lang="ja" no><span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>のセクションに移動します:

1. 作成したすべての新しい仮想マシンの横にある<span id="assignment.154.1" lang="nolang" no>**checkboxes**</span>にチェックを入れます
2. <span id="assignment.137.2" lang="nolang" no>**Delete**</span>をクリックし、<span id="assignment.154.2" lang="nolang" no>**Delete All**</span>にチェックを入れて、<span id="assignment.154.3" lang="nolang" no>**Delete**
</span>をクリックします</span>

<div id="704" class="story">

<span id="assignment.155" lang="ja" hist="vertrex-bank">これら高貴な仮想マシンたちの苦しみは終わった。炎が見えるか、我が子よ。今、彼らはヴァルハラで安らいでいる。</span>

</div>




<span id="assignment.156" lang="ja" no>🏋️ ボーナスドリル：コマンドラインに興味がある方へ（任意）
==========================================================

<span id="assignment.2.2" lang="nolang" no>Kubernetes</span>が初めての方は、**遠慮なく読み飛ばしてください。** そうでない方は、以下で証明してください</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.157" lang="ja" no>UI、フリート、APIがすべて一致していることを確認するには：

- **テンプレートをAPIオブジェクトとして確認する**：テンプレートとそのバージョンもリソースです：

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplates,virtualmachinetemplateversions -n prod
```

- **テンプレート定義をyaml形式で取得する**：

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplates -n prod prod-basic -o yaml > template_prod-basic.yaml
template_version_name=`kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplateversions -n prod -o name |grep '/prod-basic-'`
kubectl --kubeconfig .rodeo/harvester-kubeconfig get -n prod ${template_version_name} -o yaml >> template_prod-basic.yaml
```

`template_prod-basic.yaml`ファイルを確認できます：


```bash,wrap,run
less template_prod-basic.yaml
```


これには、タスク2でテンプレートを作成する際に使用したものと似た定義が含まれています。



💼 なぜこれが重要なのか？
==============================================

- **自社ハードウェア上での弾力性。** <span id="assignment.157.1" lang="ja" hist="vertrex-bank">銀行自身のデータセンター上でのクラウド型スケールアウト(およびスケールイン)により、データレジデンシーの問題やエグレス料金の心配がありません。</span>
- **ヒューマンエラーが設計上排除されている。** マシンはバージョン管理されたゴールデンブループリントから作成されるものであり、記憶や手作業からではありません。つまり、午前2時に構成ドリフトが発生することはあり得ません。
- **ライフサイクル全体の経済性。** 廃棄はチェックボックスとクリックひとつで完了するため、一時的なキャパシティが恒久的なコストになることはなく、これは古い<span id="ch1.intro1.1" lang="nolang" no>hypervisor</span>の乱立とは正反対です。

続けるには<span id="assignment.32.1" lang="nolang" no>**Check**</span>をクリックしてください。⚔️

📚 詳細情報
===================</span>

- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Creating <span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)

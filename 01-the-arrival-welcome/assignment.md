---
slug: the-arrival-welcome
id: ermykdy1tbse
type: challenge
title: "<span id="assignment.7" lang="ja" hist="vertrex-bank">🏦 第1章:到着</span>"
teaser: <span id="assignment.8" lang="ja" hist="vertrex-bank">Vertex Trust Bank はレガシー<span id="ch1.intro1.1" lang="nolang" no>hypervisor</span>コストに溺れています。役員会議室に足を踏み入れ、SUSE Virtualization の指揮を執り、新しいコマンドセンターを点検してください。</span>
notes:
- type: text
  contents: |
    <span id="assignment.1" lang="ja" no># <span id="assignment.1.1"  lang="nolang" no>SUSE Virtualization Rodeo!</span>へようこそ

    ラボ環境を準備していますので、しばらくお待ちください。</span><span lang="ja" id="ch1.waiting1" hist="vertrex-bank">バーテックス・トラスト銀行本社の窓に、雨が激しく打ちつけている……
    CTOのサラが役員会議室であなたを待っている。</span>
    <img class="logos" src="../assets/logos/suse_logo.svg"/>
tabs:
- id: 3veafppy6ial
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: ljaolp3q406m
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: ihjqc1cl533q
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: basic
timelimit: 2400
enhanced_loading: null
---

<span id="assignment.9" lang="ja" hist="vertrex-bank">🏦 第1章:到着</span>
==========================

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
    border-left: 1px solid white;
    border-radius: 0;
    display: flex;
    align-items: center;
    background-color: #30ba78;   /* new: green copy-bar background */
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

<img class="logos" alt="Welcome!" src="../assets/01-chapter-img.png"/>


<div id="101" class="story">
<span lang="ja" id="ch1.intro1" hist="vertrex-bank">雨がヴァーテックス・トラスト銀行本社の床から天井まである窓に打ちつけ、街の輪郭を灰色の水っぽいぼやけた像に歪ませていた。ガラス張りの役員会議室の中も、同様に荒れた雰囲気だった。最高技術責任者のサラは部屋を端から端まで歩き回り、その目は赤いアラートとパフォーマンス警告の海を映し出す巨大な天井モニターに釘付けになっていた。

彼女はあなたの方を振り向き、疲労で張り詰めた声で言った。*「私たちは、あらゆる市場取引で貴重なミリ秒を失い続けています。うちのレガシー<span id="ch1.intro1.1" lang="nolang" no>hypervisor</span>は、現代のデジタルバンキングの膨大なトラフィック量に耐えきれず崩れかけています。インフラは脆弱で、ストレージアレイは絶えず同期が崩れ、ライセンス費用はエンジニアリング予算を完全に食いつぶしています。この老朽化したモノリシックなシステムに縛られたままでは、あと一年も持ちません」*

あなたはマホガニーのテーブルの端に静かに座り、彼女が提供したアーキテクチャの図面に目を通す。エリート**インフラストラクチャ・アーキテクト**として、あなたはただ一つの目的のために招かれた——ヴァーテックス・トラスト銀行を完全な業務停止から救うことだ。彼らはアプリケーションスタック全体をゼロから作り直すことなく、クラウドネイティブの世界への橋渡しを必要としている。

*「サラ、私たちには計画があります」*ようやくあなたはそう言い、安心させるような音を立ててノートパソコンを閉じる。*「データセンター全体を<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>へ移行します。あなた方のレガシーシステムを現代へと導き、しかも一切の停滞なくやり遂げます」*</span>
</div>


<span id="assignment.2" lang=ja no>あなたの旅はまさに今始まります。古い世界を解体し始める前に、新しい世界に足場を築き、環境を深く掘り下げる必要があります。



## <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>とは?

<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>(別名**<span id="assignment.2.1" lang="nolang" no>Harvester</span>**)は、<span id="assignment.2.2" lang="nolang" no>Kubernetes</span>上に構築されたモダンなオープンソースのハイパーコンバージドインフラストラクチャ(HCI)プラットフォームです。ベアメタル上で直接動作し、クラウドネイティブな基盤の上でエンタープライズグレードの**仮想マシン**を銀行に提供します、<span id="ch1.intro2"  lang="ja" hist="vertrex-bank">ヴァーテックス・トラスト銀行が必要としているまさにその架け橋</span>:

- **<span id="assignment.2.3" lang="nolang" no>KubeVirt</span> + <span id="assignment.2.4" lang="nolang" no>KVM</span>/<span id="assignment.2.5" lang="nolang" no>QEMU</span>**: ネイティブな<span id="assignment.2.2" lang="nolang" no>Kubernetes</span>ワークロードとしてのエンタープライズ仮想化。その下には、数十年にわたり<span id="assignment.2.6" lang="nolang" no>Linux</span>仮想化を支えてきた実戦で鍛え抜かれた**<span id="assignment.2.4" lang="nolang" no>KVM</span>/<span id="assignment.2.5" lang="nolang" no>QEMU</span>**の組み合わせが存在しており、それゆえにこのプラットフォームは実に多様なゲストOSを実行できます、<span id="ch1.intro3"  lang="ja" hist="vertrex-bank">古い遺産システムの片隅で今も稼働し続け、移行の日を辛抱強く待っている非常に古いものも含めて</span>
- **<span id="assignment.2.7" lang="nolang" no>SUSE Storage</span>(<span id="assignment.2.8" lang="nolang" no>Longhorn</span>)**: すべてのノードにまたがる分散・複製型ブロックストレージで、初期状態からすぐに使える形でセットアップ済みです。<span id="ch1.intro4"  lang="ja" hist="vertrex-bank">そして、もし銀行が別のストレージを好むようになった場合は</span>、**<span id="assignment.2.9" lang="nolang" no>CSI</span>互換のストレージドライバーであればどれでもそのまま接続可能**、選択の自由があり、ロックインは一切ありません
- **<span id="assignment.2.10" lang="nolang" no>Software-defined networking</span>**: ケーブルに一切手を触れずにVLANや隔離されたオーバーレイネットワークを構築
- **オープンソースの請求書は一本だけ**: ソケット単位の<span id="ch1.intro1.1" lang="nolang" no>hypervisor</span>税は不要
- **本当に耳を傾ける<span id="assignment.2.11" lang="nolang" no>Support</span>**: SUSEの顧客は**SUSE<span id="assignment.2.11" lang="nolang" no>Support</span>**を業界最高クラスと一貫して評価しており、その声が製品の今後の方向性を直接形作っています。クローズドソースのベンダーにそのような席を求めてみるといいでしょう

このプラットフォームは<span id="assignment.2.2" lang="nolang" no>Kubernetes</span>*上で*動作するため、コンテナ化されたワークロードも同じクラスタ上で実行できます。最初から役割分担をはっきりさせておきましょう。<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>のUIは**仮想マシン**を管理するものであり、コンテナの管理(および複数クラスタ全体の管理)はこれから紹介する<span id="assignment.2.12" lang="nolang" no>**Rancher Prime**</span>の役目です。

<span id="ch1.intro5"  lang="ja" hist="vertrex-bank">銀行の予算を圧迫しているすべての独自コンポーネントには、モダンなオープンソースの代替製品があります。</span>

| 旧世界(ソケット単位のライセンス) | <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> |
|--------------------------------------|---------------------|
| ISAware独自の<span id="ch1.intro1.1" lang="nolang" no>hypervisor</span> | <span id="assignment.2.3" lang="nolang" no>KubeVirt</span> + <span id="assignment.2.4" lang="nolang" no>KVM</span> |
| 独自仕様のストレージアレイ | SUSEストレージ、または任意の<span id="assignment.2.9" lang="nolang" no>CSI</span>ドライバー<span id="ch1.intro6"  lang="ja" hist="vertrex-bank">銀行が選ぶ</span> |
| クローズドソースのSDN | <span id="assignment.2.13" lang="nolang" no>Kube-OVN</span> + <span id="assignment.2.14" lang="nolang" no>Multus</span> |
| ISAware Command Throne | <span id="assignment.2.15" lang="nolang" no>SUSE Rancher Prime</span> |

ベンダーロックインなし。仮想化税なし。独自仕様のカーネルなし。**プラットフォームは一つ、請求書も一つ**、<span id="ch1.intro7"  lang="ja" hist="vertrex-bank">ボードルームでサラに約束した通りのことです</span>。



## 🎯 クエストの目標

1. ログインして統合ダッシュボードを確認する
2. コマンドセンターであるRancher Primeと出会う!
3. 分散ストレージ基盤を検証する
4. 管理者用ターミナルアクセスをテストする




<span id="ch1.intro8"  lang="ja" hist="vertrex-bank">> [!NOTE]
> 免責事項:本ラボは教育目的のものであり、「銀行」の本番環境を構築するための手順を提供するものではありません。ここで下された決定の多くは、この環境の制約と目的に基づいています。</span>




🔐 あなたのアーキテクト認証情報
=============================

記録のため、あなたのアーキテクト認証情報は以下の通りです:</span>


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


<span id="assignment.3" lang=ja> [!NOTE]
> UIは自己署名証明書を使用しています。表示されたらブラウザのセキュリティ警告を承諾してください。ページがすぐに読み込まれない場合、ラボ環境がまだ起動中である可能性があります。1分ほど待ってからタブを更新してください。

> [!NOTE]
> 埋め込みタブではなく自分のブラウザで作業したい場合、ラボホストには以下から直接アクセスできます:
> https://kvm-host.[[ Instruqt-Var key="_SANDBOX_ID" hostname="kvm-host" ]].instruqt.io:8443




📊 タスク1: ログインして統合ダッシュボードを確認する
===================================================

以下に移動します</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.4" lang=ja[タブ]をクリックし、認証情報を使用してログインしてください。

![01-connect_to_cluster.gif](../assets/chapter1-connect_to_cluster.gif)

少し時間を取って、メインの</span>  <span id="assignment.5" lang="nolang" no>**Dashboard**</span><span id="assignment.6" lang=ja: これはミッション全体のコマンドセンターです。


> [!NOTE]
> まだ変更は加えないでください。今は環境に慣れているところです。


- 最初のセクションには全体の数値が表示されています:
  - **<span id="assignment.6.1" lang="nolang" no>Hosts</span>** クラスターの構成
  - **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>**(実行中および停止中)
  - **<span id="assignment.6.3" lang="nolang" no>Images</span>** 新しいVMをデプロイするために利用可能
  - **<span id="assignment.6.4" lang="nolang" no>Volumes</span>** 使用中
  - **<span id="assignment.6.5" lang="nolang" no>Disks</span>** 利用可能

それぞれをクリックすると、詳細情報を含む専用セクションに移動します。**<span id="assignment.6.1" lang="nolang" no>Hosts</span>** をクリックしてください:

各ホストの予約済みリソースと使用済みリソース、ホストのIPアドレス、その他の詳細情報を確認できます。

各行の末尾にある をご覧ください: これをクリックすると、そのホストに対するさまざまな操作を行うメニューが開きます。

**<span id="assignment.6.6" lang="nolang" no>Dashboard</span>** に戻り、他に何があるか見てみましょう:

- 2番目のセクション **<span id="assignment.6.7" lang="nolang" no>Capacity</span>** には、クラスター内で現在予約されているリソースと利用可能なリソースが一覧表示されます。

- その下に2つのタブを持つセクションがあります:

  - **<span id="assignment.6.8" lang="nolang" no>Cluster Metrics</span>**: クラスターに関するリアルタイムのメトリクス。パフォーマンスの問題をトラブルシューティングする際に役立ちます。

  - **<span id="assignment.6.9" lang="nolang" no>Virtual Machine Metrics</span>**: 仮想マシンに関するリアルタイムのメトリクス。VMが実行されていない場合は表示するデータがないことに注意してください。

- 一番下のセクション **<span id="assignment.6.10" lang="nolang" no>Events</span>** には、クラスターで発生した最新のイベントが表示されます。

さらにUIの他の部分も見てみましょう。右上には **All Namespaces** が選択されたドロップダウンメニューがあります。これを使うと特定のネームスペースに絞り込むことができます。ここでのネームスペースは <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> のネームスペースです: リソースを整理し、その中のすべてのものに専用の権限を割り当てる方法で、「グループ」に似た概念です。この章の最後には詳細情報へのリンクがあります。<span id="assignment.2.2" lang="nolang" no>Kubernetes</span> にある多くの概念は <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> に直接当てはまります。

**ベル** アイコンには通知とアラートが表示され、さらに右にある **ユーザーアイコン** からユーザー設定と自動アクセス用のキーに移動できます。

左側にはさまざまなセクションからなるカラムがあります。今はすべてを確認しませんが、今後の章で多くを見ていきます。これらのセクションは有効/無効になっているプラグインによって変わることに注意してください。

最後に、左下隅にある **<span id="assignment.2.11" lang="nolang" no>Support</span>** をクリックしてください。
ドキュメントやその他のサポートリソースへのリンクがあるページと、2つの重要なセクションに移動します:

- **<span id="assignment.6.11" lang="nolang" no>Generate a <span id="assignment.2.11" lang="nolang" no>Support</span> Bundle</span>**: SUSE <span id="assignment.2.11" lang="nolang" no>Support</span> が直接アクセスすることなく環境をトラブルシューティングするのに役立つファイルを生成します。
- **<span id="assignment.6.12" lang="nolang" no>Download KubeConfig</span>**: kubectlなどのツールをコンソールから使ってこのクラスターを管理するためのkubeconfigファイルを提供します。

まだ時間があれば、次のタスクに進む前にこれらのセクションに慣れておいてください。


> [!NOTE]
> このダッシュボードに表示されるもの(VM、ボリューム、ネットワーク)はすべて、裏側では <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> のリソースです。UIはこのミッションの主要なツールですが、興味があればオプションのボーナスドリル用にターミナルも用意されています。



🐮 タスク2: コマンドセンター、Rancher Primeとの出会い
=================================================

このプラットフォームは **Rancher Prime** にも接続できます。<span id="ch1.task2a"  lang="ja" hist="vertrex-bank">銀行の新しい世界において誰が何をするかを理解することが重要です。</span>

- <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> はこのクラスター上の **仮想マシン** を管理します。
- **Rancher Prime** は **複数のクラスターを一度に**(各支店データセンターのすべての <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> クラスター)管理し、さらに **ユーザー、ロール、アクセス制御(<span id="assignment.6.13" lang="nolang" no>RBAC</span>)** を一元管理するとともに、銀行がVMと並行して実行する **コンテナワークロード** も管理します。

では、Rancherの中身を見てみましょう。

[button label="Rancher Prime UI" variant="success"](tab-2) を開き、同じ認証情報でログインし、左メニューから **Virtualization Management** を選択してください。


  


ここから複数の <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> クラスターを管理できます。既存のクラスターをインポートしましょう:

1. **Import Existing** をクリック
2. **Cluster Name** を次のように設定します


```txt
mysusevirt1
```



3. **Create** をクリック
4. 新しい画面が表示されます。そこにURLが表示されるので、次の手順のためにそのURLをコピーしてください。
5. その下に登録手順が表示されています。それに従い、cluster-registration-url 設定を編集する際は **<span id="assignment.6.14" lang="nolang" no>Insecure Skip TLS Verify</span>** を選択することを忘れないでください。これは [button label="SUSE Virtualization UI" variant="success"](tab-0) で行います。

6. [button label="Rancher Prime UI" variant="success"](tab-2) に戻り、UIの左上にある「<span id="assignment.2.1" lang="nolang" no>Harvester</span> Clusters」をクリックしてください。

クラスター名の横にある状態を確認してください: **<span id="assignment.6.15" lang="nolang" no>Pending</span>**。これはクラスターが登録プロセスを完了するのを待っている状態です。

Rancher UIにとどまり、状態が **<span id="assignment.6.15" lang="nolang" no>Pending</span>** から **<span id="assignment.6.16" lang="nolang" no>Waiting</span>** に変わり、最終的に **<span id="assignment.6.17" lang="nolang" no>Active</span>** になるのを見届けてください。

再び **<span id="assignment.2.1" lang="nolang" no>Harvester</span> Clusters** に戻ると、クラスターが一覧に表示されています。

ここでできる他のことも見てみましょう。クラスターの行の末尾にある をクリックすると、いくつかのオプションを含むメニューが表示されます:

- **<span id="assignment.6.18" lang="nolang" no>Kubectl Shell</span>**: クラスターに接続されたシェルを開き、それに対してkubectlコマンドを実行できます。
- **<span id="assignment.6.12" lang="nolang" no>Download KubeConfig</span>**: <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> UIで既に見たものと同じです。
- **<span id="assignment.6.19" lang="nolang" no>Download YAML</span>**: クラスター定義をYAML形式でダウンロードします。これをテンプレートとして使い、自動化された方法で新しいクラスターをインポートできます(クラスターUI側で追加の手順が1つ必要です)。

最後に、クラスター名自体をクリックすると
- Rancher UI内に埋め込まれた <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> UIに移動します
- 左側のカラムに「<span id="assignment.6.13" lang="nolang" no>RBAC</span>」という項目がメニューに追加されていることに注目してください。これでクラスター上で誰が何をできるかを制御できます。


Rancherを使えば、複数のクラスターを1か所から簡単に操作できます。



> [!NOTE]
> SUSE Rancher Prime専用のrodeoもありますので、ぜひ参加してみてください!



⌨️ タスク3: 管理用ターミナルアクセスをテストする
===================================================

このミッションのほとんどはUI上で過ごしますが、<span id="ch1.task3a"  lang="ja" hist="vertrex-bank">しかし、アーキテクトは常に緊急アクセスを確認する。</span>。[button label="Cluster Terminal" variant="success"](tab-1) タブをクリックし、次のコマンドを実行して、基盤となる <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> エンジンへの接続がアクティブであることを確認してください:


```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get VirtualMachine -A
```

すべてのネームスペースに存在する **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>** の一覧が表示されるはずです。



💾 ボーナスドリル: 分散ストレージファブリックを検証する(任意)
====================================================================

<span id="ch1.bonus1a"  lang="ja" hist="vertrex-bank">銀行業務にとって、安定したストレージバックエンドは不可欠です</span>。<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> は **<span id="assignment.2.7" lang="nolang" no>SUSE Storage</span>** を使って、すべてのボリュームをクラスター全体に複製します。


  


[button label="SUSE Virtualization UI" variant="success"](tab-0) には既にストレージの健全性に関する情報が表示されていますが、**Extension developer features** を有効にすることで、<span id="assignment.2.7" lang="nolang" no>SUSE Storage</span>(<span id="assignment.2.8" lang="nolang" no>Longhorn</span>)ダッシュボードにアクセスすることもできます:

1. 右上の **ユーザーアイコン** をクリック
2. **Preferences** を選択
3. **Enable Extension developer features** にチェックを入れる

**Home** に戻り、左下隅にある **<span id="assignment.2.11" lang="nolang" no>Support</span>** をクリックしてください。

2つの新しいセクションが表示されます:

- **<span id="assignment.6.20" lang="nolang" no>Access Embedded</span> Rancher UI**
- **<span id="assignment.6.20" lang="nolang" no>Access Embedded</span> <span id="assignment.2.7" lang="nolang" no>SUSE Storage</span>(<span id="assignment.2.8" lang="nolang" no>Longhorn</span>)UI**

**<span id="assignment.2.8" lang="nolang" no>Longhorn</span> UI** セクションをクリックしてください。

<span id="assignment.2.7" lang="nolang" no>SUSE Storage</span> の <span id="assignment.6.6" lang="nolang" no>Dashboard</span> に移動し、すべてが緑色になっているはずです。
もしノードがスケジュール不可になったり、ボリュームが劣化した場合、<span id="assignment.2.7" lang="nolang" no>SUSE Storage</span> はすでに他の場所でレプリカを再構築しているはずですが、常に自分の目で状況を確認してください。


🏋️ ボーナスドリル: コマンドラインに興味のある方向け(任意)
==========================================================

<span id="assignment.2.2" lang="nolang" no>Kubernetes</span> に不慣れですか?**自由に読み飛ばしてください**: 重要なことはすべてUIに含まれています。仕組みを少し覗いてみたい場合は、[button label="Cluster Terminal" variant="success"](tab-1) で次の追加チェックを実行してみてください:

- **<span id="assignment.2.2" lang="nolang" no>Kubernetes</span> コントロールプレーンとCoreDNSのエンドポイントを確認する:**

```bash,wrap,run
kubectl cluster-info --kubeconfig .rodeo/harvester-kubeconfig
```

- **クラスターコンポーネントの健全性を確認する**: コントロールプレーンのヘルスエンドポイントに問い合わせます。すべてのチェック(etcd、informers、shutdown hooks)が `ok` を返すはずです:

```bash,wrap,run
kubectl get --raw='/readyz?verbose' --kubeconfig .rodeo/harvester-kubeconfig
```

- **ファブリック内のすべてのノードが準備完了状態であることを確認する:**

```bash,wrap,run
kubectl get nodes --kubeconfig .rodeo/harvester-kubeconfig
```

  すべてのノードが `Ready` と表示されるはずです。

- **コアとなる仮想化サービスが実行中であることを確認する:**

```bash,wrap,run
kubectl get pods -n harvester-system --kubeconfig .rodeo/harvester-kubeconfig | grep -v Completed
```

  すべてのPodが `Running` であるはずです。

- **銀行が実行している正確なプラットフォームバージョンを確認する:**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get settings.harvesterhci.io server-version
```

💼 なぜこれが重要なのか?
==============================================

- **統一されたコマンドセンター。** VM、ストレージ、ネットワークが単一のダッシュボードから可視化され、3つの異なるライセンスを持つ3つの別々の管理コンソールを使い分ける必要はもうありません。
- **最初から<span id="assignment.2.2" lang="nolang" no>Kubernetes</span>ネイティブ。** ダッシュボードに表示されるものはすべて、裏側では <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> のリソースです。コンテナチームの既存のスキルがそのまま活かせる一方、VMチームは使いやすいポイント&クリックのUIを得られます。
- **フリート管理と<span id="assignment.6.13" lang="nolang" no>RBAC</span>も含まれています。** Rancher Primeは <span id="ch1.why1"  lang="ja" hist="vertrex-bank">銀行が今後運用するすべてのクラスターを、1つのログインと1組のアクセスルールで指揮する準備が整っています。</span>
- **標準で分散ストレージを提供。** <span id="assignment.2.7" lang="nolang" no>SUSE Storage</span> はノード間でデータを自動的に複製します。

コントロールプレーンが応答していること、ストレージが健全であること、そして管理アクセスが確保されていることを確認したら、施設のさらに奥へ進む準備は完了です。

**Check** をクリックしてデータセンターへ降りてください。🛗

📚 詳細情報
===================</span>


- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Hardware and Network Requirements](https://documentation.suse.com/cloudnative/virtualization/latest/en/installation-setup/requirements.html)
- [<span id="assignment.2.2" lang="nolang" no>Kubernetes</span> concepts](https://kubernetes.io/docs/concepts/overview/)

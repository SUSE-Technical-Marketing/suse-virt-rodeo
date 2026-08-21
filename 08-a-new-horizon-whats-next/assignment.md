---
slug: a-new-horizon-whats-next
id: qzmycpm7jtwa
type: challenge
title: "<span id="assignment.158" lang="ja" no>🌅 第8章:新たな地平線</span>"
teaser: <span id="assignment.159" lang="ja" hist="vertrex-bank">銀行は完全に<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>で稼働中。ウイニングランを飾り、学んだスキルが自分のデータセンターをどこへ導くか思い描こう。</span>
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
<span id="assignment.160" lang="ja" no>🌅 第8章:新たな地平線
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

<span id="assignment.161" lang="ja" hist="vertrex-bank">ほこりがようやく収まった。データセンターは静まり返り、完璧な調和の中で稼働する<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>ノードの柔らかな緑の光に包まれている。

Vertex Trust銀行はもはや過去に縛られていない。今や、無駄のない高性能なクラウドネイティブ仮想化スタックの上で完全に稼働している。

サラはあなたの隣に立ち、メインスクリーンの統合ダッシュボードを見つめている。*「こんなことが可能だとは思わなかったわ」*と、信じられないというように首を振りながら認める。*「コンテナ化されたマイクロサービスとモノリシックな台帳が、まったく同じ基盤の上で動いているのよ。ストレージは分散され、ネットワークはソフトウェア定義で、ライセンスコストは急落したわ」*

彼女はあなたの方を向き、手を差し出す。*「ありがとう。あなたはただ私たちのインフラを救っただけじゃない——銀行そのものを救ってくれたのよ」*</span>

</div>

<span id="assignment.162" lang="ja" no>## 🏆 あなたの功績

あなたはここでの活動中、驚くべき困難を乗り越えました：

| チャプター | 危機 | 習得したスキル |
|:--------|:-------|:-------------------|
| 🏦 到着 | 沈みゆくレガシーデータセンター | プラットフォームダッシュボード、<span id="assignment.2.8" lang="nolang" no>Longhorn</span>ストレージ、Rancher Primeの調査 |
| 🛗 地下の分断 | 対立する2つのハードウェアサイロ | VMとコンテナを一つの<span id="assignment.2.2" lang="nolang" no>Kubernetes</span>ファブリックに統合 |
| ⚡ フラッシュ・クラッシュ | 市場の暴落 | イメージ、ボリューム、cloud-initを使い数分でVMを展開 |
| 🌊 高まる潮流 | 水没したサーバーラック | ゼロダウンタイムのライブマイグレーションとワンクリックノード退避 |
| 🕵️ 見えざる侵入者 | 横方向への攻撃経路 | ソフトウェア定義VLANと分離されたSDNサブネット |
| ⏪ 信じられないエラー | 削除された1億ドルのレコード | スナップショット、ステージングクローン、ストレージ階層、スケジュール済みのオフクラスターバックアップ |
| 🤠 スタンピード | コンピュート資源の枯渇 | ゴールデンVMテンプレート、オンデマンドで同一構成のフリートを量産 |</span>


<div id="902" class="story">

<span id="assignment.163" lang="ja" hist="vertrex-bank">ヴェルテックス・トラスト銀行での仕事は完了しました——しかし、デジタルフロンティアは広大で、絶えず進化し続けています。設計すべき新しいアーキテクチャや、近代化すべき新しいシステムは常に存在するのです。</span>

</div>


<span id="assignment.164" lang="ja" no>🔐 ログイン認証情報
====================

<span id="assignment.69.1" lang="nolang" no>**SUSE Virtualization**</span> UI と **Rancher Prime** UI は同じ認証情報を使用します。</span>

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



<span id="assignment.165" lang="ja" no>🧭 勝利のラップ:ラボはまだあなたのものです
=======================================

ラボ環境はタイマーが切れるまでアクティブなままです。ダッシュボードをじっくり確認し、あなたが構築したインフラを自由に試してみてください。いくつかのアイデアです:

- **あなたが築き上げた帝国の最終点検をしましょう。**</span>[button label="SUSE Virtualization UI" variant="success"](tab-0)<span id="assignment.166" lang="ja" no><span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span> ページ、あなたが定義した**ネットワーク**、**テンプレート**のブループリント、そして**バックアップとスナップショット**の履歴:今週のあらゆる危機がここに痕跡を残しています。

- **自分だけの危機をデザインしよう。** ゼロから新しいVMを作成:イメージを選び、サイズを決め、cloud-initを設定し、スナップショットを取り、ライブマイグレーションを行います。今回は手順書なし。あなたはもう道を知っています。

- **コマンドラインが気になる方へ(任意):** APIはあなたのものです:

```bash,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get vm -A && kubectl  --kubeconfig .rodeo/harvester-kubeconfig get network-attachment-definitions -A && kubectl --kubeconfig .rodeo/harvester-kubeconfig get VirtualMachineBackup -A
```</span>


<span id="assignment.167" lang="ja" no>🚀 次の目標は？
===============================

- 📖 [SUSE Virtualization Documentation](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)で深い技術アーキテクチャを掘り下げ、スキルを磨き続けましょう。

- 🐮 [<span id="assignment.2.15" lang="nolang" no>SUSE Rancher Prime</span>](https://documentation.suse.com/cloudnative/rancher-manager/latest/en/rancher-manager.html)を使って、**大規模なクラスタ群**（各支社データセンターのあらゆる<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>クラスタを一つのRancher Primeで管理する）の管理方法を学びましょう。

- 🧪 自宅で再現してみましょう：<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>はオープンソースです。ISOを入手し、余っているx86マシンにインストールして、自分自身のVMを動かしてみてください。

- 🤝 この道のりであなたは決して一人ではありません：SUSEの顧客は<span id="assignment.167.1" lang="nolang" no>**SUSE Support**</span>を業界最高水準と評価し続けており、顧客からのフィードバックは製品の進化に直接反映されます。SUSEと共に歩むということは、行列に並ぶチケットではなく、テーブルに着く席を得るということです。それがオープンソースならではの違いです。

- 💬 部屋の一番暗い隅にある**あなたの**レガシークラスタを使ったら、このストーリーがどうなるか、SUSEの担当者に相談してみましょう。</span>

<div id="903" class="story">

<span id="assignment.168" lang="ja" hist="vertrex-bank">一緒に働けたことは、この上ない光栄でした!

**移行、頑張ってください!** 🎉</span>

</div>

<span id="assignment.169" lang="ja" no>📚 詳細情報
===================

- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: 概要](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>の作成](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)
- [ライブマイグレーション](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/live-migration.html)
- [バックアップとリストア](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/backup-restore.html)
- [クラスタネットワーキング](https://documentation.suse.com/cloudnative/virtualization/latest/en/networking/cluster-network.html)</span>

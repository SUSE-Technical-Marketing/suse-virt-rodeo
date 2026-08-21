---
slug: the-subterranean-divide-cluster-prep
id: tmmoesxdhg4b
type: challenge
title: "<span id="assignment.12" lang="ja" hist="vertrex-bank">第2章:地底の分裂</span>"
teaser: <span lang="ja" hist="vertrex-bank" id="ts2">二つのハードウェアサイロ、互いにほとんど言葉を交わさない二つのチーム。データセンターへ降り立ち、ノードのトポロジーをマッピングし、ファブリック内のすべてのディスクに銀行が納得できる価格をつけよ。</span>
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
<span lang="ja" hist="vertrex-bank" id="ts2">二つのハードウェアサイロ、互いにほとんど言葉を交わさない二つのチーム。データセンターへ降り立ち、ノードのトポロジーをマッピングし、ファブリック内のすべてのディスクに銀行が納得できる価格をつけよ。</span>

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

<span id="assignment.13" lang="ja" hist="vertrex-bank">サラはあなたを静かな重役スイートから連れ出し、セキュアなエレベーターへ、そして銀行の地下にあるデータセンターへと下りていく。重厚な鋼鉄製の生体認証ドアが背後でロックされると、周囲の温度が急激に下がる。室内には、工業用冷却システムの耳をつんざくような絶え間ない轟音が響いている。

彼女は部屋の左側を指し示す。そこには、洗練された高密度のサーバーシャーシが並び、青いライトが速い点滅を繰り返している。*「あれがモバイルバンキングAPIを動かしています」*とファンの音に負けじと声を張り上げる。*「純粋なマイクロサービスです。完全にコンテナ化されていて、アジャイルなんです」*

続いて彼女は部屋の右側を指す。そこには巨大で旧式なサーバーキャビネットが立ち並び、不快なほどの熱を放っている。*「そしてあちらが、基幹取引台帳を保持しているレガシーなモノリシック仮想マシンです。まったく異なる二つの世界。二つの異なるハードウェアサイロ。そして、ほとんど会話すらしない二つの異なるエンジニアリングチーム」*

あなたは二列の間を歩きながら、はっきりとした温度差を肌で感じる。*「その隔たりは今日で終わります」*とあなたは彼女に告げる。</span>

</div>

<span id="assignment.14" lang="ja" no>## 一つのファブリック、二つの世界のために

<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> のエレガントなアーキテクチャを説明します。**<span id="assignment.2.2" lang="nolang" no>Kubernetes</span> 基盤**の上に高度なオープンソース技術を活用することで、このプラットフォームは仮想マシンを単に*容認*するだけではありません。仮想マシンを**コンテナエコシステムのネイティブ市民**として扱うのです。重量級の仮想マシンは、俊敏なコンテナと並んで稼働し、まったく同じオーケストレーションエンジンによって管理されます。

| 仮想化の世界 | <span id="assignment.14.1" lang="nolang" no>Container</span> の世界 | <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> 上で統合 |
|---------------------|----------------|-------------------------------|
| ハイパーバイザーホスト | <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> ノード | **同じノード群が両方を実行** |
| ハイパーバイザー管理コンソール | コンテナツール | **一つの基盤プラットフォーム**。<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> が仮想マシンを実行し、Rancher Prime がクラスタとコンテナを制御します |
| SANストレージアレイ | <span id="assignment.2.9" lang="nolang" no>CSI</span> ボリューム | **<span id="assignment.2.8" lang="nolang" no>Longhorn</span> が仮想マシンとポッドの両方にサービスを提供** |

最後の行から始めましょう。すべての仮想マシンディスク、すべてのコンテナの永続ボリューム、そのすべてが同じ分散ストレージファブリック上で動いています。しかし、すべてのワークロードが同じ価格帯に見合うわけではありません。



## 🎯 クエストの目標

1. 物理ノードのトポロジーを確認する
2. 専用のワークスペースを準備する
3. <span id="assignment.2.8" lang="nolang" no>Longhorn</span> がどのようにデータを複製するかを理解する
4. 開発チーム向けにコスト階層別のストレージクラスを構築する



🔐 ログイン認証情報
====================

**<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>** UI と <span id="assignment.2.12" lang="nolang" no>**Rancher Prime**</span> UI は同じ認証情報を使用します。</span>

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


<span id="assignment.15" lang="ja" no>☁️ <span id="assignment.2.8" lang="nolang" no>Longhorn</span>とは何ですか？
====================

<span id="assignment.2.8" lang="nolang" no>Longhorn</span>は、<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>に組み込まれた分散ストレージシステムで、利用することができます。各ノードにある生のディスクをプールし、それらを1つの共有ストレージファブリックにまとめます。

デフォルトでは、作成されるすべてのボリュームは複数のノードにまたがってレプリケートされるため、ディスク障害やノードの再起動によってデータが失われることはありません。SANも不要、専任のストレージチームも不要、VMとコンテナの両方に対応する単一のシステムです。

すぐに使える状態になっていますが、他の<span id="assignment.2.9" lang="nolang" no>CSI</span>を使いたい場合は自由に使うことができます。ベンダーロックインはありません。


🖥️ タスク1：物理ノードのトポロジーを確認する
=============================================



  



以下に移動してください</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.16" lang="ja" no>左側のメニューに移動し、**<span id="assignment.6.1" lang="nolang" no>Hosts</span>**をクリックしてください。

1. リスト内の**ホストのいずれか1つ**の名前をクリックしてください
2. UIを操作しながら、さまざまなオプションを確認し、動作の仕組みをより深く理解してください。仮想マシンのディスク用にraw block deviceがどのようにプロビジョニングされるかを観察してください。ここに表示される各ディスクは、<span id="assignment.2.8" lang="nolang" no>Longhorn</span>の分散ストレージプール<span id="assignment.16.1" lang="ja" hist="vertrex-bank">銀行の元帳を保管する</span>の一部になります。</span>


<div id="203" class="story">
<span id="assignment.17" lang="ja" hist="vertrex-bank">銀行は成長し、この基盤も同様に拡大します。容量不足はもはや複雑なアップグレードではありません。新しいノードをラックに追加し、そのローディスクをプールに加えるだけで、<span id="assignment.2.8" lang="nolang" no>Longhorn</span>が拡大した基盤全体でレプリカを自動的に再バランスし、ダウンタイムもデータ移行のための週末作業も不要です。ストレージ容量はコンピュートと同じ方式でスケールします。オンデマンドで段階的に。</span>
</div>


<span id="assignment.18" lang="ja" no>🏗️ タスク2：専用ワークスペースの準備
========================================



  


プラットフォームは、同一クラスター上の分離された、管理可能なワークスペースである**namespace（名前空間）**にワークロードを分離します。

以下の</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.19" lang="ja" no>左側のメニューから<span id="assignment.19.1" lang="nolang" no>**Namespaces**</span>を選択してください。prodがすでにリストにあることに気づくでしょう。<span id="assignment.19.2" lang="ja" hist="vertrex-bank">プラットフォームチームがあなたの到着前にそれをプロビジョニングしており、そこは銀行の本番ワークロードが稼働する場所です。</span>

では、開発用のものを作成しましょう:

1. <span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックします
2. <span id="assignment.19.4" lang="nolang" no>**Name**</span>を次のように設定します:</span>

<div class="cred">

```txt
dev
```

</div>

<span id="assignment.20" lang="ja" no>3.「<span id="assignment.20.1" lang="nolang" no>**Description**</span>」を次のように設定します。</span>

<div class="cred">

```txt
VMs from dev
```

</div>


<span id="assignment.21" lang="ja" no>4. <span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックします

開発者用ワークスペースがこれで準備完了となり、今後はクォータ、ポリシー、アクセス制御を割り当てることができます。

💾 タスク3: <span id="assignment.2.8" lang="nolang" no>Longhorn</span>がデータをどのように複製するかを理解する
========================================================



  


ストレージバックエンドがどのように健全性を保っているか、その*仕組み*を見てみましょう。<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>がVMやPodに渡すすべてのディスクは**<span id="assignment.2.8" lang="nolang" no>Longhorn</span>ボリューム**であり、すべての<span id="assignment.2.8" lang="nolang" no>Longhorn</span>ボリュームは<span id="assignment.21.1" lang="nolang" no>**StorageClass**</span>から作成されます。これは、とりわけ、常時データのコピーがいくつ存在するかを決定するポリシーです。</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.22" lang="ja" no>、<span id="assignment.22.1" lang="nolang" no>**Advanced > Storage Classes**</span> に移動し、harvester-longhorn をクリックします。

<span id="assignment.22.2" lang="nolang" no>**Number Of Replicas**</span> フィールドに注目してください。これは **3** に設定されています。このクラスから作成される各ボリュームは、3つの異なるノードに分散された3つの完全なコピーを持ちます。</span>

<div id="204" class="story">
<span id="assignment.23" lang="ja" hist="vertrex-bank">取引台帳にとってはまさにその通りです。ノードを1台失っても、書き込み中にディスクが1台失われても、データは無傷のまま残ります。</span>
</div>

<span id="assignment.24" lang="ja" no>では、内部の仕組みを見て、<span id="assignment.2.8" lang="nolang" no>Longhorn</span>がどのようにデータを保存しているか確認しましょう。

1. 次の場所に移動します</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.25" lang="ja" no>ホストの<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>のいずれかにSSHで接続します:
```bash,run
rodeo ssh harvester1
```
2. <span id="assignment.25.1" lang="nolang" no>harvester1</span>ノードの<span id="assignment.2.8" lang="nolang" no>Longhorn</span>フォルダを確認します。いくつかのフォルダとファイルが表示されます:
```bash,run
ls /var/lib/harvester/defaultdisk
```
3. replicasフォルダの中には、このノードが保持するボリュームレプリカごとに1つのフォルダがあります:
```bash,wrap,run
ls /var/lib/harvester/defaultdisk/replicas/
```
4. exitと入力してホストから抜けます:
```bash,run
exit
```

> [!NOTE]
> レプリカが3つあるということは、ディスクの使用量が3倍になるということです。これは本番環境の予算においては正しいトレードオフです。しかし、金曜日には削除される開発者の使い捨てテストVMにとっては無駄です。レプリカ数は物理法則ではなく**ポリシー**であり、ポリシーはワークロードごとに調整可能です。

🧅 タスク4: 開発チーム向けのコスト階層ストレージクラスを構築する
=====================================================================



  



開発チームはサンドボックス用に本番グレードのレプリケーションを必要とせず、安価で高速なイテレーションを必要としています。<span id="assignment.25.2" lang="ja" hist="vertrex-bank">彼らには専用のストレージ層が与えられます。それは、実際の性質どおり――使い捨てとして価格設定されています。</span>

に</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.26" lang="ja" no>、<span id="assignment.22.1" lang="nolang" no>**Advanced > Storage Classes**</span>の下で:

1. <span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックします
2. <span id="assignment.19.4" lang="nolang" no>**Name**</span>を次のように設定します:</span>

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

Two StorageClasses sit side by side in the list: `harvester-longhorn` (3 replicas, production) and <b class="highlightcopy">harvester-longhorn-1rep</b> (1 replica for dev sandboxes, at a third of the disk cost). <span id="assignment.29" lang="ja" hist="vertrex-bank">開発チームは、今後の章でディスポーザブルVMを起動するたびに、このティアを利用することになります。</span>

> [!NOTE]
> One replica means **zero redundancy**, lose that single node and the volume is gone. That is an acceptable risk for a sandbox nobody depends on overnight, and a very deliberate trade-off you are making on the record, not an accident. Storage classes can also encode disk tags to steer workloads to specific hardware, production on fast NVMe, development on cheaper spindles.

🏋️ Bonus Drills: for the command-line curious (optional)
==========================================================

<div style='align: middle; margin: 15px;'>
  <img class="animatedgif" src="../assets/chapter2_video5.gif"/>
</div>


New to <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Skip ahead freely.** If you are curious, everything you just did in the UI is also visible through the <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> API, open the </span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.30" lang="ja" no>- **UI ストレージクラスを API オブジェクトとして確認する**: ワークスペースと両方のストレージ階層を確認します:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get namespace dev -o wide; kubectl --kubeconfig .rodeo/harvester-kubeconfig get storageclasses;
```

- **新しいワークスペースにラベルを付ける** ことで、今後の自動化がこのワークスペースを簡単に対象にできるようにします:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig label namespace dev stage=dev
```

💼 なぜこれが重要なのか？
==============================================

- **サイロが消滅します。** VM とコンテナはノード、ストレージ、そして一つの運用チームを共有します。データセンターの「温度の分断」はなくなります。
- **再教育の崖はありません。** コンテナチームの <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> スキルが VM 資産の管理も行えるようになり、VM チームは <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> API に支えられた使い慣れたポイント＆クリック UI を手に入れます。
- **ネームスペースがガバナンスをもたらします。** 財務ワークロードは独自のクォータ、ポリシー、アクセス制御を持つ `prod` に配置されます。監査担当者はこれを気に入るでしょう。
- **ストレージには今や価格表があります。** レプリケーションはデフォルトではなくダイヤルです。本番データは必要だから3つのコピーを持ち、使い捨てのサンドボックスは必要以上のコストをかけるべきではないので1つだけ持ちます。</span>

<div id="202" class="story">

<span id="assignment.31" lang="ja" hist="vertrex-bank">サラがあなたの肩越しに見守る中、新しいワークスペースと二つのストレージ階層が次々とダッシュボードに現れる。彼女の顔にかすかな笑みが浮かぶ。*「基盤は盤石ね。さあ、始めましょう」*</span>

</div>

<span id="assignment.32" lang="ja" no>続けるには <span id="assignment.32.1" lang="nolang" no>**Check**</span> をクリックしてください。⚡


📚 詳細情報
===================</span>

- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Storage: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/storage/overview.html)

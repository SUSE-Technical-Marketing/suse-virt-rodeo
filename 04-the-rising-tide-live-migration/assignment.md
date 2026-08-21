---
slug: the-rising-tide-live-migration
id: xjv2r0tfyztq
type: challenge
title: "<span id="assignment.65" lang="ja" hist="vertrex-bank">🌊 第4章:高まる潮</span>"
teaser: <span id="assignment.66" lang="ja" hist="vertrex-bank">冷却材漏れにより、決済ゲートウェイをホストするラックが浸水しています。ハードウェアがショートする前に、トランザクションを継続させながらゼロダウンタイムのライブマイグレーションを実行してください。</span>
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
<span id="assignment.67" lang="ja" hist="vertrex-bank">🌊 第4章:高まる潮</span>
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

<span id="assignment.68" lang="ja" hist="vertrex-bank">トレーディングフロアでの事件のアドレナリンがまだ体内から抜けきらないうちに、データセンターの壁を通して重く金属的なうめき声が響き渡る。あなたとサラは同時に**ラック4**の方を振り向いた。頭上で一次冷却バルブが破裂し、冷たく化学処理された水が絶え間なく流れ落ち、銀行の基幹**決済ゲートウェイ**をホストする物理サーバーシャーシに直撃していた。

*「あのサーバーがショートしたら、ゲートウェイが落ちる」*水がたまっていくのを見つめながら、サラの声に本物のパニックが忍び寄る。*「ゲートウェイが落ちれば、Vertex Trust銀行のクレジットカード取引が一件残らず失敗する。朝までには連邦規制当局の調査に直面することになるわ」*

*「落とさせはしない」*あなたはそう答えながら、キーボードの上で指を高速に走らせる。</span>

</div>

<span id="assignment.69" lang="ja" no>以下のマシンを停止してから移動させることはできません。トランザクションストリームは非常に重要で、1秒間に何千ものリクエストを処理しています。**ライブマイグレーション**を実行し、稼働中の仮想マシンをメモリごと別の物理ノードへ、**ダウンタイムゼロ**で移動させる必要があります。

しかしその前に、緊急マイグレーションに最大限の帯域を確保するため、近くにある重要度の低いバッチ処理サーバーを一時停止させることにします。



## 🎯 クエストの目標

1. 重要度の低いワークロードを一時停止してリソースを解放する
2. サービスのハートビートを確立する
3. ライブマイグレーションを実行する
4. シームレスな転送を監視する
5. 通常の運用を再開する
6. 損傷したラックを修理チームに引き渡す



🔐 ログイン認証情報
====================

<span id="assignment.69.1" lang="nolang" no>**SUSE Virtualization**</span> UIと**Rancher Prime** UIは同じ認証情報を使用します。</span>

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



<span id="assignment.72" lang="ja" no>⏸️ タスク1：非重要なワークロードを一時停止してリソースを解放する
===========================================================</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.73" lang="ja" no>、<span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>に移動します:

1. 次の名前の仮想マシンを見つけます:</span>

<div class="cred">

```txt
daily-batch-processor
```

</div>

<span id="assignment.74" lang="ja" no>2. 行の右側にある をクリックします
3. <span id="assignment.74.1" lang="nolang" no>**Pause**</span> を選択し、確認を求められたら <span id="assignment.74.2" lang="nolang" no>**Apply**</span> をクリックします。
4. 状態が <span id="assignment.74.3" lang="nolang" no>**Paused**</span> に変わるまで待ちます

これによりCPUサイクルが停止し、緊急操作に最大限のハードウェアリソースが割り当てられます。

> [!NOTE]
> これは実際には必要ありません。ライブマイグレーショントラフィック用の専用ネットワークはすでに設定済みです。ここでは教育目的のために記載しています</span>



<span id="assignment.75" lang="ja" no>📡 タスク2: サービスハートビートの確立
========================================


  


次に切り替えて</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.76" lang="ja" no>継続的なハートビートモニターが必要です。避難中もネットワーク接続が切断されていないことを証明するためです。

<span id="assignment.76.1" lang="nolang" no><b class="highlightcopy">webserver-prod</b></span> からハートビートモニターを起動してください。

```bash,run
ssh -o StrictHostKeyChecking=accept-new  sles@[[ Instruqt-Var key="PAYMENT_GATEWAY_IP" hostname="kvm-host" ]] 'ping 192.168.122.1'

```

> [!IMPORTANT]
> pingはターミナルで継続的に実行させたままにしてください。**停止しないでください。** この流れ続ける応答は、ダウンタイムがゼロであることの証拠です。<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> UIに再びフォーカスを戻してください。</span>

<span id="assignment.77" lang="ja" no>🚚 タスク3: ライブマイグレーションの実行
=====================================


  


以下の</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.78" lang="ja" no>、**<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>** に移動し、次のインスタンスを見つけます。</span>

<div class="cred">

```txt
webserver-prod
```

</div>

<span id="assignment.79" lang="ja" no>1. <span id="assignment.79.1" lang="nolang" no>**Node**</span> 列を確認し、ゲートウェイがどのノードで稼働しているかを**書き留めてください**。移動したことを証明する材料になります
2. その行の一番右にある  をクリックします
3. コンテキストメニューから <span id="assignment.79.2" lang="nolang" no>**Migrate**</span> を選択します
4. ドロップダウンリストから、別の安全な移動先ノードを選択します
5. <span id="assignment.74.2" lang="nolang" no>**Apply**</span> をクリックします

裏側では、<span id="assignment.2.3" lang="nolang" no>KubeVirt</span> がVMのライブメモリページをネットワーク経由で移動先ノードへコピーし、稼働中のゲートウェイが移行の最中に変更(ダーティ化)したページを追跡しては再コピーする、という処理を繰り返します。そして最終的に実行を凍結し、瞬時に切り替えて、新しいノード上で実行を再開します。</span>

<span id="assignment.80" lang="ja" no>👀 タスク4: シームレスな移行を監視する
========================================


  


直ちに戻って</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.81" lang="ja" no>タブを確認し、pingシーケンスを見守ります。</span>

<div id="402" class="story">

<span id="assignment.82" lang="ja" hist="vertrex-bank">息を止めて見守る中、<span id="ch1.intro1.1" lang="nolang" no>hypervisor</span>がネットワーク越しの大規模なメモリ転送を調整していく。画面をスクロールし続けるpingは**まったく途切れることがない**。仮想マシンが新しい物理ノードへとシームレスに具現化するのとほぼ同時に、ラック4では水濡れした筐体から火花が飛び始めていた。</span>

</div>

<span id="assignment.83" lang="ja" no>`Ctrl+C`を押してpingを終了します。</span>

<div id="403" class="story">
<span id="assignment.84" lang="ja" hist="vertrex-bank">息を鋭く吐き出す。トランザクションフローは持ちこたえた。</span>
</div>


<span id="assignment.85" lang="ja" no>厳密に言えば、ハンドオーバーの瞬間は*確かに*存在する。メモリコピーが収束すると、実行が新しいノードに切り替わる間、VMは最後の一瞬だけ停止する、いわばマイクロ中断だ。適切な規模のインフラであれば完全に気づかれることなく通過するし、この仮想化の中の仮想化の、そのまた中の仮想化を実行しているこのラボでさえ、せいぜいpingのレイテンシが少し高くなる程度しか気づかなかっただろう。</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.86" lang="ja" no>、webserver-prodの<span id="assignment.79.1" lang="nolang" no>**Node**</span>列が、あなたが書き留めたものとは**異なるノード**を示しています。</span><span id="assignment.87" lang="ja" hist="vertrex-bank">ゲートウェイは物理的に移動したが、顧客はまったく気づかなかった。</span>

<div id="404" class="story">
<span id="assignment.88" lang="ja" hist="vertrex-bank">サラが規制当局に提出する証拠を作成してください——ゲストの稼働時間カウンターは一度もリセットされておらず、これはオペレーティングシステムが一度も停止していないことを意味します。</span>
</div>

```bash,wrap,run
ssh -o StrictHostKeyChecking=accept-new  sles@[[ Instruqt-Var key="PAYMENT_GATEWAY_IP" hostname="kvm-host" ]] "hostname && uptime"
```

<span id="assignment.89" lang="ja" no>▶️ タスク5:通常運用の再開
===================================


  


以下に戻る</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.90" lang="ja" no>先ほど一時停止した仮想マシンを見つけます。</span>

<div class="cred">

```txt
daily-batch-processor
```

</div>

<span id="assignment.91" lang="ja" no>1. その行にある をクリックします
2. <span id="assignment.91.1" lang="nolang" no>**Unpause**</span> を選択して、緊急性の低いジョブを再開できるようにします

🛠️ タスク6: 破損したラックを修理チームに引き渡す
====================================================</span>


<div id="405" class="story">
<span id="assignment.92" lang="ja" hist="vertrex-bank">ゲートウェイは安全です――しかし、水損したノードはまだ水が滴り続けており、より小さなワークロードがその上でまだ稼働している可能性があります。床に水たまりが広がる中、それらを一つずつ移行するようなことはしません。プラットフォームに管理させましょう。</span>
</div>


<span id="assignment.93" lang="ja" no>The text to translate appears to be empty or cut off — only "In the" was included. Could you paste the full text you'd like translated to Japanese?</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.94" lang="ja" no>、<span id="assignment.94.1" lang="nolang" no>**Hosts**</span>に移動します。

1. 移行**前**にwebserver-prodが稼働していたノードを探してください。書き留めておいたものです。</span>

<i id="406" class="story"><span id="assignment.95" lang="ja" hist="vertrex-bank">それは水害を受けた機械です</span></i>

<span id="assignment.96" lang="ja" no>2. その行の  をクリックし、<span id="assignment.96.1" lang="nolang" no>**Enable Maintenance Mode**</span> を選択し、次に <span id="assignment.96.2" lang="nolang" no>confirm</span> を選択します

次に **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>** ページを見てください。障害ノード上で稼働していたすべてのVMが**自動的に**ライブマイグレーションでそこから退避します。プラットフォームが正常なターゲットノードを選び、ワークロードを1つずつ移動させ、ノードを空にします。スプレッドシートも、手動でのターゲット選定も、VMの移し忘れも一切ありません。

> [!NOTE]
> このラボ環境では、これに多少時間がかかることがあります。

ノードが <span id="assignment.96.3" lang="nolang" no>**Maintenance**</span> と表示され、VM数が0になったら、(仮想の)修理チームが(仮想の)冷却バルブを交換します。ノードをサービスに復帰させましょう。

3. その行の  を再度クリックし、<span id="assignment.96.4" lang="nolang" no>**Uncordon**</span> を選択し、次に <span id="assignment.96.5" lang="nolang" no>**Disable Maintenance Mode**</span> を選択します

ノードはファブリックに再参加し、再びワークロードを受け入れる準備が整います。

> [!NOTE]
> 同じ知性は逆方向でも機能します。新しいVMが作成されるたびに、スケジューラーは最も負荷の低い適切なノードにそれを配置し、クラスターを自然にバランスの取れた状態に保ちます。手動でのテトリスは不要です。入ってくる際の自動配置と出ていく際の自動退避のあいだで、人間が決めるのは*何を*実行するかだけであり、*どこで*実行するかはプラットフォームが決めます。</span>

<span id="assignment.97" lang="ja" no>🏋️ ボーナスドリル：マイグレーションの記録証跡（コマンドラインが好きな方向け、任意）
======================================================================================


  


<span id="assignment.2.2" lang="nolang" no>Kubernetes</span> は初めてですか？**遠慮なく読み飛ばしてください。** そうでなければ：すべてのマイグレーションはそれ自体が <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> オブジェクトであり、つまり監査可能だということです。その中で</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.98" lang="ja" no>- **移行記録を確認する**（誰が、いつ、どこからどこへ移動したか）:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachineinstancemigrations -A
```

- **完了した移行の詳細を確認する:**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig describe virtualmachineinstancemigrations -A | grep -A 10 "Status"
```

- **先を見据える:** 誰も移行できないうちに、警告もなく*ノード*が故障したらどうなるだろうか？各VMの実行戦略を確認しよう: <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>は障害の発生したホストからVMを自動的に再スケジュールできる:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get vm -A -o custom-columns=NAME:.metadata.name,RUNSTRATEGY:.spec.runStrategy
```

> [!NOTE]
> **コンピュートを超えて:** ゼロダウンタイムという同じ発想は*ディスク*にも当てはまる。<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>は**インプレースのストレージライブマイグレーション**（VMを停止せずに、稼働中のVMのボリュームをストレージバックエンド間で移動すること。例えば<span id="assignment.2.8" lang="nolang" no>Longhorn</span>から外部の<span id="assignment.2.9" lang="nolang" no>CSI</span>アレイへ）をサポートしている。コンピュートは今夜退避し、ストレージは来四半期に退避する——そしてゲートウェイはどちらにも気づくことはない。</span>

<span id="assignment.99" lang="ja" no>💼 なぜこれが重要なのか?
==============================================

- **ハードウェア障害が障害にならなくなる。** 冷却液漏れ、ファームウェアの更新、ホストの再起動などが発生しても、サービスが稼働し続けたまま、ワークロードは正常なノードへとスムーズに移行します。
- **深夜のメンテナンス時間帯が不要に。** **メンテナンスモード** をワンクリックするだけで、ノード全体のワークロードが自動的に排出(ドレイン)されます。定期的なパッチ適用は深夜2時ではなく午後2時に行えるようになり、どのVMがどこで稼働しているかをスプレッドシートで管理する必要もなくなります。
- **監査担当者が読める監査証跡。** すべてのマイグレーションはAPIオブジェクトとして記録され、コンソールのスクリーンショットから何が起きたかを再構築する必要はもうありません。

続行するには **Check** をクリックしてください。🕵️

📚 詳細情報
===================</span>

- [Live Migration](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/live-migration.html)

---
slug: the-unthinkable-error-snapshots
id: nkrkc4vyyywt
type: challenge
title: '<span id="assignment.116" lang="ja" hist="vertrex-bank">⏪ 第6章:ありえないエラー</span>'
teaser: <span id="assignment.117" lang="ja" hist="vertrex-bank">滑ったカーソルが、1億ドルの決済記録を削除してしまった。VMスナップショットで時間を巻き戻し、安全なステージング環境の複製で復旧を確認したら、定期的なオフクラスターバックアップで保護を恒久化しよう。</span>
tabs:
- id: lygpkmkmyndn
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: gofsbdvdnoyj
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: 4accqnqjfweo
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: intermediate
timelimit: 3600
enhanced_loading: null
---
<span id="assignment.118" lang="ja" hist="vertrex-bank">⏪ 第6章:<span id="assignment.118.1" lang="ja" no>考えられない誤り</span>
===================================</span>

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

<img class="logos" alt="Welcome!" src="../assets/06-chapter-img.png"/>

<div id="601" class="story">

<span id="assignment.119" lang="ja" hist="vertrex-bank">翌朝、夜勤の疲れ切った静寂が、若手データベース管理者のデスクからくぐもった悲鳴によって突然破られる。

あなたとサラはすぐに駆け寄る。若手管理者は恐怖に顔をこわばらせて画面を見つめ、キーボードの上で手を震わせていた。基幹取引台帳サーバー上の古い一時ファイルを削除しようとしていたところ、カーソルが滑ってしまったのだ。誤って間違ったディレクトリに対して再帰的な削除コマンドを実行してしまった。

わずか数分前に確定したばかりの、一億ドル規模の企業間取引決済記録が、ディスクから完全に消去されてしまった。

*「僕が壊してしまった」*管理者は震えながら囁く。*「バックアップテープの実行は深夜零時までありません。データは、もう消えてしまったんです」*

サラは目を閉じ、こめかみを揉みながら、これが銀行の株価と評判に与える壊滅的な打撃を覚悟する。しかし、あなたは管理者の肩に落ち着いた手を置く。

*「データは消えていない」*あなたは冷静に言う。*「うちの新しいストレージアーキテクチャは、分散ブロックレベルのスナップショットに基づいている。朝のシフトが始まる直前に、ベースラインの状態キャプチャを取得しておいた」*

あなたは彼の端末に歩み寄る。時計の針を巻き戻す時が来た。だが、慎重を期さねばならない。**復元したデータは、本番環境に上書きする前に、安全なサンドボックスで検証する**必要がある。</span>

</div>

<span id="assignment.120" lang="ja" no>## 🎯 あなたのクエストの目標

1. レコードの作成と削除をシミュレートする
2. スナップショットからステージング環境をクローンする
3. ステージングサンドボックスでデータを確認する
4. 本番システムを復元する
5. <span id="assignment.120.1" lang="nolang" hist="vertrex-bank">bank's off-cluster backup vault</span>を接続する
6. バックアップのスケジュールを設定する



🔐 ログイン認証情報
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



<span id="assignment.121" lang="ja" no>💥 タスク1：レコードの作成と削除をシミュレートする
==============================================================


  


今朝の出来事を自分自身で再現し、スナップショットが何を保護しているのかを正確に理解します。

In the</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.122" lang="ja" no>仮想マシンにログインします(VMが起動するまで数分かかる場合があります):

```bash,wrap,run
while [[ "${IPA}" ==  "" ]]; do IPA=`kubectl --kubeconfig .rodeo/harvester-kubeconfig get vmi core-services -n prod -o jsonpath='{.status.interfaces[0].ipAddress}'|grep -v ':'`; sleep 5; echo -n '.'; done ; while [[ "$?" != "0" ]] ; do ssh -T -o StrictHostKeyChecking=accept-new sles@${IPA} 2>/dev/null ; sleep 5; done ; ssh -o StrictHostKeyChecking=accept-new sles@${IPA}

```

次のコマンドを正確に入力して、非常に機密性の高い取引記録をディスク上に生成します:

```bash,wrap,run
echo "CLIENT: BRUCE WAYNE | AMOUNT: 100,000,000 | STATUS: CLEARED" > /home/sles/ledger.txt
```

**では、ベースラインを取得しましょう。** 次に切り替えます</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.123" lang="ja" no>1. <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>に移動し、次のVMを見つけて、その横にあるボタンをクリックします。</span>

<div class="cred">

```txt
core-services
```

</div>
<span id="assignment.124" lang="ja" no>2. <span id="assignment.124.1" lang="nolang" no>**Take Virtual Machine Snapshot**</span>をクリックします
3. 次のように名前を付けます:</span>

<div class="cred">

```txt
pre-disaster-backup
```

</div>

<span id="assignment.125" lang="ja" no>4. <span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックします

5. <span id="assignment.125.1" lang="nolang" no>**Backup and Snapshots**</span>に移動し、次に<span id="assignment.125.2" lang="nolang" no>**Virtual Machine Snapshots**</span>をクリックして、先ほど作成したものの状態が<span id="assignment.125.3" lang="nolang" no>**Ready**</span>になるまで待ちます。これでロールバックポイントが設定されます</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.126" lang="ja" no>百万ドル、ディスクから消えました。VMコンソールを終了します。

```bash,run
exit
```


🧪 タスク2: スナップショットからステージング環境をクローンする
========================================================


  


すぐに本番環境を復元するのではなく、まず**クローン**を作成してデータを確認します。非破壊的な復旧は常に推奨されます。</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.127" lang="ja" no>1. <span id="assignment.125.1" lang="nolang" no>**Backup and Snapshots**</span>に移動し、<span id="assignment.125.2" lang="nolang" no>**Virtual Machine Snapshots**</span>をクリックします

2. <span id="assignment.127.1" lang="nolang" no>**pre-disaster-backup**</span>のスナップショットをクリックします

3. その横の を クリックし、<span id="assignment.127.2" lang="nolang" no>**Restore New**</span>を選択します

4. 新しい仮想マシンに名前を付けます:</span>


<div class="cred">

```txt
core-services-staging-verify
```

</div>


<span id="assignment.128" lang="ja" no>5. <span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックします


> [!Note]
> このラボで使用しているハードウェアの都合上、この処理には通常より時間がかかります。次のタスクに進んでください。



🏦 タスク3：クラスタ外バックアップボールトを接続する
======================================================


  


今朝はスナップショットが助けになりましたが、スナップショットはワークロードと**同じクラスタ**上に存在します。うっかり操作からは保護されますが、物理的な損傷やサイバー攻撃からは保護されません。真の災害復旧のためには、クラスタ外の**バックアップボールト**を運用します。これは別のストレージシステム上にあるNFS共有です。それでは接続してみましょう。</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.129" lang="ja" no>1. <span id="assignment.129.1" lang="nolang" no>**Advanced > Settings**</span>に移動し、以下を確認します。</span>

<div class="cred">

```txt
backup-target
```

</div>
<span id="assignment.130" lang="ja" no>2. その行の  をクリックし、<span id="assignment.130.1" lang="nolang" no>**Edit Setting**</span>を選択し、以下を追加します。

- <span id="assignment.110.2" lang="nolang" no>**Type**</span>: <span id="assignment.130.2" lang="nolang" no><b class="highlightcopy">NFS</b></span>
- <span id="assignment.130.3" lang="nolang" no>**Endpoint**</span>:</span>

<div class="cred">

```txt
192.168.122.1:/srv/backups/
```

</div>

<span id="assignment.131" lang="ja" no>3. <span id="assignment.114.7" lang="nolang" no>**Save**</span>をクリック

これでクラスターはVMの完全なバックアップをクラスター外に送信できるようになりました。真夜中のテープ交換作業の現代版、ただし真夜中抜きです。**S3**バケットはエンドポイントとして問題なく機能します。本番環境では、物理的に離れた施設を指定することになるでしょう。


⏰ タスク4：バックアップのスケジュール設定
====================================</span>

<div id="602" class="story">
<span id="assignment.132" lang="ja" hist="vertrex-bank">アドホックスナップショットはその日を一度だけ守れるが、ポリシーは毎日確実にバンクを安全に保つ。</span>
</div>

<span id="assignment.133" lang="ja" no>core-services自体を自動バックアップスケジュールの対象にし、二度と誰も手動で行うことを覚えておく必要がないようにしましょう。</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.134" lang="ja" no>1. <span id="assignment.134.1" lang="nolang" no>**Backup & Snapshot > Virtual Machine Schedules**</span>に移動し、<span id="assignment.134.2" lang="nolang" no>**Create schedule**</span>をクリックします
2. 次の詳細を設定します:

  - <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: <span id="assignment.55.2" lang="nolang" no><b class="highlightcopy">prod</b></span>
  - <span id="assignment.134.3" lang="nolang" no>**Virtual Machine Name**</span>: <span id="assignment.134.4" lang="nolang" no><b class="highlightcopy">core-services</b></span>
  - <span id="assignment.134.5" lang="nolang" no>**Basics**</span>:
    - <span id="assignment.134.6" lang="nolang" no>**Retain:**</span> 5
    - <span id="assignment.134.7" lang="nolang" no>**Max Failure:**</span> 2
    - <span id="assignment.134.8" lang="nolang" no>**Cron Schedule:**</span>(0分、5時間ごと)</span>

<div class="cred">

```txt
0 */5 * * *
```

</div>


<span id="assignment.135" lang="ja" no>4. <span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックします

これ以降、プラットフォームは5時間ごとにVMをNFSボールトにバックアップし、直近5件のコピーを保持し、2回連続で失敗した場合はスケジュールを一時停止します。一度設定すれば、永続的に保護されます。



🔍 タスク5: ステージングサンドボックスのデータを検証する
=================================================


  


core-services-staging-verifyが起動して実行中になったので、ファイルが存在することを確認しましょう。

今回は、VMにネットワークがないため、グラフィカルコンソールを使用します。

その中で</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.136" lang="ja" no>1. <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>に移動します
2. <span id="assignment.61.1" lang="nolang" no>**Console**</span>ドロップダウンをクリックして<span id="assignment.136.1" lang="nolang" no>**Open in WebVNC**</span>を選択すると、ターミナルを含む新しいウィンドウが表示されます。サイズは自由に変更できます。
3. 以下の認証情報でログインします:
   - <span id="assignment.136.2" lang="nolang" no>**username**</span>: 'sles'
   - <span id="assignment.136.3" lang="nolang" no>**password**</span>: '1234'

4. 中に入ったら、以下のコマンドを実行します:</span>


<div class="cred">

```txt
cat /home/sles/ledger.txt
```

</div>

<span id="assignment.137" lang="ja" no>5. 次のように返されるはずです:

**CLIENT: BRUCE WAYNE | AMOUNT: 100,000,000 | STATUS: CLEARED**


テキストが完璧に表示されます。<span id="assignment.137.1" lang="ja" hist="vertrex-bank">データは安全です。</span>


それでは、不要になったクローンを削除しましょう。

1. コンソールのウィンドウを閉じます。
2. **core-services-staging-verify** 行の  をクリックし、<span id="assignment.137.2" lang="nolang" no>**Delete**</span>を選択し、もう一度<span id="assignment.137.2" lang="nolang" no>**Delete**</span>を選択します。



♻️ タスク6: 本番システムを復元する
=========================================


  


スナップショットの整合性を確認したので、本番システムの復元に進みます:

1. **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>**に移動します
2. **core-services** 行の  をクリックし、<span id="assignment.137.3" lang="nolang" no>**Stop**</span>を選択し、もう一度<span id="assignment.74.2" lang="nolang" no>**Apply**</span>を選択します。
3. 完全に停止したら、<span id="assignment.125.1" lang="nolang" no>**Backup and Snapshots**</span>に移動し、<span id="assignment.125.2" lang="nolang" no>**Virtual Machine Snapshots**</span>をクリックします

4. **pre-disaster-backup** スナップショットをクリックします:

5. その隣の をクリックし、<span id="assignment.137.4" lang="nolang" no>**Replace Existing**</span>を選択します

6. <span id="assignment.19.3" lang="nolang" no>**Create**</span>をクリックします

VMは自動的に起動します。これは実行戦略で定義されているためです。

必要であれば、SSHで再接続してファイルをもう一度 `cat` し、VMからログアウトしてください。<span id="assignment.137.5" lang="ja" hist="vertrex-bank">記録は元あるべき場所に戻った。</span>


🏋️ ボーナスドリル: セーフティネットの仕組みを見る(任意)
======================================================================

- **コマンドラインに興味がある方へ:** 各VMスナップショットはボリュームレベルのスナップショットから構築されており、それぞれがAPIオブジェクトです。新しいバックアップスケジュールも同様です:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get VirtualMachineBackup -A; kubectl --kubeconfig .rodeo/harvester-kubeconfig get volumesnapshots -A; kubectl --kubeconfig .rodeo/harvester-kubeconfig get schedulevmbackups -A
```

> [!NOTE]
> このコマンドを実行する前に、必ずVMからログアウトしてください。


💼 なぜこれが重要なのか?
==============================================

- **人的ミスが致命的でなくなります。** 復旧は「深夜のテープを待って祈る」から、5分間のセルフサービスによるロールバックへと変わりました。
- **上書きする前に検証する。** クローンに復元するということは、未検証のバックアップに本番環境を賭けることが決してないということです。これは監査担当者にも新米管理者にも安心してもらえるパターンです。
- **保護は今や英雄的行為ではなく、方針です。** クラスタ外のNFSバックアップボールトと5時間ごとのバックアップスケジュールにより、これ以降セーフティネットは自動的に機能します。

続けるには<span id="assignment.32.1" lang="nolang" no>**Check**</span>をクリックしてください。🤠

📚 詳細情報
===================</span>

- [Virtual Machine Backup and Restore](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/backup-restore.html)

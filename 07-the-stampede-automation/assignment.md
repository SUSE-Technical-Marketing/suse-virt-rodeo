---
slug: the-stampede-automation
id: euwnv5ojhvfl
type: challenge
title: "<span id="assignment.138" lang="it" no>\U0001F920 Capitolo 7: La fuga precipitosa</span>"
teaser: <span id="assignment.139" lang="it" hist="vertrex-bank">I mercati sono in caduta libera e i quant hanno bisogno di scalare la flotta di calcolo da tre a cinque nodi, subito. Forgia un template VM golden e stampa macchine identiche su richiesta.</span>
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
<span id="assignment.140" lang="it" no>🤠 Capitolo 7: La fuga precipitosa
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

<span id="assignment.141" lang="it" hist="vertrex-bank">Un improvviso e aggressivo mutamento dei tassi di interesse globali getta i mercati finanziari in una frenesia caotica. Gli algoritmi di analisi del rischio della Vertex Trust Bank chiedono a gran voce maggiore capacità di calcolo per elaborare l'ondata in arrivo di volatili dati di mercato.

*"Un solo motore di calcolo non basta più!"* grida l'**Head of Quant** dall'altra parte della stanza, sventolando un report stampato. *"Ho bisogno subito di una flotta di cinque motori identici, o voleremo alla cieca dentro questo crollo del mercato!"*

Configurare cinque macchine a mano, una schermata alla volta, espone proprio a ciò che non ci si può permettere adesso: una dimensione di memoria digitata male qui, una rete dimenticata lì. Disallineamento della configurazione sotto pressione — e in questo momento, l'errore umano costa milioni di dollari **al secondo**.

Ti scrocchi le nocche. Ciò di cui la banca ha bisogno è un **golden blueprint**: definire la macchina perfetta una volta sola, per poi sfornare copie identiche su richiesta.</span>

</div>

<span id="assignment.142" lang="it" no><span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> ha esattamente questo: i **template di VM**. Un template racchiude CPU, memoria, dischi, reti e cloud-init in un unico oggetto con versione. Combinato con la **creazione multi-istanza**, un singolo blueprint diventa un'intera flotta con un solo clic.



## 🎯 Obiettivi della tua missione

1. Forgia il golden template
2. Scala la flotta sotto pressione
3. Ritira la flotta



🔐 Credenziali di accesso
====================

L'interfaccia utente di <span id="assignment.69.1" lang="nolang" no>**SUSE Virtualization**</span> e l'interfaccia utente di **Rancher Prime** utilizzano le stesse credenziali.</span>

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



<span id="assignment.143" lang="it" no>📜 Attività 1: Forgia il golden template
====================================


  


Hai bisogno di un template che velocizzi la distribuzione delle macchine virtuali e le standardizzi.
In</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.144" lang="it" no>vai a <span id="assignment.144.1" lang="nolang" no>**Advanced > Templates**</span> e fai clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span>, quindi inserisci i seguenti dettagli:

- <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: prod
- <span id="assignment.144.2" lang="nolang" no>**Template Name**</span>:</span>

<div class="cred">

```txt
prod-basic
```

</div>

<span id="assignment.145" lang="it" no>Dobbiamo ridurre al minimo l'uso delle risorse e tutte le VM devono essere raggiungibili tramite la chiave SSH di produzione, che è custodita in modo sicuro.

- Informazioni di base:
  - <span id="assignment.42.1" lang="nolang" no>**CPU**</span>: 1
  - <span id="assignment.145.1" lang="nolang" no>**Memory**</span>: 1
  - <span id="assignment.45.1" lang="nolang" no>**SSHKey**</span>: prod/default

Il nostro sistema operativo di base predefinito è SLES 16.

- <span id="assignment.6.4" lang="nolang" no>Volumes</span>:
  - <span id="assignment.45.2" lang="nolang" no>**Image**</span>: official-images/SLES-16.0-Minimal-VM.x86_64-Cloud-GM.qcow2
  - <span id="assignment.45.3" lang="nolang" no>**Size**</span>: 5

Vogliamo che i server di produzione offrano i loro servizi sulla rete di servizi di produzione.

- <span id="assignment.49.1" lang="nolang" no>Networks</span>:
  - <span id="assignment.49.2" lang="nolang" no>**Network**</span>: prod/service

Tutte le VM di produzione dovrebbero essere eseguite solo su host pronti per la produzione.

- <span id="assignment.51.1" lang="nolang" no>Node Scheduling</span>:
  1. Seleziona <span id="assignment.51.5" lang="nolang" no>**Run virtual machine on node(s) matching scheduling rules**</span>
  2. Fai clic su <span id="assignment.51.6" lang="nolang" no>**Add Node Selector**</span>, quindi su <span id="assignment.51.7" lang="nolang" no>**Add Rule**</span>:


- <span id="assignment.51.8" lang="nolang" no>**Key**</span>:</span>

<div class="cred">

```txt
stage
```

</div>

<span id="assignment.52" lang="it" no>- **Valore**:</span>

<div class="cred">

```txt
prod
```

</div>


<span id="assignment.146" lang="it" no>Vogliamo che le VM siano etichettate correttamente:

- <span id="assignment.53.1" lang="nolang" no>Labels</span>:
  - Fare clic su <span id="assignment.53.3" lang="nolang" no>**Add Label**</span>:


- <span id="assignment.51.8" lang="nolang" no>**Key**</span>:</span>
<div class="cred">

```txt
stage
```

</div>

<span id="assignment.52" lang="it" no>- **Valore**:</span>
<div class="cred">

```txt
prod
```

</div>


<span id="assignment.147" lang="it" no>Infine, vogliamo che tutte le macchine di produzione siano standardizzate su un insieme di pacchetti e impostazioni:

- <span id="assignment.54.1" lang="nolang" no>Advanced Options</span>:
  - <span id="assignment.54.4" lang="nolang" no>**User Data Template**</span>: prod/prod

Per finalizzare, fai clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span>.

Riesci a immaginare di dover inserire tutti questi dettagli ogni volta? Le persone si arrenderebbero e l'ambiente si riempirebbe di incoerenze, e l'incoerenza rende un'ulteriore automazione ancora più difficile.


> [!NOTE]
> I modelli sono **versionati**. Se in seguito modifichi il modello, viene creata una nuova versione, mentre le macchine create a partire dalle versioni precedenti mantengono la loro derivazione: una traccia di audit completa di ciò che è stato distribuito da ciascun blueprint, cosa che i tuoi organismi di regolamentazione apprezzeranno.


📈 Attività 2: Scalare la flotta sotto pressione
=========================================

Poiché il modello esiste già, distribuire più server richiede solo pochi clic.


  


In</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.148" lang="it" no>vai a **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>** e fai clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span>, quindi inserisci i seguenti dettagli:

1. Seleziona <span id="assignment.148.1" lang="nolang" no>**Multiple Instance**</span>
2. Imposta <span id="assignment.39.3" lang="nolang" no>**Namespace**</span> su prod
3. Imposta <span id="assignment.148.2" lang="nolang" no>**Name Prefix**</span> su:</span>

<div class="cred">

```txt
appcluster
```

</div>


<span id="assignment.149" lang="it" no>4. Imposta <span id="assignment.149.1" lang="nolang" no>**Count**</span> su 2
5. Seleziona <span id="assignment.149.2" lang="nolang" no>**Use VM Template**</span> e imposta <span id="assignment.149.3" lang="nolang" no>**Template**</span> su prod/prod-basic
6. Fai clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span></span>




<div id="702" class="story">

<span id="assignment.150" lang="it" hist="vertrex-bank">Il team di analisi del rischio inizia a immettere dati nella flotta ampliata, stabilizzando la posizione di mercato della banca giusto in tempo.</span>

</div>


<span id="assignment.151" lang="it" no>🧹 Attività 3: Smobilitare la flotta
===============================</span>

<div id="703" class="story">

<span id="assignment.152" lang="it" hist="vertrex-bank">L'impennata del mercato si placa. Le macchine virtuali restano inattive, in attesa della prossima ondata — ma arriverà oggi? Domani? Il mese prossimo? Per questi nobili server, l'attesa è più dolorosa del macinare tutti quei numeri.</span>

</div>

<span id="assignment.153" lang="it" no>Non hai più bisogno di così tante macchine virtuali, eliminale tutte in una volta (non preoccuparti se si stanno ancora avviando).





In</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.154" lang="it" no>passare alla sezione <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>:

1. Selezionare <span id="assignment.154.1" lang="nolang" no>**checkboxes**</span> accanto a tutte le nuove macchine virtuali create
2. Fare clic su <span id="assignment.137.2" lang="nolang" no>**Delete**</span>, selezionare <span id="assignment.154.2" lang="nolang" no>**Delete All**</span> e fare clic su <span id="assignment.154.3" lang="nolang" no>**Delete**
</span></span>

<div id="704" class="story">

<span id="assignment.155" lang="it" hist="vertrex-bank">La sofferenza di queste nobili macchine virtuali è cessata. Vedi le fiamme, figlio mio? Ora riposano nel Valhalla.</span>

</div>




<span id="assignment.156" lang="it" no>🏋️ Esercizi bonus: per i curiosi della riga di comando (opzionale)
==========================================================

Nuovo su <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Salta pure avanti.** Altrimenti, dimostra nel</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.157" lang="it" no>che la UI, la flotta e l'API siano tutte concordi:

- **Ispeziona il template come oggetto API**: anche i template e le loro versioni sono risorse:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplates,virtualmachinetemplateversions -n prod
```

- **Recupera la definizione del template in formato yaml**:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplates -n prod prod-basic -o yaml > template_prod-basic.yaml
template_version_name=`kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplateversions -n prod -o name |grep '/prod-basic-'`
kubectl --kubeconfig .rodeo/harvester-kubeconfig get -n prod ${template_version_name} -o yaml >> template_prod-basic.yaml
```

Puoi esaminare il file `template_prod-basic.yaml`:


```bash,wrap,run
less template_prod-basic.yaml
```


Contiene una definizione simile a quella utilizzata per creare il template nel Task 2.



💼 Perché è importante?
==============================================

- **Elasticità su hardware di proprietà.** <span id="assignment.157.1" lang="it" hist="vertrex-bank">Scale-out (e scale-in) in stile cloud nel data center di proprietà della banca: nessuna questione sulla residenza dei dati, nessuna fattura per il traffico in uscita.</span>
- **L'errore umano viene eliminato alla radice.** Le macchine derivano da un golden blueprint con controllo di versione, non dalla memoria e dal lavoro manuale: il configuration drift non può verificarsi alle 2 di notte.
- **Economia dell'intero ciclo di vita.** La dismissione richiede solo una casella di spunta e un clic, quindi la capacità temporanea non si trasforma mai in un costo permanente, l'esatto opposto del vecchio <span id="ch1.intro1.1" lang="nolang" no>hypervisor</span> sprawl.

Fai clic su <span id="assignment.32.1" lang="nolang" no>**Check**</span> per continuare. ⚔️

📚 Maggiori informazioni
===================</span>

- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Creating <span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)

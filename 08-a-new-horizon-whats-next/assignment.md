---
slug: a-new-horizon-whats-next
id: qzmycpm7jtwa
type: challenge
title: "<span id="assignment.158" lang="it" no>🌅 Capitolo 8: Un nuovo orizzonte</span>"
teaser: <span id="assignment.159" lang="it" hist="vertrex-bank">La banca funziona interamente su <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>.
  Fai un giro d'onore, ripassa tutto ciò che hai padroneggiato e pianifica dove le tue nuove competenze
  possono portare il tuo datacenter.</span>
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
<span id="assignment.160" lang="it" no>🌅 Capitolo 8: Un nuovo orizzonte
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

<span id="assignment.161" lang="it" hist="vertrex-bank">La polvere si è finalmente posata. Il datacenter è silenzioso, immerso nel tenue bagliore verde dei <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> nodi che operano in perfetta armonia.

Vertex Trust Bank non è più incatenata al passato. Ora gira interamente su uno stack di virtualizzazione snello, ad alte prestazioni e cloud-native.

Sarah è accanto a te, con lo sguardo rivolto alla dashboard unificata sullo schermo principale. *"Non pensavo fosse possibile",* ammette, scuotendo la testa incredula. *"Stiamo eseguendo microservizi containerizzati e registri monolitici esattamente sullo stesso fabric. Il nostro storage è distribuito, le nostre reti sono software-defined e i nostri costi di licenza sono appena crollati."*

Si volta verso di te e ti tende la mano. *"Grazie. Non hai solo salvato la nostra infrastruttura — hai salvato la banca."*</span>

</div>

<span id="assignment.162" lang="it" no>## 🏆 Le tue imprese

Hai superato avversità incredibili durante la tua permanenza qui:

| Capitolo | Crisi | Abilità padroneggiata |
|:---------|:------|:----------------------|
| 🏦 L'arrivo | Un datacenter legacy che affonda | Ispezione della dashboard della piattaforma, dello storage <span id="assignment.2.8" lang="nolang" no>Longhorn</span> e di Rancher Prime |
| 🛗 La spaccatura sotterranea | Due silos hardware in guerra tra loro | Unione di VM e container su un unico fabric <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> |
| ⚡ Il Flash Crash | Un crollo del mercato | Distribuzione di VM in pochi minuti con immagini, volumi e cloud-init |
| 🌊 La marea crescente | Un rack server allagato | Live migration senza tempi di inattività ed evacuazione del nodo con un clic |
| 🕵️ L'intruso invisibile | Un percorso di attacco laterale | VLAN software-defined e subnet SDN isolate |
| ⏪ L'errore impensabile | Un record da 100 milioni di dollari eliminato | Snapshot, cloni di staging, tier di storage e backup pianificati off-cluster |
| 🤠 La stampida | Una carestia di risorse di calcolo | Template di VM golden, sfornando flotte identiche su richiesta |</span>


<div id="902" class="story">

<span id="assignment.163" lang="it" hist="vertrex-bank">Il tuo lavoro presso Vertex Trust Bank è concluso — ma la frontiera digitale è vasta e in continua evoluzione. Ci sono sempre nuove architetture da progettare e nuovi sistemi da modernizzare.</span>

</div>


<span id="assignment.164" lang="it" no>🔐 Credenziali di accesso
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



<span id="assignment.165" lang="it" no>🧭 Giro d'onore: il laboratorio è ancora tuo
=======================================

L'ambiente del laboratorio rimarrà attivo fino allo scadere del timer. Sentiti libero di esplorare la dashboard e sperimentare con l'infrastruttura che hai creato. Alcune idee:

- **Fai un inventario finale dell'impero che hai costruito.** Esplora la</span>[button label="SUSE Virtualization UI" variant="success"](tab-0)<span id="assignment.166" lang="it" no>: la pagina <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>, le **Networks** che hai definito, il blueprint dei **Templates** e la cronologia di **Backup & Snapshot**: ogni crisi della settimana ha lasciato il segno qui.

- **Progetta la tua crisi.** Crea una nuova VM da zero: scegli l'immagine, definisci le dimensioni, configurala con cloud-init, crea uno snapshot, eseguine la live migration. Niente istruzioni questa volta. Sai come fare.

- **Per i curiosi della riga di comando (opzionale):** l'API è tutta tua:

```bash,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get vm -A && kubectl  --kubeconfig .rodeo/harvester-kubeconfig get network-attachment-definitions -A && kubectl --kubeconfig .rodeo/harvester-kubeconfig get VirtualMachineBackup -A
```</span>


<span id="assignment.167" lang="it" no>🚀 Qual è il tuo prossimo orizzonte?
===============================

- 📖 Mantieni affilate le tue competenze esplorando nel dettaglio l'architettura tecnica nella [Documentazione di SUSE Virtualization](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html).

- 🐮 Scopri come gestire **flotte di questi cluster su larga scala** (un unico Rancher Prime per gestire ogni cluster <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> in ogni data center di filiale) con [<span id="assignment.2.15" lang="nolang" no>SUSE Rancher Prime</span>](https://documentation.suse.com/cloudnative/rancher-manager/latest/en/rancher-manager.html).

- 🧪 Ricrealo a casa: <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> è open source. Scarica l'ISO, installala su qualsiasi macchina x86 disponibile ed esegui le tue VM.

- 🤝 Non sei mai solo lungo questo percorso: i clienti SUSE valutano costantemente <span id="assignment.167.1" lang="nolang" no>**SUSE Support**</span> tra i migliori del settore, e il feedback dei clienti plasma direttamente l'evoluzione dei prodotti. Lavorare con SUSE significa avere un posto al tavolo, non un ticket in coda. Questa è la differenza dell'open source.

- 💬 Parla con il tuo referente SUSE per scoprire come sarebbe questa storia con il **tuo** cluster legacy nell'angolo più buio della stanza.</span>

<div id="903" class="story">

<span id="assignment.168" lang="it" hist="vertrex-bank">È stato un assoluto onore lavorare al tuo fianco!

**Buona migrazione!** 🎉</span>

</div>

<span id="assignment.169" lang="it" no>📚 Ulteriori informazioni
========================

- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Panoramica](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Creazione di <span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)
- [Migrazione live](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/live-migration.html)
- [Backup e ripristino](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/backup-restore.html)
- [Rete del cluster](https://documentation.suse.com/cloudnative/virtualization/latest/en/networking/cluster-network.html)</span>

---
slug: the-arrival-welcome
id: ermykdy1tbse
type: challenge
title: "<span id="assignment.7" lang="it" hist="vertrex-bank">🏦 Capitolo 1: L'arrivo</span>"
teaser: <span id="assignment.8" lang="it" hist="vertrex-bank">Vertex Trust Bank sta affogando nei costi legacy. <span id="ch1.intro1.1" lang="nolang" no>hypervisor</span>
  Entra nella sala del consiglio, prendi il comando di SUSE Virtualization
  e ispeziona il tuo nuovo centro di comando.</span>
notes:
- type: text
  contents: |
    <span id="assignment.1" lang="it" no># Benvenuti al <span id="assignment.1.1"  lang="nolang" no>SUSE Virtualization Rodeo!</span>

    Attendere mentre prepariamo l'ambiente di laboratorio.</span><span lang="it" id="ch1.waiting1" hist="vertrex-bank">La pioggia sferza le finestre della sede centrale di Vertex Trust Bank...
    Sarah, la CTO, ti sta aspettando nella sala riunioni.</span>
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

<span id="assignment.9" lang="it" hist="vertrex-bank">🏦 Capitolo 1: L'Arrivo</span>
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
<span lang="it" id="ch1.intro1" hist="vertrex-bank">La pioggia sferzava le vetrate a tutta altezza della sede centrale della Vertex Trust Bank, deformando lo skyline della città in una sfocatura grigia e acquosa. All'interno della sala riunioni dirigenziale dalle pareti di vetro, l'atmosfera era altrettanto turbolenta. Sarah, la Chief Technology Officer, percorreva avanti e indietro la stanza, con gli occhi fissi su un enorme monitor sospeso che proiettava un mare di avvisi rossi e segnalazioni di prestazioni.

Si voltò verso di te, la voce tesa per la stanchezza. *"Stiamo perdendo millisecondi preziosi su ogni singola transazione di mercato. I nostri <span id="ch1.intro1.1" lang="nolang" no>hypervisor</span> legacy stanno cedendo sotto il volume enorme del traffico bancario digitale moderno. L'infrastruttura è fragile, gli array di storage perdono continuamente la sincronizzazione e i costi di licenza stanno prosciugando completamente il nostro budget di ingegneria. Non possiamo sopravvivere un altro anno incatenati a questi sistemi monolitici e antiquati."*

Siedi in silenzio in fondo al tavolo di mogano, esaminando gli schemi architetturali che ti ha fornito. In qualità di **Infrastructure Architect** d'élite, sei stato chiamato per uno scopo preciso: salvare la Vertex Trust Bank dalla paralisi operativa totale. Hanno bisogno di un ponte verso il mondo cloud-native senza ricostruire da zero l'intero stack applicativo.

*"Abbiamo un piano, Sarah,"* dici infine, chiudendo il laptop con un clic rassicurante. *"Trasferiremo l'intero datacenter a <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>. Porteremo i vostri sistemi legacy nell'era moderna, e lo faremo senza perdere un colpo."*</span>
</div>


<span id="assignment.2" lang=it no>Il tuo viaggio inizia proprio adesso. Prima di poter iniziare a smantellare il vecchio mondo, devi stabilire un punto d'appoggio nel nuovo e immergerti nell'ambiente.



## Che cos'è <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>?

<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> (noto anche come **<span id="assignment.2.1" lang="nolang" no>Harvester</span>**) è una moderna piattaforma open source di infrastruttura iperconvergente (HCI) costruita su <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>. Viene eseguita direttamente su bare metal e offre alla banca **macchine virtuali** di livello enterprise su una base cloud-native, <span id="ch1.intro2"  lang="it" hist="vertrex-bank">esattamente il ponte di cui Vertex Trust Bank ha bisogno</span>:

- **<span id="assignment.2.3" lang="nolang" no>KubeVirt</span> + <span id="assignment.2.4" lang="nolang" no>KVM</span>/<span id="assignment.2.5" lang="nolang" no>QEMU</span>**: virtualizzazione enterprise come workload nativi di <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>. Al di sotto si trova la stessa collaudata coppia **<span id="assignment.2.4" lang="nolang" no>KVM</span>/<span id="assignment.2.5" lang="nolang" no>QEMU</span>** che da decenni alimenta la virtualizzazione <span id="assignment.2.6" lang="nolang" no>Linux</span>, motivo per cui la piattaforma è in grado di eseguire un'enorme varietà di sistemi operativi guest, <span id="ch1.intro3"  lang="it" hist="vertrex-bank">compresi quelli molto vecchi ancora in servizio negli angoli legacy più polverosi della banca, in paziente attesa della loro migrazione</span>
- **<span id="assignment.2.7" lang="nolang" no>SUSE Storage</span> (<span id="assignment.2.8" lang="nolang" no>Longhorn</span>)**: storage a blocchi distribuito e replicato su ogni nodo, già configurato e pronto all'uso. <span id="ch1.intro4"  lang="it" hist="vertrex-bank">E se la banca dovesse mai preferire uno storage diverso</span>, **qualsiasi driver di storage compatibile con <span id="assignment.2.9" lang="nolang" no>CSI</span> si integra direttamente**, libertà di scelta, mai lock-in
- **<span id="assignment.2.10" lang="nolang" no>Software-defined networking</span>**: VLAN e reti overlay isolate senza toccare un cavo
- **Un'unica fattura open source**: nessuna tassa <span id="ch1.intro1.1" lang="nolang" no>hypervisor</span> per socket
- **<span id="assignment.2.11" lang="nolang" no>Support</span> che ascolta davvero**: i clienti SUSE valutano costantemente **SUSE <span id="assignment.2.11" lang="nolang" no>Support</span>** tra i migliori del settore, e il loro feedback determina direttamente la direzione futura dei prodotti. Prova a chiedere a un fornitore closed source un posto a quel tavolo

Poiché la piattaforma viene eseguita *su* <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>, i workload containerizzati possono girare sullo stesso identico cluster. Tieni ben chiara la divisione dei compiti fin dal primo giorno: l'interfaccia utente di <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> gestisce le **macchine virtuali**; la gestione dei container (e di intere flotte di cluster) è compito di <span id="assignment.2.12" lang="nolang" no>**Rancher Prime**</span>, che incontrerai tra un istante.

<span id="ch1.intro5"  lang="it" hist="vertrex-bank">Ogni componente proprietario che prosciuga il budget della banca ha un sostituto moderno e open source:</span>

| Il vecchio mondo (licenze per socket) | <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> |
|--------------------------------------|---------------------|
| <span id="ch1.intro1.1" lang="nolang" no>hypervisor</span> proprietario ISAware | <span id="assignment.2.3" lang="nolang" no>KubeVirt</span> + <span id="assignment.2.4" lang="nolang" no>KVM</span> |
| Array di storage proprietario |  Storage SUSE, o qualsiasi driver <span id="assignment.2.9" lang="nolang" no>CSI</span> <span id="ch1.intro6"  lang="it" hist="vertrex-bank">la banca sceglie</span> |
| SDN closed source | <span id="assignment.2.13" lang="nolang" no>Kube-OVN</span> + <span id="assignment.2.14" lang="nolang" no>Multus</span> |
| ISAware Command Throne | <span id="assignment.2.15" lang="nolang" no>SUSE Rancher Prime</span> |

Nessun vendor lock-in. Nessuna tassa sulla virtualizzazione. Nessun kernel proprietario. **Una piattaforma, una fattura**, <span id="ch1.intro7"  lang="it" hist="vertrex-bank">esattamente quello che avevi promesso a Sarah nella sala riunioni</span>.



## 🎯 Gli obiettivi della tua missione

1. Accedi ed esamina la dashboard unificata
2. Incontra Rancher Prime, il centro di comando!
3. Convalida il fabric di storage distribuito
4. Verifica il tuo accesso al terminale amministrativo




<span id="ch1.intro8"  lang="it" hist="vertrex-bank">> [!NOTE]
> Disclaimer: questo lab ha uno scopo didattico e non intende fornire istruzioni su come configurare un ambiente di produzione per una "banca"; la maggior parte delle decisioni prese dipende dalle limitazioni e dalle finalità di questo ambiente.</span>




🔐 Le tue credenziali di Architetto
===================================

Per tua referenza, le tue credenziali di Architetto sono le seguenti:</span>


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


<span id="assignment.3" lang=it> [!NOTE]
> Le interfacce utente utilizzano certificati autofirmati. Accetta l'avviso di sicurezza del browser quando viene visualizzato. Se una pagina non si carica subito, l'ambiente del laboratorio potrebbe essere ancora in fase di avvio. Attendi un minuto e aggiorna la scheda.

> [!NOTE]
> Se preferisci lavorare nel tuo browser invece che nelle schede incorporate, l'host del laboratorio è raggiungibile direttamente all'indirizzo:
> https://kvm-host.[[ Instruqt-Var key="_SANDBOX_ID" hostname="kvm-host" ]].instruqt.io:8443




📊 Attività 1: Accedi ed esamina la dashboard unificata
=======================================================

Vai alla</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.4" lang=itscheda e accedi utilizzando le tue credenziali.

![01-connect_to_cluster.gif](../assets/chapter1-connect_to_cluster.gif)

Prenditi un momento per osservare la principale</span>  <span id="assignment.5" lang="nolang" no>**Dashboard**</span><span id="assignment.6" lang=it: questo è il tuo centro di comando per l'intera missione.


> [!NOTE]
> Non apportare ancora alcuna modifica. Stiamo solo prendendo confidenza con l'ambiente.


- La prima sezione contiene i numeri complessivi:
  - **<span id="assignment.6.1" lang="nolang" no>Hosts</span>** di cui è composto il cluster
  - **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>** (in esecuzione e arrestate)
  - **<span id="assignment.6.3" lang="nolang" no>Images</span>** disponibili per distribuire nuove VM
  - **<span id="assignment.6.4" lang="nolang" no>Volumes</span>** in uso
  - **<span id="assignment.6.5" lang="nolang" no>Disks</span>** disponibile

Facendo clic su ciascuno di essi si accede a una sezione dedicata con ulteriori informazioni. Fai clic su **<span id="assignment.6.1" lang="nolang" no>Hosts</span>**:

Vedrai una vista dettagliata delle risorse riservate e utilizzate da ciascun host, oltre agli indirizzi IP dell'host e ad altri dettagli.

Nota il  alla fine di ogni riga: facendo clic su di esso si apre un menu con diverse azioni per quell'host.

Torna alla **<span id="assignment.6.6" lang="nolang" no>Dashboard</span>** e osserva cos'altro c'è:

- La seconda sezione, **<span id="assignment.6.7" lang="nolang" no>Capacity</span>**, elenca le risorse attualmente riservate e disponibili nel cluster.

- Sotto di essa si trova una sezione con due schede:

  - **<span id="assignment.6.8" lang="nolang" no>Cluster Metrics</span>**: metriche in tempo reale sul cluster; tornano utili quando si risolvono problemi di prestazioni.

  - **<span id="assignment.6.9" lang="nolang" no>Virtual Machine Metrics</span>**: metriche in tempo reale per le macchine virtuali; nota che se nessuna VM è in esecuzione non ci sono dati da mostrare.

- In fondo, l'ultima sezione, **<span id="assignment.6.10" lang="nolang" no>Events</span>**, mostra gli ultimi eventi che si verificano nel cluster.

Ora esplora ulteriormente l'interfaccia utente. In alto a destra c'è un menu a discesa con **All Namespaces** selezionato. Ti consente di concentrarti su namespace specifici. I namespace qui sono namespace di <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>: un modo per organizzare le risorse e assegnare autorizzazioni dedicate a tutto ciò che contengono, un concetto simile a un "gruppo". In fondo a questo capitolo troverai link con maggiori informazioni; molti dei concetti presenti in <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> si applicano direttamente a <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>.

La **campanella** contiene notifiche e avvisi, e più a destra l'**icona utente** ti porta alle impostazioni utente e alle chiavi per l'accesso automatizzato.

Sul lato sinistro c'è una colonna con diverse sezioni. Non le esamineremo tutte adesso. Ne vedrai molte nei prossimi capitoli. Nota che queste sezioni cambiano a seconda dei plugin abilitati o disabilitati.

Infine, nell'angolo in basso a sinistra, fai clic su **<span id="assignment.2.11" lang="nolang" no>Support</span>**.
Ti porta a una pagina con link alla documentazione e ad altre risorse di supporto, oltre a due sezioni importanti:

- **<span id="assignment.6.11" lang="nolang" no>Generate a <span id="assignment.2.11" lang="nolang" no>Support</span> Bundle</span>**: genera un file che aiuta il <span id="assignment.2.11" lang="nolang" no>Support</span> SUSE a risolvere i problemi del tuo ambiente senza dovervi accedere direttamente.
- **<span id="assignment.6.12" lang="nolang" no>Download KubeConfig</span>**: ti fornisce il file kubeconfig che puoi usare per gestire questo cluster con kubectl e altri strumenti da una console.

Se hai ancora tempo, prendi confidenza con le sezioni prima di passare all'attività successiva.


> [!NOTE]
> Tutto ciò che vedi in questa dashboard (VM, volumi, reti) è, sotto il cofano, una risorsa di <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>. L'interfaccia utente è il tuo strumento principale per questa missione; un terminale è pronto per le esercitazioni bonus facoltative, se sei curioso di conoscere i meccanismi interni.



🐮 Attività 2: Conosci Rancher Prime, il centro di comando
=================================================

La piattaforma può anche essere collegata a **Rancher Prime**, <span id="ch1.task2a"  lang="it" hist="vertrex-bank">ed è importante capire chi fa cosa nel nuovo mondo della banca:</span>

- <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> gestisce le **macchine virtuali** su questo cluster.
- **Rancher Prime** gestisce **molti cluster contemporaneamente** (ogni cluster <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> in ogni datacenter di filiale), oltre a **utenti, ruoli e controllo degli accessi (<span id="assignment.6.13" lang="nolang" no>RBAC</span>)** centralizzati e ai **carichi di lavoro container** che la banca eseguirà accanto alle sue VM.

Vediamo cosa c'è dentro Rancher.

Apri la [button label="Rancher Prime UI" variant="success"](tab-2), accedi con le stesse credenziali e seleziona **Virtualization Management** dal menu a sinistra.


  


Da qui puoi gestire più cluster <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>. Importa quello esistente:

1. Fai clic su **Import Existing**
2. Imposta il **Cluster Name** su


```txt
mysusevirt1
```



3. Fai clic su **Create**
4. Appare una nuova schermata. Su di essa viene mostrato un url: copialo per i passaggi successivi.
5. Sotto di esso puoi vedere le istruzioni di registrazione. Seguile e ricorda di selezionare **<span id="assignment.6.14" lang="nolang" no>Insecure Skip TLS Verify</span>** quando modifichi l'impostazione cluster-registration-url. Questa operazione va eseguita nella [button label="SUSE Virtualization UI" variant="success"](tab-0).

6. Torna alla [button label="Rancher Prime UI" variant="success"](tab-2) e fai clic su "<span id="assignment.2.1" lang="nolang" no>Harvester</span> Clusters" in alto a sinistra nell'interfaccia utente.

Nota lo stato accanto al nome del cluster: **<span id="assignment.6.15" lang="nolang" no>Pending</span>**. Sta aspettando che il cluster completi il processo di registrazione.

Rimani nell'interfaccia utente di Rancher e osserva lo stato passare da **<span id="assignment.6.15" lang="nolang" no>Pending</span>** a **<span id="assignment.6.16" lang="nolang" no>Waiting</span>** e infine a **<span id="assignment.6.17" lang="nolang" no>Active</span>**.

Ora torna a **<span id="assignment.2.1" lang="nolang" no>Harvester</span> Clusters**: il cluster appare nell'elenco.

Vediamo cos'altro puoi fare qui. Fai clic sul  alla fine della riga del cluster; si apre un menu a discesa con alcune opzioni:

- **<span id="assignment.6.18" lang="nolang" no>Kubectl Shell</span>**: apre una shell connessa al cluster, dove puoi eseguire comandi kubectl su di esso.
- **<span id="assignment.6.12" lang="nolang" no>Download KubeConfig</span>**: lo stesso che hai già visto nell'interfaccia utente di <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>.
- **<span id="assignment.6.19" lang="nolang" no>Download YAML</span>**: scarica la definizione del cluster in formato YAML; puoi usarla come modello per importare nuovi cluster in modo automatizzato (richiede anche un passaggio aggiuntivo nell'interfaccia utente del cluster).

Infine, fai clic sul nome stesso del cluster
- ti porta all'interfaccia utente di <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> incorporata nell'interfaccia utente di Rancher
- Nota che nella colonna di sinistra appare nel menu una voce '<span id="assignment.6.13" lang="nolang" no>RBAC</span>': possiamo controllare chi può fare cosa sui nostri cluster.


Con Rancher puoi gestire facilmente più cluster da un unico posto.



> [!NOTE]
> Esiste un rodeo dedicato a SUSE Rancher Prime, sentiti libero di partecipare!



⌨️ Attività 3: Verifica il tuo accesso amministrativo da terminale
===================================================

Trascorrerai la maggior parte di questa missione nell'interfaccia utente, <span id="ch1.task3a"  lang="it" hist="vertrex-bank">ma un architetto verifica sempre il proprio accesso di emergenza</span>. Fai clic sulla scheda [button label="Cluster Terminal" variant="success"](tab-1) ed esegui un comando per verificare che la connessione al motore <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> sottostante sia attiva:


```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get VirtualMachine -A
```

Dovresti vedere l'elenco delle <span id="assignment.6.2" lang="nolang" no>Virtual Machines</span> presenti in ogni namespace.



💾 Esercitazione bonus: convalida il fabric di storage distribuito (facoltativa)
====================================================================

<span id="ch1.bonus1a"  lang="it" hist="vertrex-bank">Un backend di storage integro è fondamentale per le operazioni bancarie</span>. <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> usa **<span id="assignment.2.7" lang="nolang" no>SUSE Storage</span>** per replicare ogni volume nel cluster.


  


La [button label="SUSE Virtualization UI" variant="success"](tab-0) mostra già informazioni sullo stato dello storage, ma è anche possibile accedere alla dashboard di <span id="assignment.2.7" lang="nolang" no>SUSE Storage</span> (<span id="assignment.2.8" lang="nolang" no>Longhorn</span>) abilitando le **Extension developer features**:

1. Fai clic sulla tua **icona utente** nell'angolo in alto a destra
2. Seleziona **Preferences**
3. Spunta **Enable Extension developer features**

Torna a **Home** e nell'angolo in basso a sinistra fai clic su **<span id="assignment.2.11" lang="nolang" no>Support</span>**.

Vedrai ora due nuove sezioni:

- **<span id="assignment.6.20" lang="nolang" no>Access Embedded</span> Rancher UI**
- **<span id="assignment.6.20" lang="nolang" no>Access Embedded</span> <span id="assignment.2.7" lang="nolang" no>SUSE Storage</span> (<span id="assignment.2.8" lang="nolang" no>Longhorn</span>) UI**

Fai clic sulla sezione **<span id="assignment.2.8" lang="nolang" no>Longhorn</span> UI**.

Ti porterà alla <span id="assignment.6.6" lang="nolang" no>Dashboard</span> di <span id="assignment.2.7" lang="nolang" no>SUSE Storage</span>: dovrebbe essere tutto verde.
Se un nodo fosse non schedulabile o un volume degradato, <span id="assignment.2.7" lang="nolang" no>SUSE Storage</span> starebbe già ricostruendo le repliche altrove, ma la verità sul campo va sempre confermata di persona.


🏋️ Esercitazioni bonus: per i curiosi della riga di comando (facoltative)
==========================================================

Nuovo a <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Salta pure avanti**: tutto ciò che conta è nell'interfaccia utente. Se vuoi dare un'occhiata ai meccanismi interni, esegui questi controlli aggiuntivi nel [button label="Cluster Terminal" variant="success"](tab-1):

- **Visualizza il control plane di <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> e gli endpoint CoreDNS:**

```bash,wrap,run
kubectl cluster-info --kubeconfig .rodeo/harvester-kubeconfig
```

- **Controlla lo stato dei componenti del cluster**: interroga l'endpoint di integrità del control plane; ogni controllo (etcd, informer, hook di arresto) dovrebbe riportare `ok`:

```bash,wrap,run
kubectl get --raw='/readyz?verbose' --kubeconfig .rodeo/harvester-kubeconfig
```

- **Conferma che ogni nodo del fabric sia pronto:**

```bash,wrap,run
kubectl get nodes --kubeconfig .rodeo/harvester-kubeconfig
```

  Tutti i nodi dovrebbero mostrare `Ready`.

- **Verifica che i servizi di virtualizzazione principali siano in esecuzione:**

```bash,wrap,run
kubectl get pods -n harvester-system --kubeconfig .rodeo/harvester-kubeconfig | grep -v Completed
```

  Tutti i pod dovrebbero essere `Running`.

- **Conferma la versione esatta della piattaforma in uso presso la banca:**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get settings.harvesterhci.io server-version
```

💼 Perché è importante?
==============================================

- **Un unico centro di comando.** VM, storage e rete sono visibili da un'unica dashboard, niente più destreggiarsi tra tre console di gestione separate con tre licenze separate.
- **Nativo <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> fin dal primo giorno.** Tutto ciò che si trova nella dashboard è, sotto il cofano, una risorsa di <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>. Le competenze esistenti del team container si trasferiscono direttamente, mentre il team VM ottiene un'interfaccia utente intuitiva e point-and-click.
- **Gestione della flotta e <span id="assignment.6.13" lang="nolang" no>RBAC</span> inclusi.** Rancher Prime è <span id="ch1.why1"  lang="it" hist="vertrex-bank">pronto a gestire ogni cluster che la banca utilizzerà in futuro, con un unico login e un unico insieme di regole di accesso.</span>
- **Storage distribuito pronto all'uso.** <span id="assignment.2.7" lang="nolang" no>SUSE Storage</span> replica automaticamente i dati tra i nodi.

Una volta confermato che il control plane risponde, che lo storage è integro e che il tuo accesso amministrativo è protetto, sei pronto per addentrarti ulteriormente nella struttura.

Fai clic su **Check** per scendere nel datacenter. 🛗

📚 Maggiori informazioni
===================</span>


- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Hardware and Network Requirements](https://documentation.suse.com/cloudnative/virtualization/latest/en/installation-setup/requirements.html)
- [<span id="assignment.2.2" lang="nolang" no>Kubernetes</span> concepts](https://kubernetes.io/docs/concepts/overview/)

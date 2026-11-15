---
slug: the-subterranean-divide-cluster-prep
id: tmmoesxdhg4b
type: challenge
title: "<span id="assignment.12" lang="it" hist="vertrex-bank">🚧 Capitolo 2: La Frattura Sotterranea</span>"
teaser: <span lang="it" hist="vertrex-bank" id="ts2">Due silos hardware, due team che a malapena si parlano. Scendi nel datacenter,
  mappa la topologia dei nodi e assegna a ogni disco del fabric un prezzo che la banca
  possa accettare.</span>
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
<span lang="it" hist="vertrex-bank" id="ts2">Due silos hardware, due team che a malapena si parlano. Scendi nel datacenter,
  mappa la topologia dei nodi e assegna a ogni disco del fabric un prezzo che la banca
  possa accettare.</span>

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

<span id="assignment.13" lang="it" hist="vertrex-bank">Sarah ti conduce fuori dalle silenziose suite dirigenziali, in un ascensore di sicurezza, e giù nel datacenter sotterraneo della banca. La temperatura ambiente cala bruscamente mentre le pesanti porte biometriche in acciaio si chiudono alle vostre spalle. La sala vibra del rombo assordante e incessante dei sistemi di raffreddamento industriali.

Indica il lato sinistro della sala, dove file di chassis server eleganti e densamente stipati lampeggiano con rapide luci blu. *"Quelli eseguono le nostre API di mobile banking,"* grida sopra il rumore delle ventole. *"Puri microservizi. Completamente containerizzati e agili."*

Poi indica il lato destro della sala, dominato da enormi e arcaici armadi server che irradiano una quantità di calore fastidiosa. *"E quelle sono le macchine virtuali monolitiche legacy che contengono i registri delle transazioni principali. Due mondi completamente diversi. Due silos hardware diversi. Due team di ingegneri diversi che a malapena si parlano."*

Cammini tra le due file, percependo la netta differenza di temperatura. *"Questa divisione finisce oggi,"* le dici.</span>

</div>

<span id="assignment.14" lang="it" no>## Un unico tessuto per due mondi

Spieghi l'elegante architettura di <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: utilizzando tecnologie open source avanzate su una **base <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>**, la piattaforma non si limita a *tollerare* le macchine virtuali: le tratta come **cittadini nativi dell'ecosistema dei container**. Le pesanti macchine virtuali verranno eseguite fianco a fianco con gli agili container, gestite esattamente dallo stesso motore di orchestrazione:

| Mondo della virtualizzazione | Mondo <span id="assignment.14.1" lang="nolang" no>Container</span> | Unificati su <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> |
|---------------------|----------------|-------------------------------|
| Host hypervisor | Nodi <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> | **Un unico insieme di nodi esegue entrambi** |
| Console di gestione dell'hypervisor | Strumenti per container | **Un'unica piattaforma sottostante**. <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> esegue le VM, Rancher Prime comanda i cluster e i container |
| Array di storage SAN | Volumi <span id="assignment.2.9" lang="nolang" no>CSI</span> | **<span id="assignment.2.8" lang="nolang" no>Longhorn</span> serve allo stesso modo VM e pod** |

È da quest'ultima riga che inizi. Ogni disco di VM, ogni volume persistente di ogni container, tutto viaggia sullo stesso tessuto di storage distribuito, e non tutti i carichi di lavoro meritano lo stesso prezzo.



## 🎯 Gli obiettivi della tua missione

1. Ispezionare la topologia fisica dei nodi
2. Preparare uno spazio di lavoro dedicato
3. Capire come <span id="assignment.2.8" lang="nolang" no>Longhorn</span> replica i tuoi dati
4. Creare una classe di storage a livelli di costo per il team di sviluppo



🔐 Credenziali di accesso
====================

L'interfaccia utente di **<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>** e l'interfaccia utente di <span id="assignment.2.12" lang="nolang" no>**Rancher Prime**</span> utilizzano le stesse credenziali.</span>

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


<span id="assignment.15" lang="it" no>☁️ Che cos'è <span id="assignment.2.8" lang="nolang" no>Longhorn</span>?
====================

<span id="assignment.2.8" lang="nolang" no>Longhorn</span> è il sistema di storage distribuito integrato in <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> che puoi utilizzare. Raggruppa i dischi fisici presenti su ogni nodo e li trasforma in un unico fabric di storage condiviso.

Per impostazione predefinita, ogni volume creato viene replicato su più nodi, quindi un guasto del disco o il riavvio di un nodo non ti farà mai perdere i dati. Nessuna SAN, nessun team di storage separato, un unico sistema sia per le VM che per i container.

È pronto per l'uso, ma se vuoi utilizzare altri <span id="assignment.2.9" lang="nolang" no>CSI</span> sei libero di farlo, nessun vincolo con il fornitore.


🖥️ Attività 1: Ispezionare la topologia fisica dei nodi
=============================================



  



Vai a</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.16" lang="it" no>, vai al menu a sinistra e fai clic su **<span id="assignment.6.1" lang="nolang" no>Hosts</span>**.

1. Fai clic sul nome di **uno degli host** nell'elenco
2. Esplora l'interfaccia utente e controlla le diverse opzioni per capire meglio come funzionano le cose. Osserva come i dispositivi a blocchi raw vengono provisionati per i dischi delle macchine virtuali. Ogni disco che vedi qui diventa parte del pool di storage distribuito <span id="assignment.2.8" lang="nolang" no>Longhorn</span> <span id="assignment.16.1" lang="it" hist="vertrex-bank">che conterrà i registri contabili della banca</span>.</span>


<div id="203" class="story">
<span id="assignment.17" lang="it" hist="vertrex-bank">Le banche crescono, e con loro cresce anche questa infrastruttura. Rimanere a corto di spazio non è più un aggiornamento complesso. Si monta un nuovo nodo nel rack, si aggiungono i suoi dischi grezzi al pool e <span id="assignment.2.8" lang="nolang" no>Longhorn</span> ribilancia automaticamente le repliche sull'infrastruttura ampliata, senza tempi di inattività e senza weekend di migrazione dei dati. La capacità di storage scala allo stesso modo del calcolo: in modo incrementale, su richiesta.</span>
</div>


<span id="assignment.18" lang="it" no>🏗️ Attività 2: Preparare uno spazio di lavoro dedicato
========================================



  


La piattaforma isola i carichi di lavoro in **namespace**, spazi di lavoro separati e governabili sullo stesso cluster.

Nel</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.19" lang="it" no>, seleziona <span id="assignment.19.1" lang="nolang" no>**Namespaces**</span> dal menu a sinistra. Noterai che prod è già presente nell'elenco. <span id="assignment.19.2" lang="it" hist="vertrex-bank">Il team della piattaforma lo ha predisposto prima del tuo arrivo, ed è lì che risiederanno i carichi di lavoro di produzione della banca.</span>

Ora crea la sua controparte per lo sviluppo:

1. Fai clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span>
2. Imposta <span id="assignment.19.4" lang="nolang" no>**Name**</span> su:</span>

<div class="cred">

```txt
dev
```

</div>

<span id="assignment.20" lang="it" no>3. Imposta <span id="assignment.20.1" lang="nolang" no>**Description**</span> su:</span>

<div class="cred">

```txt
VMs from dev
```

</div>


<span id="assignment.21" lang="it" no>4. Fai clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span>

Lo spazio di lavoro degli sviluppatori è ora pronto; in futuro potremo assegnargli quote, policy e controlli di accesso.

💾 Attività 3: Capire come <span id="assignment.2.8" lang="nolang" no>Longhorn</span> replica i tuoi dati
========================================================



  


Vediamo *come* il backend di storage rimane integro. Ogni disco che <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> assegna a una VM o a un pod è un **volume <span id="assignment.2.8" lang="nolang" no>Longhorn</span>**, e ogni volume <span id="assignment.2.8" lang="nolang" no>Longhorn</span> viene creato a partire da una <span id="assignment.21.1" lang="nolang" no>**StorageClass**</span>: una policy che decide, tra le altre cose, quante copie dei tuoi dati esistono in un dato momento.

Nel</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.22" lang="it" no>, vai a <span id="assignment.22.1" lang="nolang" no>**Advanced > Storage Classes**</span> e clicca su harvester-longhorn.

Nota il campo <span id="assignment.22.2" lang="nolang" no>**Number Of Replicas**</span>: è impostato su **3**. Ogni volume creato da questa classe ottiene tre copie complete, distribuite su tre nodi diversi.</span>

<div id="204" class="story">
<span id="assignment.23" lang="it" hist="vertrex-bank">Esattamente ciò che serve per i registri delle transazioni: si perde un nodo, persino un disco nel bel mezzo di una scrittura, e i dati rimangono intatti.</span>
</div>

<span id="assignment.24" lang="it" no>Diamo un'occhiata sotto il cofano e vediamo come <span id="assignment.2.8" lang="nolang" no>Longhorn</span> memorizza i dati:

1. Vai alla</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.25" lang="it" no>e accedi via SSH a uno degli host <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>:
```bash,run
rodeo ssh harvester1
```
2. Controlla la cartella <span id="assignment.2.8" lang="nolang" no>Longhorn</span> sul nodo <span id="assignment.25.1" lang="nolang" no>harvester1</span>: vedrai alcune cartelle e alcuni file:
```bash,run
ls /var/lib/harvester/defaultdisk
```
3. All'interno della cartella replicas, troverai una cartella per ogni replica di volume ospitata da questo nodo:
```bash,wrap,run
ls /var/lib/harvester/defaultdisk/replicas/
```
4. Esci dall'host digitando exit:
```bash,run
exit
```

> [!NOTE]
> Tre repliche significano tre volte l'ingombro su disco. È il compromesso giusto quando si tratta di denaro di produzione. È uno spreco per la VM di test usa e getta di uno sviluppatore che verrà eliminata entro venerdì. Il numero di repliche è una **policy**, non una legge della fisica, e le policy possono essere regolate per ogni carico di lavoro.

🧅 Task 4: Crea una storage class a livello di costo ridotto per il team di sviluppo
=====================================================================



  



Il team di sviluppo non ha bisogno di una replica di livello produzione per le proprie sandbox: ha bisogno di iterazioni economiche e veloci. <span id="assignment.25.2" lang="it" hist="vertrex-bank">Darai loro un livello di storage dedicato, con un prezzo adeguato a ciò che è realmente: usa e getta.</span>

Nel</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.26" lang="it" no>, in <span id="assignment.22.1" lang="nolang" no>**Advanced > Storage Classes**</span>:

1. Fai clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span>
2. Imposta <span id="assignment.19.4" lang="nolang" no>**Name**</span> su:</span>

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

Two StorageClasses sit side by side in the list: `harvester-longhorn` (3 replicas, production) and <b class="highlightcopy">harvester-longhorn-1rep</b> (1 replica for dev sandboxes, at a third of the disk cost). <span id="assignment.29" lang="it" hist="vertrex-bank">Il team di sviluppo ricorrerà a questo livello ogni volta che creerà una VM temporanea nei capitoli che seguono.</span>

> [!NOTE]
> One replica means **zero redundancy**, lose that single node and the volume is gone. That is an acceptable risk for a sandbox nobody depends on overnight, and a very deliberate trade-off you are making on the record, not an accident. Storage classes can also encode disk tags to steer workloads to specific hardware, production on fast NVMe, development on cheaper spindles.

🏋️ Bonus Drills: for the command-line curious (optional)
==========================================================

<div style='align: middle; margin: 15px;'>
  <img class="animatedgif" src="../assets/chapter2_video5.gif"/>
</div>


New to <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Skip ahead freely.** If you are curious, everything you just did in the UI is also visible through the <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> API, open the </span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.30" lang="it" no>- **Visualizza le storage class dell'interfaccia utente come oggetti API**: lo spazio di lavoro ed entrambi i livelli di storage:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get namespace dev -o wide; kubectl --kubeconfig .rodeo/harvester-kubeconfig get storageclasses;
```

- **Etichetta il nuovo spazio di lavoro** in modo che le automazioni future possano individuarlo facilmente:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig label namespace dev stage=dev
```

💼 Perché è importante?
==============================================

- **I silos scompaiono.** VM e container condividono nodi, storage e un unico team operativo. Il "divario di temperatura" del datacenter non esiste più.
- **Nessun salto di riqualificazione.** Le competenze <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> del team container ora gestiscono anche il parco VM; il team VM ottiene un'interfaccia point-and-click familiare, supportata dall'API <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>.
- **I namespace portano governance.** I carichi di lavoro finanziari risiedono in `prod` con quote, policy e controlli di accesso dedicati. I revisori ne saranno entusiasti.
- **Lo storage ora ha un listino prezzi.** La replica è una manopola, non un'impostazione predefinita. I dati di produzione ricevono tre copie perché è necessario; le sandbox usa e getta ne ricevono una perché non dovrebbero costare più del dovuto.</span>

<div id="202" class="story">

<span id="assignment.31" lang="it" hist="vertrex-bank">Sarah ti osserva da dietro le spalle mentre il nuovo workspace e i due livelli di storage compaiono sulla dashboard, uno dopo l'altro. Un lieve sorriso le illumina il volto. *"Le fondamenta sono solide. Mettiamoci al lavoro."*</span>

</div>

<span id="assignment.32" lang="it" no>Fai clic <span id="assignment.32.1" lang="nolang" no>**Check**</span> per continuare. ⚡


📚 Ulteriori informazioni
=========================</span>

- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Storage: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/storage/overview.html)

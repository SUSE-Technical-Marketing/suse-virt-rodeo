---
slug: the-rising-tide-live-migration
id: xjv2r0tfyztq
type: challenge
title: "<span id="assignment.65" lang="it" hist="vertrex-bank">🌊 Capitolo 4: La marea che sale</span>"
teaser: <span id="assignment.66" lang="it" hist="vertrex-bank">Una perdita di liquido di raffreddamento sta allagando il rack che ospita il Payment Gateway. Esegui una
  migrazione live senza interruzioni prima che l'hardware vada in cortocircuito, mentre le transazioni
  continuano a fluire.</span>
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
<span id="assignment.67" lang="it" hist="vertrex-bank">🌊 Capitolo 4: La marea che sale
==============================</span>
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

<span id="assignment.68" lang="it" hist="vertrex-bank">L'adrenalina dell'incidente nella sala contrattazioni si è appena dissipata dal tuo organismo quando un profondo gemito metallico riecheggia attraverso le pareti del datacenter. Tu e Sarah vi voltate contemporaneamente verso il **Rack 4**. Una valvola primaria del liquido refrigerante si è rotta in alto, e un flusso costante di acqua refrigerata e trattata chimicamente sta cadendo a cascata direttamente sullo chassis del server fisico che ospita il **Payment Gateway** principale della banca.

*"Se quel server va in cortocircuito, il gateway cade,"* dice Sarah, con un panico autentico che si insinua nella sua voce mentre osserva l'acqua accumularsi. *"Se il gateway cade, ogni singola transazione con carta di credito di Vertex Trust Bank fallisce. Entro domattina ci ritroveremo ad affrontare indagini delle autorità di vigilanza federali."*

*"Non lasceremo che cada,"* rispondi, con le dita che volano sulla tastiera.</span>

</div>

<span id="assignment.69" lang="it" no>Non puoi spegnere la macchina per spostarla; il flusso di transazioni è troppo critico, elabora migliaia di richieste al secondo. Devi eseguire una **migrazione live**, spostando una VM in esecuzione, memoria inclusa, su un nodo fisico diverso con **zero tempi di inattività**.

Ma prima, per garantire la massima larghezza di banda disponibile per la migrazione di emergenza, decidi di sospendere un vicino server di elaborazione batch non critico.



## 🎯 Obiettivi della tua missione

1. Sospendere i carichi di lavoro non critici per liberare risorse
2. Stabilire un heartbeat del servizio
3. Eseguire la migrazione live
4. Monitorare il trasferimento senza interruzioni
5. Ripristinare le normali operazioni
6. Consegnare il rack danneggiato alla squadra di riparazione



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



<span id="assignment.72" lang="it" no>⏸️ Attività 1: Sospendere i carichi di lavoro non critici per liberare risorse
===========================================================


  



Nel</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.73" lang="it" no>, vai a <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>:

1. Individua la macchina virtuale denominata:</span>

<div class="cred">

```txt
daily-batch-processor
```

</div>

<span id="assignment.74" lang="it" no>2. Fai clic su  sul lato destro della sua riga
3. Seleziona <span id="assignment.74.1" lang="nolang" no>**Pause**</span> quindi fai clic su <span id="assignment.74.2" lang="nolang" no>**Apply**</span> quando ti viene chiesto di confermare.
4. Attendi che il suo stato cambi in <span id="assignment.74.3" lang="nolang" no>**Paused**</span>

Questo interrompe i suoi cicli CPU, dedicando il massimo delle risorse hardware alla tua operazione di emergenza.

> [!NOTE]
> Non è davvero necessario, abbiamo già configurato una rete dedicata per il traffico di live migration, è qui a scopo didattico</span>



<span id="assignment.75" lang="it" no>📡 Task 2: Stabilire un heartbeat del servizio
============================================


  


Passa al</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.76" lang="it" no>. Hai bisogno di un monitor heartbeat continuo per dimostrare che la connessione di rete rimane ininterrotta durante l'evacuazione.

Avvia il monitor heartbeat da <span id="assignment.76.1" lang="nolang" no><b class="highlightcopy">webserver-prod</b></span>:

```bash,run
ssh -o StrictHostKeyChecking=accept-new  sles@[[ Instruqt-Var key="PAYMENT_GATEWAY_IP" hostname="kvm-host" ]] 'ping 192.168.122.1'

```

> [!IMPORTANT]
> Lascia il ping in esecuzione continua nel terminale. **Non interromperlo.** Questo flusso scorrevole di risposte è la tua prova di zero downtime. Riporta la tua attenzione all'interfaccia utente di <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>.</span>

<span id="assignment.77" lang="it" no>🚚 Attività 3: Eseguire la Live Migration
=====================================


  


Nella</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.78" lang="it" no>, vai a **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>** e individua la seguente istanza:</span>

<div class="cred">

```txt
webserver-prod
```

</div>

<span id="assignment.79" lang="it" no>1. Leggi la colonna <span id="assignment.79.1" lang="nolang" no>**Node**</span> e **annota** su quale nodo è in esecuzione il gateway: ti servirà come prova che si è spostato
2. Fai clic su  all'estrema destra della sua riga
3. Seleziona <span id="assignment.79.2" lang="nolang" no>**Migrate**</span> dal menu contestuale
4. Scegli un nodo di destinazione diverso e sicuro dall'elenco a discesa
5. Fai clic su <span id="assignment.74.2" lang="nolang" no>**Apply**</span>

Dietro le quinte, <span id="assignment.2.3" lang="nolang" no>KubeVirt</span> copia le pagine di memoria attive della VM sul nodo di destinazione attraverso la rete, tracciando e ricopiando le pagine che il gateway, sotto carico, modifica durante il trasferimento, finché non riesce a congelare, commutare e riprendere l'esecuzione sul nuovo nodo in una frazione di secondo.</span>

<span id="assignment.80" lang="it" no>👀 Attività 4: Monitorare il trasferimento senza interruzioni
========================================


  


Torna immediatamente al</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.81" lang="it" no>scheda e osserva la sequenza di ping.</span>

<div id="402" class="story">

<span id="assignment.82" lang="it" hist="vertrex-bank">Trattieni il respiro mentre <span id="ch1.intro1.1" lang="nolang" no>hypervisor</span> coordina l'imponente trasferimento di memoria sulla rete. I ping continuano a scorrere sullo schermo, **completamente ininterrotti**. La macchina virtuale si materializza senza soluzione di continuità sul nuovo nodo fisico proprio mentre iniziano a sprizzare scintille dallo chassis danneggiato dall'acqua nel Rack 4.</span>

</div>

<span id="assignment.83" lang="it" no>Premi `Ctrl+C` per terminare il ping.</span>

<div id="403" class="story">
<span id="assignment.84" lang="it" hist="vertrex-bank">Espiri bruscamente. Il flusso delle transazioni è sopravvissuto.</span>
</div>


<span id="assignment.85" lang="it" no>A rigor di termini, un momento di passaggio *esiste*: una volta che la copia della memoria converge, la VM si blocca per un ultimo istante mentre l'esecuzione passa al nuovo nodo, una micro-interruzione. Su un'infrastruttura correttamente dimensionata passa del tutto inosservata; persino in questo laboratorio, che esegue virtualizzazione *dentro* virtualizzazione *dentro* virtualizzazione, al massimo potreste aver notato tempi di latenza leggermente più alti nei ping.

Tornando al</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.86" lang="it" no>, la colonna <span id="assignment.79.1" lang="nolang" no>**Node**</span> per webserver-prod ora mostra un **nodo diverso** da quello che avevi annotato.</span><span id="assignment.87" lang="it" hist="vertrex-bank">Il gateway si è spostato fisicamente senza che i suoi clienti se ne accorgessero.</span>

<div id="404" class="story">
<span id="assignment.88" lang="it" hist="vertrex-bank">Ora genera la prova che Sarah inoltrerà alle autorità di regolamentazione: il contatore di uptime del guest non si è mai azzerato, il che significa che il sistema operativo non ha mai smesso di funzionare:</span>
</div>

```bash,wrap,run
ssh -o StrictHostKeyChecking=accept-new  sles@[[ Instruqt-Var key="PAYMENT_GATEWAY_IP" hostname="kvm-host" ]] "hostname && uptime"
```

<span id="assignment.89" lang="it" no>▶️ Attività 5: Ripristinare le operazioni normali
=================================================


  


Torna al</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.90" lang="it" no>. Individua la macchina virtuale che hai messo in pausa in precedenza:</span>

<div class="cred">

```txt
daily-batch-processor
```

</div>

<span id="assignment.91" lang="it" no>1. Fai clic sul  nella sua riga
2. Seleziona <span id="assignment.91.1" lang="nolang" no>**Unpause**</span> per consentire la ripresa dei job non critici

🛠️ Attività 6: Consegna il rack danneggiato alla squadra di riparazione
====================================================</span>


<div id="405" class="story">
<span id="assignment.92" lang="it" hist="vertrex-bank">Il gateway è al sicuro, ma il nodo danneggiato dall'acqua continua a gocciolare, e potrebbero esserci ancora carichi di lavoro più piccoli in esecuzione su di esso. Non li migrerai uno alla volta mentre una pozzanghera si allarga sul pavimento. Lascia che sia la piattaforma a gestirlo.</span>
</div>


<span id="assignment.93" lang="it" no>Nel

(Nota: il testo sorgente sembra troncato, contiene solo "In the". Se incolli il testo completo, lo traduco per intero.)</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.94" lang="it" no>, vai a <span id="assignment.94.1" lang="nolang" no>**Hosts**</span>:

1. Trova il nodo su cui webserver-prod era in esecuzione **prima** della migrazione, quello che hai annotato.</span>

<i id="406" class="story"><span id="assignment.95" lang="it" hist="vertrex-bank">Questa è la macchina danneggiata dall'acqua</span></i>

<span id="assignment.96" lang="it" no>2. Fai clic su  nella sua riga e seleziona <span id="assignment.96.1" lang="nolang" no>**Enable Maintenance Mode**</span>, poi <span id="assignment.96.2" lang="nolang" no>confirm</span>

Ora osserva la pagina **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>**: ogni VM ancora presente sul nodo danneggiato viene migrata a caldo altrove **automaticamente**. La piattaforma sceglie nodi di destinazione sani, sposta i carichi di lavoro uno alla volta e lascia il nodo vuoto. Niente fogli di calcolo, niente scelta manuale della destinazione, nessuna VM dimenticata.

> [!NOTE]
> In questo ambiente di laboratorio l'operazione potrebbe richiedere un po' di tempo.

Quando il nodo mostra <span id="assignment.96.3" lang="nolang" no>**Maintenance**</span> e il suo numero di VM arriva a zero, la squadra di manutenzione (virtuale) sostituisce la valvola del refrigerante (virtuale). Rimetti il nodo in servizio:

3. Fai di nuovo clic su  nella sua riga e seleziona <span id="assignment.96.4" lang="nolang" no>**Uncordon**</span>, poi <span id="assignment.96.5" lang="nolang" no>**Disable Maintenance Mode**</span>

Il nodo si riunisce al cluster, pronto ad accettare nuovamente carichi di lavoro.

> [!NOTE]
> La stessa intelligenza funziona anche nella direzione opposta: ogni volta che viene creata una nuova VM, lo scheduler la colloca sul nodo idoneo meno carico, mantenendo il cluster naturalmente bilanciato, senza bisogno di alcun Tetris manuale. Tra il posizionamento automatico in ingresso e l'evacuazione automatica in uscita, gli esseri umani decidono solo *cosa* deve essere eseguito; la piattaforma decide *dove*.</span>

<span id="assignment.97" lang="it" no>🏋️ Esercizi Bonus: la traccia documentale della migrazione (facoltativo, per i curiosi della riga di comando)
======================================================================================


  


Nuovo a <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Salta pure avanti.** Altrimenti: ogni migrazione è essa stessa un oggetto <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>, il che significa che è verificabile. Nel</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.98" lang="it" no>- **Esaminare il record della migrazione** (chi si è spostato, quando, da dove a dove):

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachineinstancemigrations -A
```

- **Ispezionare i dettagli della migrazione completata:**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig describe virtualmachineinstancemigrations -A | grep -A 10 "Status"
```

- **Pensare in anticipo:** cosa succede se un *nodo* si guasta senza preavviso, prima che qualcuno possa eseguire la migrazione? Controllare la strategia di esecuzione di ogni VM: <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> può ripianificare automaticamente le VM da un host guasto:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get vm -A -o custom-columns=NAME:.metadata.name,RUNSTRATEGY:.spec.runStrategy
```

> [!NOTE]
> **Oltre il calcolo:** la stessa idea di zero downtime si applica anche ai *dischi*. <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> supporta la **migrazione live dello storage in-place** (spostamento dei volumi di una VM in esecuzione tra backend di storage, ad esempio da <span id="assignment.2.8" lang="nolang" no>Longhorn</span> a un array <span id="assignment.2.9" lang="nolang" no>CSI</span> esterno) senza arrestare la VM. Il calcolo evacuato stanotte, lo storage evacuato il prossimo trimestre, e il gateway non si accorge di nessuno dei due.</span>

<span id="assignment.99" lang="it" no>💼 Perché è importante?
==============================================

- **I guasti hardware smettono di essere interruzioni del servizio.** Perdite di refrigerante, aggiornamenti del firmware, riavvii degli host: i carichi di lavoro si spostano semplicemente sui nodi sani mentre i tuoi servizi continuano a funzionare.
- **Manutenzione pianificata senza finestre notturne.** Un clic su **Maintenance Mode** svuota automaticamente un intero nodo. L'applicazione delle patch di routine avviene alle 14:00 invece che alle 2 di notte, e nessuno deve più tenere un foglio di calcolo per sapere su quale host risiede ogni VM.
- **Una traccia di audit leggibile dagli enti regolatori.** Ogni migrazione è un oggetto API registrato: non serve più ricostruire l'accaduto dagli screenshot della console.

Fai clic su **Check** per continuare. 🕵️

📚 Ulteriori informazioni
===================</span>

- [Live Migration](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/live-migration.html)

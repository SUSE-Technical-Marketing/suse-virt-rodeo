---
slug: the-unthinkable-error-snapshots
id: nkrkc4vyyywt
type: challenge
title: '<span id="assignment.116" lang="it" hist="vertrex-bank">⏪ Capitolo 6: L'errore impensabile</span>'
teaser: <span id="assignment.117" lang="it" hist="vertrex-bank">Un movimento involontario del cursore ha appena eliminato il record di un accordo da 100 milioni di dollari. Torna indietro nel tempo con gli snapshot delle VM, verifica il ripristino in un clone di staging sicuro.</span>
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
<span id="assignment.118" lang="it" hist="vertrex-bank">⏪ Capitolo 6: <span id="assignment.118.1" lang="it" no>L'errore impensabile</span>
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

<span id="assignment.119" lang="it" hist="vertrex-bank">La mattina seguente, il silenzio esausto del turno di notte viene bruscamente interrotto da un singhiozzo soffocato proveniente dalla scrivania dell'amministratore di database junior.

Tu e Sarah vi avvicinate immediatamente. L'amministratore junior sta fissando lo schermo con assoluto terrore, con le mani che tremano sulla tastiera. Nel tentativo di ripulire vecchi file temporanei sul server principale del registro delle transazioni, il cursore gli è scivolato. Ha accidentalmente eseguito un comando di eliminazione ricorsiva sulla directory sbagliata.

Il record di regolamento di una transazione societaria da cento milioni di dollari, finalizzata solo pochi istanti prima, è stato completamente cancellato dal disco.

*"L'ho distrutto",* sussurra l'amministratore, tremando. *"Il backup su nastro non viene eseguito prima di mezzanotte. I dati sono semplicemente svaniti".*

Sarah chiude gli occhi, massaggiandosi le tempie, preparandosi all'impatto devastante che questo avrà sulla reputazione e sul valore azionario della banca. Ma tu posi una mano ferma sulla spalla dell'amministratore.

*"I dati non sono svaniti",* dici con calma. *"La nostra nuova architettura di storage si basa su snapshot distribuiti a livello di blocco. Ho effettuato un'acquisizione dello stato di base subito prima dell'inizio del turno mattutino".*

Ti avvicini al suo terminale. È ora di riportare indietro l'orologio. Ma devi fare attenzione: vuoi **verificare i dati ripristinati in una sandbox sicura prima di sovrascrivere l'ambiente di produzione**.</span>

</div>

<span id="assignment.120" lang="it" no>## 🎯 Obiettivi della tua missione

1. Simula la creazione e la distruzione del record
2. Clona un ambiente di staging dallo snapshot
3. Verifica i dati nella sandbox di staging
4. Ripristina il sistema di produzione
5. Collega il <span id="assignment.120.1" lang="nolang" hist="vertrex-bank">bank's off-cluster backup vault</span>
6. Pianifica i backup



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



<span id="assignment.121" lang="it" no>💥 Attività 1: Simula la creazione e la distruzione del record
==============================================================


  


Riprodurrai tu stesso gli eventi di questa mattina, così da comprendere esattamente cosa protegge lo snapshot.

Nel</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.122" lang="it" no>, accedi alla macchina virtuale (potrebbero essere necessari un paio di minuti prima che la VM si avvii):

```bash,wrap,run
while [[ "${IPA}" ==  "" ]]; do IPA=`kubectl --kubeconfig .rodeo/harvester-kubeconfig get vmi core-services -n prod -o jsonpath='{.status.interfaces[0].ipAddress}'|grep -v ':'`; sleep 5; echo -n '.'; done ; while [[ "$?" != "0" ]] ; do ssh -T -o StrictHostKeyChecking=accept-new sles@${IPA} 2>/dev/null ; sleep 5; done ; ssh -o StrictHostKeyChecking=accept-new sles@${IPA}

```

Genera il record di transazione altamente sensibile sul disco digitando esattamente questo:

```bash,wrap,run
echo "CLIENT: BRUCE WAYNE | AMOUNT: 100,000,000 | STATUS: CLEARED" > /home/sles/ledger.txt
```

**Ora acquisisci la baseline.** Passa alla</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.123" lang="it" no>:

1. Vai a <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>, quindi individua la seguente VM e fai clic sul pulsante  accanto ad essa:</span>

<div class="cred">

```txt
core-services
```

</div>
<span id="assignment.124" lang="it" no>2. Fai clic su <span id="assignment.124.1" lang="nolang" no>**Take Virtual Machine Snapshot**</span>
3. Assegna un nome:</span>

<div class="cred">

```txt
pre-disaster-backup
```

</div>

<span id="assignment.125" lang="it" no>4. Fare clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span>

5. Passare a <span id="assignment.125.1" lang="nolang" no>**Backup and Snapshots**</span>, quindi fare clic su <span id="assignment.125.2" lang="nolang" no>**Virtual Machine Snapshots**</span> e attendere che quello appena creato abbia lo stato <span id="assignment.125.3" lang="nolang" no>**Ready**</span>: il punto di rollback è impostato


Tornare al</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.126" lang="it" no>e simula il terribile errore dell'amministratore junior:

```bash,run
rm -f /home/sles/ledger.txt
```

Cento milioni di dollari, spariti dal disco. Esci dalla console della VM:

```bash,run
exit
```


🧪 Task 2: Clona un ambiente di staging dallo snapshot
========================================================


  


Invece di ripristinare immediatamente la produzione, creerai un **clone** per verificare prima i dati, il ripristino non distruttivo è sempre consigliato.

Nel</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.127" lang="it" no>.

1. Passare a <span id="assignment.125.1" lang="nolang" no>**Backup and Snapshots**</span>, quindi fare clic su <span id="assignment.125.2" lang="nolang" no>**Virtual Machine Snapshots**</span>

2. Fare clic sullo snapshot <span id="assignment.127.1" lang="nolang" no>**pre-disaster-backup**</span>:

3. Fare clic su  accanto ad esso e selezionare <span id="assignment.127.2" lang="nolang" no>**Restore New**</span>

4. Assegnare un nome alla nuova macchina virtuale:</span>


<div class="cred">

```txt
core-services-staging-verify
```

</div>


<span id="assignment.128" lang="it" no>5. Fai clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span>


> [!Note]
> A causa dell'hardware utilizzato in questo lab, questo processo richiederà più tempo rispetto alle normali condizioni; continua pure con l'attività successiva.



🏦 Attività 3: Connettere il vault di backup off-cluster
======================================================


  


Gli snapshot ci hanno salvato questa mattina, ma risiedono sullo **stesso cluster** del carico di lavoro. Proteggono dagli errori di battitura, ma non da danni fisici o attacchi informatici. Per un vero disaster recovery utilizziamo un **vault di backup** off-cluster: una condivisione NFS su un sistema di storage separato. È ora di collegarlo.

Nel</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.129" lang="it" no>:

1. Vai a <span id="assignment.129.1" lang="nolang" no>**Advanced > Settings**</span> e individua:</span>

<div class="cred">

```txt
backup-target
```

</div>
<span id="assignment.130" lang="it" no>2. Fai clic su  nella relativa riga e seleziona <span id="assignment.130.1" lang="nolang" no>**Edit Setting**</span>, aggiungi quanto segue:

- <span id="assignment.110.2" lang="nolang" no>**Type**</span>: <span id="assignment.130.2" lang="nolang" no><b class="highlightcopy">NFS</b></span>
- <span id="assignment.130.3" lang="nolang" no>**Endpoint**</span>:</span>

<div class="cred">

```txt
192.168.122.1:/srv/backups/
```

</div>

<span id="assignment.131" lang="it" no>3. Fai clic su <span id="assignment.114.7" lang="nolang" no>**Save**</span>

Il cluster è ora in grado di inviare backup completi di VM all'esterno del cluster, l'equivalente moderno del backup su nastro di mezzanotte, ma senza la mezzanotte. Un bucket **S3** funziona altrettanto bene come endpoint; in un ambiente di produzione, questo punterebbe a una struttura fisicamente separata.


⏰ Attività 4: Pianifica i backup
====================================</span>

<div id="602" class="story">
<span id="assignment.132" lang="it" hist="vertrex-bank">Gli snapshot ad-hoc possono salvare la giornata una volta; la policy mantiene la banca al sicuro ogni giorno successivo.</span>
</div>

<span id="assignment.133" lang="it" no>Metti core-services stesso sotto una pianificazione di backup automatico in modo che nessuno debba mai più ricordarsi di farlo a mano.


Nel</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.134" lang="it" no>:

1. Vai a <span id="assignment.134.1" lang="nolang" no>**Backup & Snapshot > Virtual Machine Schedules**</span> e fai clic su <span id="assignment.134.2" lang="nolang" no>**Create schedule**</span>
2. Imposta i seguenti dettagli:

  - <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: <span id="assignment.55.2" lang="nolang" no><b class="highlightcopy">prod</b></span>
  - <span id="assignment.134.3" lang="nolang" no>**Virtual Machine Name**</span>: <span id="assignment.134.4" lang="nolang" no><b class="highlightcopy">core-services</b></span>
  - <span id="assignment.134.5" lang="nolang" no>**Basics**</span>:
    - <span id="assignment.134.6" lang="nolang" no>**Retain:**</span> 5
    - <span id="assignment.134.7" lang="nolang" no>**Max Failure:**</span> 2
    - <span id="assignment.134.8" lang="nolang" no>**Cron Schedule:**</span> (al minuto 00, ogni 5 ore)</span>

<div class="cred">

```txt
0 */5 * * *
```

</div>


<span id="assignment.135" lang="it" no>4. Fai clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span>

D'ora in poi la piattaforma esegue il backup della VM nel vault NFS ogni cinque ore, mantiene le cinque copie più recenti e sospende la pianificazione se due esecuzioni consecutive falliscono. Impostato una volta, protetto per sempre.



🔍 Attività 5: Verificare i dati nella sandbox di staging
=================================================


  


Ora che core-services-staging-verify è attivo e funzionante, verifichiamo che il file sia presente.

Questa volta utilizzeremo la console grafica, poiché la VM non ha rete.

Nel</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.136" lang="it" no>:

1. Vai su <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>
2. Fai clic sul menu a discesa <span id="assignment.61.1" lang="nolang" no>**Console**</span> e seleziona <span id="assignment.136.1" lang="nolang" no>**Open in WebVNC**</span>, apparirà una nuova finestra con il terminale, sentiti libero di ridimensionarla.
3. Accedi utilizzando le seguenti credenziali:
   - <span id="assignment.136.2" lang="nolang" no>**username**</span>: 'sles'
   - <span id="assignment.136.3" lang="nolang" no>**password**</span>: '1234'

4. Una volta dentro, esegui il seguente comando:</span>


<div class="cred">

```txt
cat /home/sles/ledger.txt
```

</div>

<span id="assignment.137" lang="it" no>5. Dovrebbe restituire:

**CLIENT: BRUCE WAYNE | AMOUNT: 100,000,000 | STATUS: CLEARED**


Il testo viene stampato perfettamente. <span id="assignment.137.1" lang="it" hist="vertrex-bank">**I dati sono al sicuro.**</span>


Ora eliminiamo il clone che non ci serve più.

1. Chiudi la finestra con la console.
2. Fai clic su  nella riga **core-services-staging-verify** e seleziona <span id="assignment.137.2" lang="nolang" no>**Delete**</span>, e di nuovo <span id="assignment.137.2" lang="nolang" no>**Delete**</span>.



♻️ Attività 6: Ripristina il sistema di produzione
==================================================


  


Ora che hai verificato l'integrità dello snapshot, procedi con il ripristino del sistema di produzione:

1. Vai a **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>**
2. Fai clic su  nella riga **core-services** e seleziona <span id="assignment.137.3" lang="nolang" no>**Stop**</span>, e di nuovo <span id="assignment.74.2" lang="nolang" no>**Apply**</span>.
3. Una volta che si è completamente arrestata, passa a <span id="assignment.125.1" lang="nolang" no>**Backup and Snapshots**</span>, quindi fai clic su <span id="assignment.125.2" lang="nolang" no>**Virtual Machine Snapshots**</span>

4. Fai clic sullo snapshot **pre-disaster-backup**:

5. Fai clic su  accanto ad esso e seleziona <span id="assignment.137.4" lang="nolang" no>**Replace Existing**</span>

6. Fai clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span>

La VM si riaccenderà da sola perché è ciò che definisce la strategia di esecuzione.

Facoltativamente, riconnettiti via SSH ed esegui `cat` sul file un'ultima volta, quindi disconnettiti dalla VM. <span id="assignment.137.5" lang="it" hist="vertrex-bank">Il record è tornato al suo posto.</span>


🏋️ Esercitazioni bonus: scopri il meccanismo dietro la rete di protezione (facoltativo)
========================================================================================

- **Per i curiosi della riga di comando:** ogni snapshot della VM viene creato a partire da snapshot a livello di volume, e ciascuno di essi è un oggetto API, così come la tua nuova pianificazione dei backup:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get VirtualMachineBackup -A; kubectl --kubeconfig .rodeo/harvester-kubeconfig get volumesnapshots -A; kubectl --kubeconfig .rodeo/harvester-kubeconfig get schedulevmbackups -A
```

> [!NOTE]
> Assicurati di disconnetterti dalla VM prima di eseguire questi comandi.


💼 Perché è importante?
==============================================

- **L'errore umano smette di essere catastrofico.** Il ripristino è passato da "attendere i nastri di mezzanotte e pregare" a un rollback self-service di cinque minuti.
- **Verifica prima di sovrascrivere.** Il ripristino su un clone significa non scommettere mai sulla produzione con un backup non verificato, una prassi con cui sia i tuoi auditor sia i tuoi amministratori junior dormiranno sonni più tranquilli.
- **La protezione è ora una policy, non eroismo.** Un vault di backup NFS off-cluster e una pianificazione di backup ogni cinque ore significano che la rete di protezione funzionerà da sola d'ora in avanti.

Fai clic su <span id="assignment.32.1" lang="nolang" no>**Check**</span> per continuare. 🤠

📚 Maggiori informazioni
========================</span>

- [Virtual Machine Backup and Restore](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/backup-restore.html)

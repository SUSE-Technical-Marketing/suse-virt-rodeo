---
slug: the-invisible-intruder-networking
id: 6y9uhwn9zyll
type: challenge
title: "<span id="assignment.100" lang="it" hist="vertrex-bank">🕵️ Capitolo 5: L'intruso invisibile</span>"
teaser: <span id="assignment.101" lang="it" hist="vertrex-bank">Un avviso di sicurezza alle 2 di notte. Il server web pubblico condivide una rete piatta con il
  database più sensibile della banca. Costruisci una cassaforte software-defined e chiudi il database
  al suo interno.</span>
tabs:
- id: 69jpoti7gjds
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: hssojxkhutjx
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: pg01vcvbyns3
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: intermediate
timelimit: 3000
enhanced_loading: null
---
<span id="assignment.102" lang="it" hist="vertrex-bank">🕵️ Capitolo 5: L'intruso invisibile
=====================================</span>

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

<img class="logos" alt="Welcome!" src="../assets/05-chapter-img.png"/>

<div id="501" class="story">

<span id="assignment.103" lang="it" hist="vertrex-bank">Sono le due di notte. Il datacenter è silenzioso, fatta eccezione per il ronzio ritmico delle ventole di raffreddamento. Stai bevendo un caffè ormai freddo e stai esaminando i log di telemetria giornalieri quando lo schermo lampeggia di rosso. Un avviso critico ad alta priorità del Security Operations Center sovrascrive la tua dashboard.

Una scansione automatica delle vulnerabilità ha rilevato un grave difetto architetturale: il **web server** di marketing pubblico della banca si trova esattamente sullo stesso livello di rete piatto della macchina virtuale altamente riservata insider-threat-db.

Se un attore malevolo dovesse compromettere il sito web pubblico, avrebbe un percorso laterale diretto e senza ostacoli verso il database di sicurezza interno più sensibile della banca. In un'infrastruttura tradizionale, risolvere questo problema richiederebbe di svegliare il team senior di ingegneria di rete, ricablare fisicamente le porte degli switch al buio e rischiare loop di routing catastrofici.

Non hai bisogno di cavi fisici. Hai a portata di mano la potenza del **software-defined networking**. Devi costruire una cassaforte digitale impenetrabile e rinchiudervi il database — prima che possa verificarsi un'intrusione.</span>

</div>

<span id="assignment.104" lang="it" no>## Due livelli di software-defined networking

<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> ti offre l'intero spettro, dalla classica segmentazione VLAN all'SDN enterprise, funzionalità per le quali la banca pagava una licenza SDN closed-source separata:

| Livello | Tecnologia | Uso di stasera |
|-------|-----------|-------------|
| L2 / bridging VLAN | **<span id="assignment.2.14" lang="nolang" no>Multus</span>** | La VLAN del vault che isola il database |
| SDN / zone overlay isolate | **<span id="assignment.2.13" lang="nolang" no>Kube-OVN</span>** | Subnet private senza percorsi esterni, anche con CIDR sovrapposti |



## 🎯 Obiettivi della tua missione

1. Connettere una rete fisica a circuito chiuso per la produzione
2. Creare un'SDN altrettanto isolata per lo sviluppo
3. Imparare a spostare le VM nelle nuove reti



🔐 Credenziali di accesso
=========================

L'interfaccia utente di <span id="assignment.69.1" lang="nolang" no>**SUSE Virtualization**</span> e l'interfaccia utente di <span id="assignment.2.12" lang="nolang" no>**Rancher Prime**</span> utilizzano le stesse credenziali.</span>

<span id="assignment.10" lang="nolang" no>Username</span>:

<div class="cred">

```txt
admin
```

</div>

<span id="assignment.105" lang="nolang" no>*Password</span>:

<div class="cred">

```txt
[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="kvm-host" ]]
```

</div>



<span id="assignment.106" lang="it" no>🧱 Task 1: Collegare una rete fisica ad anello chiuso
=================================================

Il nostro team ha configurato i nodi <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> con una NIC dedicata aggiuntiva collegata in un anello fisicamente chiuso. Usiamola per il nostro traffico più prezioso e creiamo una rete di produzione isolata.

Nel</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.107" lang="it" no>, vai a <span id="assignment.107.1" lang="nolang" no>**Networks**</span> nel menu a sinistra, quindi seleziona <span id="assignment.107.2" lang="nolang" no>**Cluster Network Configuration**</span>:

1. Fai clic su <span id="assignment.107.3" lang="nolang" no>**Create a Cluster Network**</span>
2. Imposta <span id="assignment.19.4" lang="nolang" no>**Name**</span> su:</span>

<div class="cred">

```txt
closed-loop
```

</div>

<span id="assignment.108" lang="it" no>3. Fare clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span>

La nuova rete cluster viene visualizzata nell'elenco. Ora assegnarle un'interfaccia fisica: fare clic su <span id="assignment.108.1" lang="nolang" no>**Create Network Configuration**</span> sulla stessa riga della rete cluster a circuito chiuso, quindi specificare i seguenti dettagli:

1. Impostare <span id="assignment.19.4" lang="nolang" no>**Name**</span> su:</span>

<div class="cred">

```txt
closed-loop
```

</div>

<span id="assignment.109" lang="it" no>Nota la sezione <span id="assignment.27" lang="nolang" no>**Node Selector**</span>, qui possiamo specificare dove la rete sarà disponibile.

2. Sotto <span id="assignment.109.1" lang="nolang" no>**Uplink**</span>, imposta <span id="assignment.109.2" lang="nolang" no>**NICs**</span> su ens5

3. Fai clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span>



  


Ora definisci la rete rivolta alle VM su di essa. Seleziona <span id="assignment.109.3" lang="nolang" no>**Virtual Machine Networks**</span> e fai clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span> per definire un nuovo perimetro sicuro:

- <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: prod
- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>

<div class="cred">

```txt
secure-loop-prod
```

</div>

<span id="assignment.110" lang="it" no>- <span id="assignment.110.1" lang="nolang" no>Basics</span>:
  - <span id="assignment.110.2" lang="nolang" no>**Type**</span>: UntaggedNetwork
  - <span id="assignment.110.3" lang="nolang" no>**Cluster Network**</span>: closed-loop

Fai clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span>.


  


Tornando all'elenco <span id="assignment.109.3" lang="nolang" no>**Virtual Machine Networks**</span>, secure-loop-prod appare con lo stato <span id="assignment.110.4" lang="nolang" no>**Active**</span>.



🔒 Attività 2: Crea una SDN a circuito chiuso
===================================

Ora crea lo stesso tipo di isolamento per l'ambiente di sviluppo. <span id="assignment.110.5" lang="it" hist="vertrex-bank">Aggiungere nuove schede di rete e cablaggi è costoso, un ambiente di sviluppo non necessita di così tante risorse dedicate, quindi questa volta utilizzerai una **rete definita dal software**.</span>


  


Vai a <span id="assignment.110.6" lang="nolang" no>**Networks > Virtual Machine Networks**</span> e fai clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span>, quindi compila i seguenti dettagli:

- <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: prod
- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>

<div class="cred">

```txt
secure-loop-dev
```

</div>

<span id="assignment.111" lang="it" no>- <span id="assignment.110.1" lang="nolang" no>Basics</span>:
  - <span id="assignment.110.2" lang="nolang" no>**Type**</span>: OverlayNetwork

Fai clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span>.


  


Ora crea la subnet SDN. Vai a <span id="assignment.111.1" lang="nolang" no>**Virtual Private Cloud**</span> e, nella scheda del Virtual Private Cloud ovn-cluster, fai clic su <span id="assignment.111.2" lang="nolang" no>**Create Subnet**</span>, quindi compila i seguenti dettagli:

- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>

<div class="cred">

```txt
secure-vpc-dev
```

</div>

<span id="assignment.112" lang="it" no>- <span id="assignment.112.1" lang="nolang" no>Basic</span>:
  - <span id="assignment.112.2" lang="nolang" no>**CIDR**</span>:</span>

<div class="cred">

```txt
192.168.32.0/24
```

</div>

<span id="assignment.113" lang="it" no>- <span id="assignment.113.1" lang="nolang" no>**Provider**</span>: prod/secure-loop-dev
  - <span id="assignment.113.2" lang="nolang" no>**Gateway IP**</span>:</span>

<div class="cred">

```txt
192.168.32.1
```

</div>

<span id="assignment.114" lang="it" no>- <span id="assignment.114.1" lang="nolang" no>**Dynamic Host Configuration Protocol (DHCP)**</span>: <span id="assignment.114.2" lang="nolang" no><b class="highlightcopy">Enabled</b></span>
  - <span id="assignment.114.3" lang="nolang" no>**Private Subnet**</span>: <span id="assignment.114.2" lang="nolang" no><b class="highlightcopy">Enabled</b></span>

Fai clic su <span id="assignment.19.3" lang="nolang" no>**Create**</span>.

Ora puoi assegnare la rete prod/secure-loop-dev a qualsiasi VM, ed essa sarà in grado di comunicare solo con le VM presenti sulla stessa rete.


Se desideri visualizzare la topologia nella scheda del Virtual Private Cloud ovn-cluster, fai clic su <span id="assignment.114.4" lang="nolang" no>**Topology**</span>; questo risulta particolarmente utile in presenza di più subnet,


🎯 Attività 3: Configurare le VM con le nuove reti
=====================================================


Hai due nuove reti isolate. Ora è il momento di mostrare ai tuoi colleghi come collegarle a una VM.


  


<span id="assignment.114.5" lang="it" hist="vertrex-bank">Non stai apportando la modifica tu stesso, stai solo vedendo come viene fatta, per questo sceglieremo il server di produzione:</span>

Torna alla dashboard di <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span> e individua la macchina virtuale di destinazione ( **webserver-prod** ):

1. Fai clic su  nella relativa riga e seleziona <span id="assignment.114.6" lang="nolang" no>**Edit Config**</span>
2. Vai alla scheda <span id="assignment.107.1" lang="nolang" no>**Networks**</span>
3. Seleziona la rete prod/secure-loop-prod per i sistemi di produzione, oppure prod/secure-loop-dev per i sistemi di sviluppo
4. Fai clic su <span id="assignment.114.7" lang="nolang" no>**Save**</span>
5. Fai nuovamente clic su  e seleziona <span id="assignment.114.8" lang="nolang" no>**Restart**</span>

La VM si avvia connessa alla nuova rete. Non attendere che finisca.



> [!IMPORTANT]
> Nella maggior parte dei casi, se una VM è attualmente in esecuzione, devi prima **arrestarla** per rendere effettiva la modifica hardware.



🏋️ Esercitazioni bonus: per chi è curioso della riga di comando (facoltativo)
==========================================================

Nuovo su <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Vai pure avanti**: abbiamo già creato le reti isolate. Queste esercitazioni facoltative aggiungono un'ulteriore rete isolata utilizzando esclusivamente gli strumenti di <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>.

**È necessaria un'ulteriore rete isolata per il QA: criteri di rete di <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>.** Dobbiamo essere in grado di replicare questa configurazione in QA per garantire che non ci siano sorprese durante il passaggio alla produzione, applicando criteri rigorosi che eliminino il traffico non autorizzato a livello di pod, al di sotto dell'isolamento VLAN. Nella</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.115" lang="it" no>, applica una policy di ingress predefinita deny-all al namespace sicuro:

```bash,run
cat << EOF | kubectl --kubeconfig .rodeo/harvester-kubeconfig apply -f -
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: default-deny-all
  namespace: prod
spec:
  podSelector: {}
  policyTypes:
    - Ingress
EOF
```

Verifica che la policy sia applicata:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get networkpolicy -n prod
```


Crea una zona completamente indipendente per il team forense:

```bash,run
cat << EOF | kubectl --kubeconfig .rodeo/harvester-kubeconfig apply -f -
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  name: forensics-zone
  namespace: prod
  labels:
    network.harvesterhci.io/clusternetwork: secure-loop-prod
    network.harvesterhci.io/type: OverlayNetwork
spec:
  config: '{"cniVersion":"0.3.1","name":"forensics-zone","type":"kube-ovn","provider":"forensics-zone.prod.ovn","server_socket":"/run/openvswitch/kube-ovn-daemon.sock"}'
EOF
```

```bash,run
cat << EOF | kubectl --kubeconfig .rodeo/harvester-kubeconfig apply -f -
apiVersion: kubeovn.io/v1
kind: Subnet
metadata:
  name: forensics-zone
spec:
  cidrBlock: "172.16.1.0/24"
  gateway: "172.16.1.1"
  excludeIps:
    - "172.16.1.1"
  protocol: IPv4
  natOutgoing: false
  private: true
  provider: forensics-zone.prod.ovn
  vpc: ovn-cluster
EOF
```

> [!NOTE]
> Ogni zona ottiene la propria rete dedicata (e quindi il proprio switch logico isolato), ed è questo a rendere effettivo l'isolamento. <span id="assignment.2.13" lang="nolang" no>Kube-OVN</span> impone comunque una regola per VPC: non possono esistere due subnet nello stesso VPC (`ovn-cluster`) che condividano un CIDR, anche se su reti diverse, motivo per cui `forensics-zone` utilizza un blocco differente. È possibile anche una vera e propria sovrapposizione dello spazio di indirizzi tra le zone, ma richiede un secondo VPC personalizzato, al di fuori dell'ambito di questa esercitazione.

Verifica che entrambe le zone esistano con `natOutgoing: false`: nessun percorso in uscita, nessun percorso in entrata:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get subnets.kubeovn.io -o custom-columns=NAME:.metadata.name,CIDR:.spec.cidrBlock,PRIVATE:.spec.private,NAT:.spec.natOutgoing
```

Due caveau, due reti private indipendenti, zero pacchetti condivisi. Una VM collegata a una delle due zone può comunicare con i propri vicini nella stessa subnet e con **nient'altro**: microsegmentazione senza licenza SDN proprietaria, realizzata e smantellata interamente via software.

💼 Perché è importante?
==============================================

- **Segmentazione alle 2 di notte, via software.** Ciò che un tempo richiedeva un progetto di ricablaggio con riunioni di change control è diventato una configurazione di tre minuti, mentre la finestra di esposizione alla minaccia era ancora chiusa.
- **Difesa in profondità predefinita.** Isolamento VLAN a livello 2, network policy a livello pod e subnet SDN private: tre barriere indipendenti fornite da un'unica piattaforma.
- **Evidenze di conformità integrate.** Ogni rete, policy e subnet è un oggetto YAML versionabile: i revisori della sicurezza ottengono prove concrete, non promesse.

Fai clic su <span id="assignment.32.1" lang="nolang" no>**Check**</span> per continuare. ⏪

📚 Maggiori informazioni
===================</span>

- [Cluster Networking](https://documentation.suse.com/cloudnative/virtualization/latest/en/networking/cluster-network.html)

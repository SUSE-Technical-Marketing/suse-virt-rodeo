---
slug: the-invisible-intruder-networking
id: 6y9uhwn9zyll
type: challenge
title: '<span id="assignment.100" lang="pt-BR" hist="vertrex-bank">🕵️ Capítulo 5: O Intruso Invisível</span>'
teaser: <span id="assignment.101" lang="pt-BR" hist="vertrex-bank">Um alerta de segurança às 2h da manhã. O servidor web público compartilha uma rede plana com o banco de dados mais sensível do banco. Construa um cofre definido por software e tranque o banco de dados dentro dele.</span>
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
<span id="assignment.102" lang="pt-BR" hist="vertrex-bank">🕵️ Capítulo 5: O Intruso Invisível
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

<span id="assignment.103" lang="pt-BR" hist="vertrex-bank">São agora duas da manhã. O datacenter está silencioso, exceto pelo zumbido rítmico dos ventiladores de refrigeração. Você está tomando um café requentado e revisando os logs diários de telemetria quando sua tela pisca em vermelho. Um alerta crítico e de alta prioridade do Centro de Operações de Segurança sobrepõe seu painel.

Uma varredura automatizada de vulnerabilidades detectou uma falha arquitetural grave: o **servidor web** de marketing voltado para o público do banco está posicionado exatamente na mesma camada de rede plana que a máquina virtual altamente classificada insider-threat-db.

Se um agente de ameaça comprometesse o site público, ele teria um caminho lateral direto e desimpedido até o banco de dados de segurança interna mais sensível do banco. Em uma infraestrutura tradicional, corrigir isso exigiria acordar a equipe sênior de engenharia de redes, recablear fisicamente as portas dos switches no escuro e arriscar loops de roteamento catastróficos.

Você não precisa de cabos físicos. Você tem o poder do **software-defined networking** ao seu alcance. Você deve construir um cofre digital impenetrável e trancar o banco de dados dentro dele — antes que uma intrusão possa ocorrer.</span>

</div>

<span id="assignment.104" lang="pt-BR" no>## Duas camadas de rede definida por software

<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> oferece todo o espectro, da segmentação clássica por VLAN até o SDN empresarial, recursos pelos quais o banco costumava pagar uma licença de SDN de código fechado separada:

| Camada | Tecnologia | Uso desta noite |
|-------|-----------|-------------|
| L2 / bridging VLAN | **<span id="assignment.2.14" lang="nolang" no>Multus</span>** | A VLAN do cofre isolando o banco de dados |
| SDN / zonas de overlay isoladas | **<span id="assignment.2.13" lang="nolang" no>Kube-OVN</span>** | Sub-redes privadas sem caminho externo, mesmo com CIDRs sobrepostos |



## 🎯 Objetivos da sua Missão

1. Conectar uma rede física de circuito fechado para produção
2. Construir um SDN igualmente isolado para desenvolvimento
3. Aprender como mover VMs para as novas redes



🔐 Credenciais de Login
====================

A interface do <span id="assignment.69.1" lang="nolang" no>**SUSE Virtualization**</span> e a interface do <span id="assignment.2.12" lang="nolang" no>**Rancher Prime**</span> usam as mesmas credenciais.</span>

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



<span id="assignment.106" lang="pt-BR" no>🧱 Tarefa 1: Conectar uma rede física em loop fechado
=================================================

Nossa equipe configurou os nós <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> com uma NIC dedicada extra que está conectada em um loop físico fechado. Vamos usá-la para o nosso tráfego mais importante e criar uma rede de produção isolada.

No</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.107" lang="pt-BR" no>, navegue até <span id="assignment.107.1" lang="nolang" no>**Networks**</span> no menu à esquerda e, em seguida, selecione <span id="assignment.107.2" lang="nolang" no>**Cluster Network Configuration**</span>:

1. Clique em <span id="assignment.107.3" lang="nolang" no>**Create a Cluster Network**</span>
2. Defina <span id="assignment.19.4" lang="nolang" no>**Name**</span> como:</span>

<div class="cred">

```txt
closed-loop
```

</div>

<span id="assignment.108" lang="pt-BR" no>3. Clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>

A nova rede de cluster aparece na lista. Agora atribua a ela uma interface física: clique em <span id="assignment.108.1" lang="nolang" no>**Create Network Configuration**</span> na mesma linha da rede de cluster closed-loop e preencha os seguintes detalhes:

1. Defina o <span id="assignment.19.4" lang="nolang" no>**Name**</span> como:</span>

<div class="cred">

```txt
closed-loop
```

</div>

<span id="assignment.109" lang="pt-BR" no>Observe a seção <span id="assignment.27" lang="nolang" no>**Node Selector**</span> aqui podemos especificar onde a rede estará disponível.

2. Em <span id="assignment.109.1" lang="nolang" no>**Uplink**</span>, defina <span id="assignment.109.2" lang="nolang" no>**NICs**</span> como ens5

3. Clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>



  


Agora defina a rede voltada para a VM sobre ela. Selecione <span id="assignment.109.3" lang="nolang" no>**Virtual Machine Networks**</span> e clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span> para definir um novo perímetro seguro:

- <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: prod
- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>

<div class="cred">

```txt
secure-loop-prod
```

</div>

<span id="assignment.110" lang="pt-BR" no>- <span id="assignment.110.1" lang="nolang" no>Basics</span>:
  - <span id="assignment.110.2" lang="nolang" no>**Type**</span>: UntaggedNetwork
  - <span id="assignment.110.3" lang="nolang" no>**Cluster Network**</span>: closed-loop

Clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>.


  


De volta à lista <span id="assignment.109.3" lang="nolang" no>**Virtual Machine Networks**</span>, secure-loop-prod aparece com status <span id="assignment.110.4" lang="nolang" no>**Active**</span>.



🔒 Tarefa 2: Criar uma SDN de loop fechado
===================================

Agora crie o mesmo tipo de isolamento para o ambiente de desenvolvimento. <span id="assignment.110.5" lang="pt-BR" hist="vertrex-bank">Adicionar novas NICs e cabeamento é caro; um ambiente de desenvolvimento não precisa de tantos recursos dedicados, então desta vez você usará uma **rede definida por software**.</span>


  


Vá até <span id="assignment.110.6" lang="nolang" no>**Networks > Virtual Machine Networks**</span> e clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>, depois preencha os seguintes detalhes:

- <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: prod
- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>

<div class="cred">

```txt
secure-loop-dev
```

</div>

<span id="assignment.111" lang="pt-BR" no>- <span id="assignment.110.1" lang="nolang" no>Basics</span>:
  - <span id="assignment.110.2" lang="nolang" no>**Type**</span>: OverlayNetwork

Clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>.


  


Agora crie a sub-rede SDN. Vá até <span id="assignment.111.1" lang="nolang" no>**Virtual Private Cloud**</span> e, na aba da Virtual Private Cloud ovn-cluster, clique em <span id="assignment.111.2" lang="nolang" no>**Create Subnet**</span>, depois preencha os seguintes detalhes:

- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>

<div class="cred">

```txt
secure-vpc-dev
```

</div>

<span id="assignment.112" lang="pt-BR" no>- <span id="assignment.112.1" lang="nolang" no>Basic</span>:
  - <span id="assignment.112.2" lang="nolang" no>**CIDR**</span>:</span>

<div class="cred">

```txt
192.168.32.0/24
```

</div>

<span id="assignment.113" lang="pt-BR" no>- <span id="assignment.113.1" lang="nolang" no>**Provider**</span>: prod/secure-loop-dev
  - <span id="assignment.113.2" lang="nolang" no>**Gateway IP**</span>:</span>

<div class="cred">

```txt
192.168.32.1
```

</div>

<span id="assignment.114" lang="pt-BR" no>- <span id="assignment.114.1" lang="nolang" no>**Dynamic Host Configuration Protocol (DHCP)**</span>: <span id="assignment.114.2" lang="nolang" no><b class="highlightcopy">Enabled</b></span>
  - <span id="assignment.114.3" lang="nolang" no>**Private Subnet**</span>: <span id="assignment.114.2" lang="nolang" no><b class="highlightcopy">Enabled</b></span>

Clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>.

Agora você pode atribuir a rede prod/secure-loop-dev a qualquer VM, e ela só poderá se comunicar com as VMs na mesma rede.


Se tiver curiosidade em ver a topologia na aba da Virtual Private Cloud ovn-cluster, clique em <span id="assignment.114.4" lang="nolang" no>**Topology**</span>, isso é especialmente útil quando há múltiplas sub-redes,


🎯 Tarefa 3: Configurar VMs com as novas redes
=====================================================


Você tem duas novas redes isoladas. Agora é hora de mostrar aos seus colegas como conectá-las a uma VM.


  


<span id="assignment.114.5" lang="pt-BR" hist="vertrex-bank">Você não vai fazer a mudança você mesmo, é apenas para mostrar como isso é feito, para isso vamos escolher o servidor de produção:</span>

Retorne ao painel <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span> e localize a máquina virtual de destino ( **webserver-prod** ):

1. Clique no  na sua linha e selecione <span id="assignment.114.6" lang="nolang" no>**Edit Config**</span>
2. Vá para a aba <span id="assignment.107.1" lang="nolang" no>**Networks**</span>
3. Selecione a rede prod/secure-loop-prod para sistemas de produção, ou prod/secure-loop-dev para sistemas de desenvolvimento
4. Clique em <span id="assignment.114.7" lang="nolang" no>**Save**</span>
5. Clique no  novamente e selecione <span id="assignment.114.8" lang="nolang" no>**Restart**</span>

A VM é iniciada conectada à nova rede. Não espere que ela termine.



> [!IMPORTANT]
> Na maioria dos casos, se uma VM estiver em execução, você deve **pará-la primeiro** para ativar a modificação de hardware.



🏋️ Exercícios Bônus: para os curiosos de linha de comando (opcional)
==========================================================

Novo em <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Pule à vontade**: já temos as redes isoladas criadas. Esses exercícios opcionais adicionam uma rede isolada extra com ferramentas puras de <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>.

**Uma rede isolada extra é necessária para o QA: políticas de rede <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>.** Precisamos ser capazes de replicar essa configuração no QA para garantir que não haja surpresas ao migrar para produção, aplicando uma política estrita que descarta tráfego não autorizado no nível do pod, abaixo do isolamento de VLAN. No</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.115" lang="pt-BR" no>, aplique uma política de ingress padrão de negação total (deny-all) ao namespace seguro:

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

Confirme que a política está sendo aplicada:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get networkpolicy -n prod
```


Crie uma zona completamente independente para a equipe de forense:

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
> Cada zona recebe sua própria rede dedicada (e, portanto, seu próprio switch lógico isolado), o que é o que torna o isolamento real. <span id="assignment.2.13" lang="nolang" no>Kube-OVN</span> ainda impõe uma regra por VPC: duas sub-redes na mesma VPC (`ovn-cluster`) não podem compartilhar um CIDR, mesmo em redes diferentes, motivo pelo qual `forensics-zone` usa um bloco diferente. Uma sobreposição real de espaço de endereços entre zonas também é possível, mas exige uma segunda VPC personalizada, fora do escopo deste exercício.

Verifique se ambas as zonas existem com `natOutgoing: false`: sem caminho de saída, sem caminho de entrada:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get subnets.kubeovn.io -o custom-columns=NAME:.metadata.name,CIDR:.spec.cidrBlock,PRIVATE:.spec.private,NAT:.spec.natOutgoing
```

Dois cofres, duas redes privadas independentes, zero pacotes compartilhados. Uma VM conectada a qualquer uma das zonas pode se comunicar com seus vizinhos na mesma sub-rede e com **mais nada**: microssegmentação sem licença de SDN proprietária, construída e desmontada inteiramente em software.

💼 Por que isso importa?
==============================================

- **Segmentação às 2h da manhã, em software.** O que antes era um projeto de recabeamento com reuniões de controle de mudanças virou três minutos de configuração, enquanto a janela de ameaça ainda estava fechada.
- **Defesa em profundidade por padrão.** Isolamento VLAN na camada 2, políticas de rede na camada de pods e sub-redes SDN privadas: três muralhas independentes em uma única plataforma.
- **Evidência de conformidade embutida.** Cada rede, política e sub-rede é um objeto YAML versionável: os auditores de segurança recebem provas, não promessas.

Clique em <span id="assignment.32.1" lang="nolang" no>**Check**</span> para continuar. ⏪

📚 Mais informações
===================</span>

- [Cluster Networking](https://documentation.suse.com/cloudnative/virtualization/latest/en/networking/cluster-network.html)

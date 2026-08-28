---
slug: the-subterranean-divide-cluster-prep
id: tmmoesxdhg4b
type: challenge
title: "\<span id="assignment.12" lang="pt-BR" hist="vertrex-bank">🛗 Capítulo 2: A Divisão Subterrânea</span>"
teaser: <span lang="pt-BR" hist="vertrex-bank" id="ts2">Dois silos de hardware, duas equipes que praticamente não se falam. Desça ao datacenter, mapeie a topologia dos nós e dê a cada disco do fabric um preço que o banco consiga bancar.</span>
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
<span lang="pt-BR" hist="vertrex-bank" id="ts2">Dois silos de hardware, duas equipes que praticamente não se falam. Desça ao datacenter, mapeie a topologia dos nós e dê a cada disco do fabric um preço que o banco consiga bancar.</span>

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

<span id="assignment.13" lang="pt-BR" hist="vertrex-bank">Sarah conduz você para fora das tranquilas suítes executivas, entra em um elevador seguro e desce até o datacenter subterrâneo do banco. A temperatura ambiente despenca bruscamente quando as pesadas portas biométricas de aço se trancam atrás de você. A sala vibra com o rugido ensurdecedor e implacável dos sistemas de refrigeração industrial.

Ela aponta para o lado esquerdo da sala, onde fileiras de chassis de servidores elegantes e densamente compactados piscam com luzes azuis rápidas. *"Aqueles rodam nossas APIs de mobile banking,"* ela grita por cima do barulho dos ventiladores. *"Microsserviços puros. Totalmente conteinerizados e ágeis."*

Em seguida, ela aponta para o lado direito da sala, dominado por gabinetes de servidores enormes e arcaicos, irradiando um calor desconfortável. *"E aqueles são as máquinas virtuais monolíticas legadas que armazenam os livros-razão de transações centrais. Dois mundos completamente diferentes. Dois silos de hardware diferentes. Duas equipes de engenharia diferentes que praticamente não se falam."*

Você caminha entre as duas fileiras, sentindo o diferencial de temperatura nítido. *"Essa divisão acaba hoje,"* você diz a ela.</span>

</div>

<span id="assignment.14" lang="pt-BR" no>## Um único tecido para dois mundos

Você explica a arquitetura elegante do <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: ao usar tecnologias open-source avançadas sobre uma **fundação <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>**, a plataforma não apenas *tolera* máquinas virtuais: ela as trata como **cidadãs nativas do ecossistema de contêineres**. As máquinas virtuais pesadas rodarão lado a lado com os contêineres ágeis, gerenciadas pelo mesmo mecanismo de orquestração:

| Mundo da virtualização | Mundo <span id="assignment.14.1" lang="nolang" no>Container</span> | Unificado no <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> |
|---------------------|----------------|-------------------------------|
| Hosts de hipervisor | Nós <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> | **Um único conjunto de nós executa ambos** |
| Console de gerenciamento do hipervisor | Ferramentas de contêiner | **Uma única plataforma por baixo**. O <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> executa as VMs, o Rancher Prime comanda os clusters e os contêineres |
| Arrays de armazenamento SAN | Volumes <span id="assignment.2.9" lang="nolang" no>CSI</span> | **O <span id="assignment.2.8" lang="nolang" no>Longhorn</span> atende tanto VMs quanto pods** |

Essa última linha é onde você começa. Todo disco de VM, todo volume persistente de contêiner, tudo passa pelo mesmo tecido de armazenamento distribuído, e nem toda carga de trabalho merece o mesmo preço.



## 🎯 Objetivos da Sua Missão

1. Inspecionar a topologia dos nós físicos
2. Preparar um espaço de trabalho dedicado
3. Entender como o <span id="assignment.2.8" lang="nolang" no>Longhorn</span> replica seus dados
4. Construir uma classe de armazenamento por nível de custo para a equipe de desenvolvimento



🔐 Credenciais de Login
====================

A interface do **<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>** e a interface do <span id="assignment.2.12" lang="nolang" no>**Rancher Prime**</span> usam as mesmas credenciais.</span>

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


<span id="assignment.15" lang="pt-BR" no>☁️ O que é <span id="assignment.2.8" lang="nolang" no>Longhorn</span>?
====================

<span id="assignment.2.8" lang="nolang" no>Longhorn</span> é o sistema de armazenamento distribuído incorporado ao <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> que você pode usar. Ele reúne os discos brutos presentes em cada nó e os transforma em um único conjunto de armazenamento compartilhado.

Por padrão, todo volume que ele cria é replicado entre vários nós, então uma falha de disco ou a reinicialização de um nó nunca faz você perder dados. Sem SAN, sem equipe de armazenamento separada, um único sistema tanto para VMs quanto para contêineres.

Está pronto para você usar, mas se quiser utilizar outro <span id="assignment.2.9" lang="nolang" no>CSI</span> você é livre para fazê-lo, sem dependência de fornecedor.


🖥️ Tarefa 1: Inspecione a topologia física dos nós
=============================================



  



Vá até o</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.16" lang="pt-BR" no>, navegue até o menu à esquerda e clique em **<span id="assignment.6.1" lang="nolang" no>Hosts</span>**.

1. Clique no nome de **um dos hosts** na lista
2. Navegue pela interface e verifique as diferentes opções para entender melhor como tudo funciona. Observe como os dispositivos de bloco brutos são provisionados para os discos das máquinas virtuais. Cada disco que você vê aqui se torna parte do pool de armazenamento distribuído <span id="assignment.2.8" lang="nolang" no>Longhorn</span> <span id="assignment.16.1" lang="pt-BR" hist="vertrex-bank">que vai conter os livros-razão do banco</span>.</span>


<div id="203" class="story">
<span id="assignment.17" lang="pt-BR" hist="vertrex-bank">Bancos crescem, e essa malha também. Ficar sem espaço não é mais uma atualização complexa. Instale um novo nó, adicione seus discos brutos ao pool, e o <span id="assignment.2.8" lang="nolang" no>Longhorn</span> rebalanceia as réplicas automaticamente pela malha expandida, sem downtime, sem final de semana de migração de dados. A capacidade de armazenamento escala da mesma forma que a computação: de forma incremental, sob demanda.</span>
</div>


<span id="assignment.18" lang="pt-BR" no>🏗️ Tarefa 2: Preparar um espaço de trabalho dedicado
========================================



  


A plataforma isola as cargas de trabalho em **namespaces**, espaços de trabalho separados e governáveis no mesmo cluster.

No</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.19" lang="pt-BR" no>, selecione <span id="assignment.19.1" lang="nolang" no>**Namespaces**</span> no menu à esquerda. Você notará que o prod já está na lista. <span id="assignment.19.2" lang="pt-BR" hist="vertrex-bank">A equipe de plataforma provisionou isso antes da sua chegada, e é lá que as cargas de trabalho de produção do banco ficarão.</span>

Agora crie o equivalente para desenvolvimento:

1. Clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>
2. Defina o <span id="assignment.19.4" lang="nolang" no>**Name**</span> como:</span>

<div class="cred">

```txt
dev
```

</div>

<span id="assignment.20" lang="pt-BR" no>3. Defina o <span id="assignment.20.1" lang="nolang" no>**Description**</span> como:</span>

<div class="cred">

```txt
VMs from dev
```

</div>


<span id="assignment.21" lang="pt-BR" no>4. Clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>

O workspace de desenvolvedores agora está pronto, e no futuro poderemos atribuir a ele quotas, políticas e controles de acesso.

💾 Tarefa 3: Entenda como o <span id="assignment.2.8" lang="nolang" no>Longhorn</span> replica seus dados
========================================================




Vamos ver *como* o backend de armazenamento se mantém saudável. Todo disco que o <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> entrega a uma VM ou a um pod é um **volume <span id="assignment.2.8" lang="nolang" no>Longhorn</span>**, e todo volume <span id="assignment.2.8" lang="nolang" no>Longhorn</span> é criado a partir de uma <span id="assignment.21.1" lang="nolang" no>**StorageClass**</span>: uma política que decide, entre outras coisas, quantas cópias dos seus dados existem em um determinado momento.

No</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.22" lang="pt-BR" no>, vá até <span id="assignment.22.1" lang="nolang" no>**Advanced > Storage Classes**</span> e clique em harvester-longhorn.

Observe o campo <span id="assignment.22.2" lang="nolang" no>**Number Of Replicas**</span>: ele está definido como **3**. Cada volume criado a partir dessa classe recebe três cópias completas, distribuídas em três nós diferentes.</span>

<div id="204" class="story">
<span id="assignment.23" lang="pt-BR" hist="vertrex-bank">Isso é exatamente correto para os livros-razão de transações — perca um nó, ou até mesmo perca um disco no meio de uma escrita, e os dados permanecem intactos.</span>
</div>

<span id="assignment.24" lang="pt-BR" no>Vamos dar uma olhada por baixo dos panos e ver como o <span id="assignment.2.8" lang="nolang" no>Longhorn</span> armazena os dados:

1. Vá para o</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.25" lang="pt-BR" no>e SSH em um dos hosts <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>:
```bash,run
rodeo ssh harvester1
```
2. Verifique a pasta <span id="assignment.2.8" lang="nolang" no>Longhorn</span> no nó <span id="assignment.25.1" lang="nolang" no>harvester1</span>: você verá algumas pastas e arquivos:
```bash,run
ls /var/lib/harvester/defaultdisk
```
3. Dentro da pasta replicas, encontre uma pasta para cada réplica de volume que este nó possui:
```bash,wrap,run
ls /var/lib/harvester/defaultdisk/replicas/
```
4. Saia do host digitando exit:
```bash,run
exit
```

> [!NOTE]
> Três réplicas significam três vezes o espaço em disco. Essa é a troca correta para o dinheiro de produção. É um desperdício para uma VM de teste descartável de um desenvolvedor que será excluída até sexta-feira. A contagem de réplicas é uma **política**, não uma lei da física, e políticas podem ser ajustadas por carga de trabalho.

🧅 Tarefa 4: Construa uma storage class de nível de custo para a equipe de desenvolvimento
=====================================================================



  



A equipe de desenvolvimento não precisa de replicação de nível de produção para seus sandboxes, eles precisam de iteração barata e rápida. <span id="assignment.25.2" lang="pt-BR" hist="vertrex-bank">Você vai ter seu próprio nível de armazenamento, precificado pelo que ele realmente é: descartável.</span>

No</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.26" lang="pt-BR" no>, sob <span id="assignment.22.1" lang="nolang" no>**Advanced > Storage Classes**</span>:

1. Clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>
2. Defina <span id="assignment.19.4" lang="nolang" no>**Name**</span> como:</span>

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

Two StorageClasses sit side by side in the list: `harvester-longhorn` (3 replicas, production) and <b class="highlightcopy">harvester-longhorn-1rep</b> (1 replica for dev sandboxes, at a third of the disk cost). <span id="assignment.29" lang="pt-BR" hist="vertrex-bank">A equipe de desenvolvimento vai recorrer a esse nível toda vez que subir uma VM descartável nos capítulos seguintes.</span>

> [!NOTE]
> One replica means **zero redundancy**, lose that single node and the volume is gone. That is an acceptable risk for a sandbox nobody depends on overnight, and a very deliberate trade-off you are making on the record, not an accident. Storage classes can also encode disk tags to steer workloads to specific hardware, production on fast NVMe, development on cheaper spindles.

🏋️ Bonus Drills: for the command-line curious (optional)
==========================================================

<div style='align: middle; margin: 15px;'>
  <img class="animatedgif" src="../assets/chapter2_video5.gif"/>
</div>


New to <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Skip ahead freely.** If you are curious, everything you just did in the UI is also visible through the <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> API, open the </span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.30" lang="pt-BR" no>**Veja suas classes de armazenamento de UI como objetos de API**: o workspace e ambos os níveis de armazenamento:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get namespace dev -o wide; kubectl --kubeconfig .rodeo/harvester-kubeconfig get storageclasses;
```

- **Rotule o novo workspace** para que a automação futura possa direcioná-lo facilmente:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig label namespace dev stage=dev
```

💼 Por que isso importa?
==============================================

- **Os silos desaparecem.** VMs e contêineres compartilham nós, armazenamento e uma única equipe de operações. A "divisão de temperatura" do datacenter acabou.
- **Nenhum penhasco de retreinamento.** As habilidades <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> da equipe de contêineres agora também gerenciam o parque de VMs; a equipe de VMs ganha uma interface familiar de apontar e clicar, respaldada pela API <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>.
- **Namespaces trazem governança.** Cargas de trabalho financeiras vivem em `prod` com suas próprias cotas, políticas e controles de acesso. Os auditores vão adorar.
- **O armazenamento agora tem uma lista de preços.** A replicação é um seletor, não um padrão. Os dados de produção recebem três cópias porque precisam; os sandboxes descartáveis recebem uma porque não devem custar mais do que o necessário.</span>

<div id="202" class="story">

<span id="assignment.31" lang="pt-BR" hist="vertrex-bank">Sarah observa por cima do seu ombro enquanto o novo workspace e os dois níveis de armazenamento aparecem no painel, um após o outro. Um leve sorriso surge em seu rosto. *"A base está sólida. Vamos ao trabalho."*</span>

</div>

<span id="assignment.32" lang="pt-BR" no>Clique em <span id="assignment.32.1" lang="nolang" no>**Check**</span> para continuar. ⚡


📚 Mais informações
===================</span>

- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Storage: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/storage/overview.html)

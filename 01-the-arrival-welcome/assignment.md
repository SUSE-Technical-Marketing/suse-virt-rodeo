---
slug: the-arrival-welcome
id: ermykdy1tbse
type: challenge
title: "<span id="assignment.7" lang="pt-BR" hist="vertrex-bank">🏦 Capítulo 1: A Chegada</span>"
teaser: <span id="assignment.8" lang="pt-BR" hist="vertrex-bank">O Vertex Trust Bank está afundando em custos legados <span id="ch1.intro1.1" lang="nolang" no>hypervisor</span>
  Entre na sala de reuniões, assuma o controle do SUSE Virtualization
  e inspecione seu novo centro de comando.</span>
notes:
- type: text
  contents: |
    <span id="assignment.1" lang="pt-BR" no># Bem-vindo ao <span id="assignment.1.1"  lang="nolang" no>SUSE Virtualization Rodeo!</span>

    Aguarde enquanto preparamos seu ambiente de laboratório.</span><span lang="pt-BR" id="ch1.waiting1" hist="vertrex-bank">A chuva bate contra as janelas da sede do Vertex Trust Bank...
    Sarah, a CTO, está esperando por você na sala de reuniões.</span>
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

<span id="assignment.9" lang="pt-BR" hist="vertrex-bank">🏦 Capítulo 1: A Chegada</span>
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
<span lang="pt-BR" id="ch1.intro1" hist="vertrex-bank">A chuva batia contra as janelas do chão ao teto da sede do Vertex Trust Bank, distorcendo o horizonte da cidade em um borrão cinza e aquoso. Dentro da sala de reuniões executiva de paredes de vidro, a atmosfera estava igualmente turbulenta. Sarah, a Diretora de Tecnologia, andava de um lado a outro da sala, os olhos fixos em um enorme monitor suspenso projetando um mar de alertas vermelhos e avisos de desempenho.

Ela se virou para você, a voz tensa de exaustão. *"Estamos perdendo milissegundos preciosos em cada única transação de mercado. Nossos <span id="ch1.intro1.1" lang="nolang" no>hypervisor</span>s legados estão cedendo sob o volume imenso do tráfego bancário digital moderno. A infraestrutura é frágil, os arrays de armazenamento estão constantemente saindo de sincronia, e nossos custos de licenciamento estão drenando completamente nosso orçamento de engenharia. Não podemos sobreviver mais um ano acorrentados a esses sistemas monolíticos e antiquados."*

Você se senta em silêncio na ponta da mesa de mogno, revisando os esquemas arquiteturais que ela forneceu. Como um **Arquiteto de Infraestrutura** de elite, você foi trazido para um propósito específico: salvar o Vertex Trust Bank de um travamento operacional total. Eles precisam de uma ponte para o mundo cloud-native sem reconstruir toda a pilha de aplicações do zero.

*"Temos um plano, Sarah,"* você finalmente diz, fechando seu laptop com um clique reconfortante. *"Vamos transicionar todo o datacenter para <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>. Vamos trazer seus sistemas legados para a era moderna, e faremos isso sem perder o ritmo."*</span>
</div>


<span id="assignment.2" lang=pt-BR no>Sua jornada começa agora mesmo. Antes de poder começar a desmontar o mundo antigo, você precisa estabelecer uma base sólida no novo mundo e mergulhar no ambiente.

## O que é <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>?

<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> (também conhecido como **<span id="assignment.2.1" lang="nolang" no>Harvester</span>**) é uma plataforma moderna e de código aberto de infraestrutura hiperconvergente (HCI) construída sobre <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>. Ela roda diretamente em hardware bare metal e oferece ao banco **máquinas virtuais** de nível empresarial sobre uma base cloud-native, <span id="ch1.intro2"  lang="pt-BR" hist="vertrex-bank">exatamente a ponte que o Vertex Trust Bank precisa</span>:

- **<span id="assignment.2.3" lang="nolang" no>KubeVirt</span> + <span id="assignment.2.4" lang="nolang" no>KVM</span>/<span id="assignment.2.5" lang="nolang" no>QEMU</span>**: virtualização empresarial como cargas de trabalho nativas do <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>. Por baixo, está a mesma dupla **<span id="assignment.2.4" lang="nolang" no>KVM</span>/<span id="assignment.2.5" lang="nolang" no>QEMU</span>**, testada em batalha, que impulsiona a virtualização <span id="assignment.2.6" lang="nolang" no>Linux</span> há décadas, motivo pelo qual a plataforma consegue rodar uma enorme variedade de sistemas operacionais convidados, <span id="ch1.intro3"  lang="pt-BR" hist="vertrex-bank">incluindo até as mais antigas, ainda em uso nos cantos mais empoeirados e legados do banco, aguardando pacientemente por sua migração</span>
- **<span id="assignment.2.7" lang="nolang" no>SUSE Storage</span> (<span id="assignment.2.8" lang="nolang" no>Longhorn</span>)**: armazenamento em bloco distribuído e replicado em todos os nós, configurado e pronto para uso desde o início. <span id="ch1.intro4"  lang="pt-BR" hist="vertrex-bank">E se o banco algum dia preferir um armazenamento diferente</span>, **qualquer driver de armazenamento compatível com <span id="assignment.2.9" lang="nolang" no>CSI</span> se conecta imediatamente**, liberdade de escolha, nunca aprisionamento (lock-in)
- **<span id="assignment.2.10" lang="nolang" no>Software-defined networking</span>**: VLANs e redes overlay isoladas sem tocar em um único cabo
- **Uma única fatura de código aberto**: sem taxa de <span id="ch1.intro1.1" lang="nolang" no>hypervisor</span> por soquete
- **<span id="assignment.2.11" lang="nolang" no>Support</span> que realmente escuta**: os clientes da SUSE avaliam consistentemente o **SUSE <span id="assignment.2.11" lang="nolang" no>Support</span>** entre os melhores do setor, e seu feedback molda diretamente os próximos passos dos produtos. Tente pedir a um fornecedor de código fechado um lugar nessa mesa

Como a plataforma roda *sobre* <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>, cargas de trabalho em contêineres podem rodar exatamente no mesmo cluster. Deixe a divisão de responsabilidades clara desde o primeiro dia: a interface do <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> gerencia **máquinas virtuais**; gerenciar contêineres (e gerenciar frotas inteiras de clusters) é tarefa do <span id="assignment.2.12" lang="nolang" no>**Rancher Prime**</span>, que você conhecerá em instantes.

<span id="ch1.intro5"  lang="pt-BR" hist="vertrex-bank">Todo componente proprietário que consome o orçamento do banco tem um substituto moderno e de código aberto:</span>

| O mundo antigo (licenciamento por soquete) | <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> |
|--------------------------------------|---------------------|
| <span id="ch1.intro1.1" lang="nolang" no>hypervisor</span> proprietário da ISAware | <span id="assignment.2.3" lang="nolang" no>KubeVirt</span> + <span id="assignment.2.4" lang="nolang" no>KVM</span> |
| Array de armazenamento proprietário |  Armazenamento SUSE, ou qualquer driver <span id="assignment.2.9" lang="nolang" no>CSI</span> <span id="ch1.intro6"  lang="pt-BR" hist="vertrex-bank">o banco escolhe</span> |
| SDN de código fechado | <span id="assignment.2.13" lang="nolang" no>Kube-OVN</span> + <span id="assignment.2.14" lang="nolang" no>Multus</span> |
| Trono de Comando da ISAware | <span id="assignment.2.15" lang="nolang" no>SUSE Rancher Prime</span> |

Sem aprisionamento a fornecedor. Sem taxa de virtualização. Sem kernel proprietário. **Uma única plataforma, uma única fatura**, <span id="ch1.intro7"  lang="pt-BR" hist="vertrex-bank">exatamente o que você prometeu à Sarah na sala de reuniões</span>.

## 🎯 Objetivos da sua Missão

1. Faça login e inspecione o painel unificado
2. Conheça o Rancher Prime, o centro de comando!
3. Valide o tecido de armazenamento distribuído
4. Teste seu acesso ao terminal administrativo

<span id="ch1.intro8"  lang="pt-BR" hist="vertrex-bank">> [!NOTE]
> Aviso: este laboratório tem finalidade educacional e não visa fornecer instruções sobre como configurar um ambiente de produção para um 'banco'. A maioria das decisões tomadas leva em conta as limitações e o propósito deste ambiente.</span>

🔐 Suas Credenciais de Arquiteto
=============================

Para o seu registro, suas Credenciais de Arquiteto são as seguintes:</span>


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


<span id="assignment.3" lang=pt-BR> [!NOTE]
> As interfaces usam certificados autoassinados. Aceite o aviso de segurança do navegador quando ele aparecer. Se uma página não carregar imediatamente, o ambiente do laboratório pode ainda estar inicializando. Aguarde um minuto e atualize a aba.

> [!NOTE]
> Se preferir trabalhar no seu próprio navegador em vez das abas incorporadas, o host do laboratório está acessível diretamente em:
> https://kvm-host.[[ Instruqt-Var key="_SANDBOX_ID" hostname="kvm-host" ]].instruqt.io:8443




📊 Tarefa 1: Fazer login e inspecionar o painel unificado
===================================================

Navegue até o</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.4" lang=pt-BRAcesse a aba e faça login usando suas credenciais.

![01-connect_to_cluster.gif](../assets/chapter1-connect_to_cluster.gif)

Reserve um momento para observar a principal</span>  <span id="assignment.5" lang="nolang" no>**Dashboard**</span><span id="assignment.6" lang=pt-BR: este é o seu centro de comando para toda a missão.


> [!NOTE]
> Não faça nenhuma alteração ainda. Estamos apenas nos familiarizando com o ambiente.


- A primeira seção contém os números gerais:
  - **<span id="assignment.6.1" lang="nolang" no>Hosts</span>** o cluster é composto por
  - **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>** (em execução e paradas)
  - **<span id="assignment.6.3" lang="nolang" no>Images</span>** disponível para implantar novas VMs
  - **<span id="assignment.6.4" lang="nolang" no>Volumes</span>** em uso
  - **<span id="assignment.6.5" lang="nolang" no>Disks</span>** disponível

Clicar em cada um deles leva você a uma seção dedicada com mais informações. Clique em **<span id="assignment.6.1" lang="nolang" no>Hosts</span>**:

Você verá uma visão detalhada dos recursos reservados e utilizados de cada host, bem como os endereços IP do host e outros detalhes.

Observe o  no final de cada linha: clicar nele abre um menu com diferentes ações para aquele host.

Volte para **<span id="assignment.6.6" lang="nolang" no>Dashboard</span>** e veja o que mais há por lá:

- A segunda seção, **<span id="assignment.6.7" lang="nolang" no>Capacity</span>**, lista os recursos atualmente reservados e disponíveis no cluster.

- Abaixo dela há uma seção com duas abas:

  - **<span id="assignment.6.8" lang="nolang" no>Cluster Metrics</span>**: métricas em tempo real sobre o cluster; elas são úteis na solução de problemas de desempenho.

  - **<span id="assignment.6.9" lang="nolang" no>Virtual Machine Metrics</span>**: métricas em tempo real para máquinas virtuais; observe que, se nenhuma VM estiver em execução, não há dados para exibir.

- Na parte inferior, a última seção, **<span id="assignment.6.10" lang="nolang" no>Events</span>**, mostra os eventos mais recentes que ocorrem no cluster.

Agora observe mais a interface. No canto superior direito há um menu suspenso com **All Namespaces** selecionado. Ele permite focar em namespaces específicos. Namespaces aqui são namespaces do <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>: uma forma de organizar recursos e atribuir permissões dedicadas a tudo dentro deles, um conceito semelhante a um "grupo". No final deste capítulo você encontrará links com mais informações; muitos dos conceitos que você encontra em <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> se aplicam diretamente a <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>.

O **sino** contém notificações e alertas, e mais à direita o **ícone de usuário** leva você às configurações de usuário e chaves para acesso automatizado.

No lado esquerdo há uma coluna com diferentes seções. Não vamos percorrer todas agora. Você verá muitas delas nos próximos capítulos. Observe que essas seções mudam dependendo de quais plugins estão habilitados ou desabilitados.

Por fim, no canto inferior esquerdo, clique em **<span id="assignment.2.11" lang="nolang" no>Support</span>**.
Isso leva você a uma página com links para documentação e outros recursos de suporte, além de duas seções importantes:

- **<span id="assignment.6.11" lang="nolang" no>Generate a <span id="assignment.2.11" lang="nolang" no>Support</span> Bundle</span>**: produz um arquivo que ajuda a SUSE <span id="assignment.2.11" lang="nolang" no>Support</span> a solucionar problemas em seu ambiente sem precisar acessá-lo diretamente.
- **<span id="assignment.6.12" lang="nolang" no>Download KubeConfig</span>**: fornece o arquivo kubeconfig que você pode usar para gerenciar este cluster com kubectl e outras ferramentas a partir de um console.

Se ainda tiver tempo, familiarize-se com as seções antes de passar para a próxima tarefa.


> [!NOTE]
> Tudo o que você vê neste painel (VMs, volumes, redes) é, por baixo dos panos, um recurso do <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>. A interface é sua ferramenta principal para esta missão; um terminal fica disponível para os exercícios extras opcionais, caso você tenha curiosidade sobre o funcionamento interno.



🐮 Tarefa 2: Conheça o Rancher Prime, o centro de comando
=================================================

A plataforma também pode ser conectada ao **Rancher Prime**, <span id="ch1.task2a"  lang="pt-BR" hist="vertrex-bank">e é importante entender quem faz o quê no novo mundo do banco:</span>

- <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> gerencia as **máquinas virtuais** neste cluster.
- **Rancher Prime** gerencia **muitos clusters ao mesmo tempo** (todo cluster <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> em cada datacenter regional), além de **usuários, funções e controle de acesso centralizados (<span id="assignment.6.13" lang="nolang" no>RBAC</span>)**, e as **cargas de trabalho de contêiner** que o banco executará junto com suas VMs.

Vamos ver o que há dentro do Rancher.

Abra o [button label="Rancher Prime UI" variant="success"](tab-2), faça login com as mesmas credenciais e selecione **Virtualization Management** no menu à esquerda.


  


A partir daqui você pode gerenciar múltiplos clusters <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>. Importe o cluster existente:

1. Clique em **Import Existing**
2. Defina o **Cluster Name** como


```txt
mysusevirt1
```



3. Clique em **Create**
4. Uma nova tela aparece. Nela uma url é exibida, copie essa url para os próximos passos.
5. Abaixo dela você pode ver as instruções de registro. Siga-as e lembre-se de selecionar **<span id="assignment.6.14" lang="nolang" no>Insecure Skip TLS Verify</span>** ao editar a configuração cluster-registration-url. Isso deve ser feito em [button label="SUSE Virtualization UI" variant="success"](tab-0).

6. Volte para [button label="Rancher Prime UI" variant="success"](tab-2) e clique em "<span id="assignment.2.1" lang="nolang" no>Harvester</span> Clusters" no canto superior esquerdo da interface.

Observe o estado ao lado do nome do cluster: **<span id="assignment.6.15" lang="nolang" no>Pending</span>**. Ele está aguardando o cluster concluir o processo de registro.

Permaneça na interface do Rancher e observe o estado mudar de **<span id="assignment.6.15" lang="nolang" no>Pending</span>** para **<span id="assignment.6.16" lang="nolang" no>Waiting</span>**, e então finalmente para **<span id="assignment.6.17" lang="nolang" no>Active</span>**.

Agora volte para **<span id="assignment.2.1" lang="nolang" no>Harvester</span> Clusters**: o cluster aparece na lista.

Vamos ver o que mais você pode fazer aqui. Clique no  no final da linha do cluster; um menu se abre com algumas opções:

- **<span id="assignment.6.18" lang="nolang" no>Kubectl Shell</span>**: abre um shell conectado ao cluster, onde você pode executar comandos kubectl contra ele.
- **<span id="assignment.6.12" lang="nolang" no>Download KubeConfig</span>**: o mesmo que você já viu na interface <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>.
- **<span id="assignment.6.19" lang="nolang" no>Download YAML</span>**: baixa a definição do cluster em formato YAML; você pode usá-la como modelo para importar novos clusters de forma automatizada (também requer uma etapa extra na interface do cluster).

Por fim, clique no próprio nome do cluster
- isso leva você à interface <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> incorporada dentro da interface do Rancher
- Observe que, na coluna à esquerda, uma entrada '<span id="assignment.6.13" lang="nolang" no>RBAC</span>' aparece no menu; podemos controlar quem pode fazer o quê em nossos clusters.


Com o Rancher você pode operar facilmente múltiplos clusters a partir de um único lugar.



> [!NOTE]
> Existe um rodeo dedicado para o SUSE Rancher Prime, sinta-se à vontade para participar!



⌨️ Tarefa 3: Teste seu acesso administrativo ao terminal
===================================================

Você passará a maior parte desta missão na interface, <span id="ch1.task3a"  lang="pt-BR" hist="vertrex-bank">mas um arquiteto sempre verifica seu acesso de emergência</span>. Clique na aba [button label="Cluster Terminal" variant="success"](tab-1) e execute um comando para verificar se sua conexão com o motor <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> subjacente está ativa:


```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get VirtualMachine -A
```

Você deverá ver a lista de <span id="assignment.6.2" lang="nolang" no>Virtual Machines</span> presentes em todos os namespaces.



💾 Exercício Bônus: valide o tecido de armazenamento distribuído (opcional)
====================================================================

<span id="ch1.bonus1a"  lang="pt-BR" hist="vertrex-bank">Um backend de armazenamento saudável é fundamental para operações bancárias</span>. <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> usa **<span id="assignment.2.7" lang="nolang" no>SUSE Storage</span>** para replicar cada volume em todo o cluster.


  


A [button label="SUSE Virtualization UI" variant="success"](tab-0) já mostra informações sobre a integridade do armazenamento, mas também é possível acessar o painel do <span id="assignment.2.7" lang="nolang" no>SUSE Storage</span> (<span id="assignment.2.8" lang="nolang" no>Longhorn</span>) habilitando os **Extension developer features**:

1. Clique no seu **ícone de usuário** no canto superior direito
2. Selecione **Preferences**
3. Marque **Enable Extension developer features**

Volte para **Home** e, no canto inferior esquerdo, clique em **<span id="assignment.2.11" lang="nolang" no>Support</span>**.

Agora você verá duas novas seções:

- **<span id="assignment.6.20" lang="nolang" no>Access Embedded</span> Rancher UI**
- **<span id="assignment.6.20" lang="nolang" no>Access Embedded</span> <span id="assignment.2.7" lang="nolang" no>SUSE Storage</span> (<span id="assignment.2.8" lang="nolang" no>Longhorn</span>) UI**

Clique na seção **<span id="assignment.2.8" lang="nolang" no>Longhorn</span> UI**.

Isso levará você ao <span id="assignment.2.7" lang="nolang" no>SUSE Storage</span> <span id="assignment.6.6" lang="nolang" no>Dashboard</span>, tudo deve estar verde.
Se um nó estivesse não escalonável ou um volume degradado, o <span id="assignment.2.7" lang="nolang" no>SUSE Storage</span> já estaria reconstruindo réplicas em outro lugar, mas você sempre confirma a verdade no terreno.


🏋️ Exercícios Bônus: para os curiosos de linha de comando (opcional)
==========================================================

Novo em <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Pule à vontade**: tudo o que importa está na interface. Se quiser espiar o funcionamento interno, execute estas verificações extras no [button label="Cluster Terminal" variant="success"](tab-1):

- **Veja o plano de controle do <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> e os endpoints do CoreDNS:**

```bash,wrap,run
kubectl cluster-info --kubeconfig .rodeo/harvester-kubeconfig
```

- **Verifique a integridade dos componentes do cluster**: consulte o endpoint de integridade do plano de controle; cada verificação (etcd, informers, shutdown hooks) deve reportar `ok`:

```bash,wrap,run
kubectl get --raw='/readyz?verbose' --kubeconfig .rodeo/harvester-kubeconfig
```

- **Confirme que todos os nós no tecido estão prontos:**

```bash,wrap,run
kubectl get nodes --kubeconfig .rodeo/harvester-kubeconfig
```

  Todos os nós devem mostrar `Ready`.

- **Verifique se os serviços principais de virtualização estão em execução:**

```bash,wrap,run
kubectl get pods -n harvester-system --kubeconfig .rodeo/harvester-kubeconfig | grep -v Completed
```

  Todos os pods devem estar `Running`.

- **Confirme a versão exata da plataforma que o banco está executando:**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get settings.harvesterhci.io server-version
```

💼 Por que isso importa?
==============================================

- **Um único centro de comando.** VMs, armazenamento e rede ficam visíveis em um único painel, sem mais precisar alternar entre três consoles de gerenciamento separados com três licenças separadas.
- **Nativo do <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> desde o primeiro dia.** Tudo no painel é, por baixo dos panos, um recurso do <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>. As habilidades já existentes da equipe de contêineres se transferem diretamente, enquanto a equipe de VMs ganha uma interface amigável de apontar e clicar.
- **Gerenciamento de frota e <span id="assignment.6.13" lang="nolang" no>RBAC</span> incluídos.** Rancher Prime é <span id="ch1.why1"  lang="pt-BR" hist="vertrex-bank">pronto para comandar todos os clusters que o banco algum dia venha a operar, com um único login e um único conjunto de regras de acesso.</span>
- **Armazenamento distribuído pronto para uso.** <span id="assignment.2.7" lang="nolang" no>SUSE Storage</span> replica dados entre os nós automaticamente.

Assim que você confirmar que o plano de controle está respondendo, o armazenamento está saudável e seu acesso administrativo está protegido, você está pronto para prosseguir mais fundo nas instalações.

Clique em **Check** para descer ao datacenter. 🛗

📚 Mais informações
===================</span>


- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Hardware and Network Requirements](https://documentation.suse.com/cloudnative/virtualization/latest/en/installation-setup/requirements.html)
- [<span id="assignment.2.2" lang="nolang" no>Kubernetes</span> concepts](https://kubernetes.io/docs/concepts/overview/)

---
slug: the-stampede-automation
id: euwnv5ojhvfl
type: challenge
title: '<span id="assignment.138" lang="pt-br" no>🤠 Capítulo 7: A Debandada</span>'
teaser: <span id="assignment.139" lang="pt-br" hist="vertrex-bank">Os mercados estão em queda livre e os quants precisam que a frota de cálculo seja escalada de três nós para cinco, agora. Forje um template de VM padrão e produza máquinas idênticas sob demanda.</span>
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
<span id="assignment.140" lang="pt-br" no>🤠 Capítulo 7: A Debandada
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

<span id="assignment.141" lang="pt-br" hist="vertrex-bank">Uma mudança repentina e agressiva nas taxas de juros globais lança os mercados financeiros em um frenesi caótico. Os algoritmos de análise de risco do Vertex Trust Bank estão implorando por mais capacidade de processamento para lidar com a enxurrada de dados voláteis do mercado que está chegando.

*"Um único mecanismo de cálculo não é mais suficiente!"* grita o **Chefe de Quant** pela sala, agitando um relatório impresso. *"Preciso de uma frota de cinco mecanismos idênticos imediatamente, ou vamos voar às cegas nessa quebra de mercado!"*

Construir cinco máquinas manualmente, uma tela de cada vez, convida exatamente o que você não pode se dar ao luxo agora: um tamanho de memória digitado errado aqui, uma rede esquecida ali. Desvio de configuração sob pressão — e agora, o erro humano custa milhões de dólares **por segundo**.

Você estala os dedos. O que o banco precisa é de um **projeto padrão-ouro**: definir a máquina perfeita uma vez, depois produzir cópias idênticas sob demanda.</span>

</div>

<span id="assignment.142" lang="pt-br" no><span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> tem exatamente isso: **VM Templates**. Um template captura CPU, memória, discos, redes e cloud-init em um único objeto versionado. Combinado com **criação multi-instância**, um blueprint se transforma em uma frota inteira com um único clique.



## 🎯 Objetivos da sua Missão

1. Forjar o template dourado
2. Escalar a frota sob pressão
3. Encerrar a frota



🔐 Credenciais de Login
====================

A UI do <span id="assignment.69.1" lang="nolang" no>**SUSE Virtualization**</span> e a UI do **Rancher Prime** usam as mesmas credenciais.</span>

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



<span id="assignment.143" lang="pt-br" no>📜 Tarefa 1: Forje o modelo dourado
====================================


  


Você precisa de um modelo que acelere a implantação de máquinas virtuais e as padronize.
Em</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.144" lang="pt-br" no>navegue até <span id="assignment.144.1" lang="nolang" no>**Advanced > Templates**</span> e clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>, depois preencha os seguintes detalhes:

- <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: prod
- <span id="assignment.144.2" lang="nolang" no>**Template Name**</span>:</span>

<div class="cred">

```txt
prod-basic
```

</div>

<span id="assignment.145" lang="pt-br" no>Precisamos minimizar o uso de recursos, e todas as VMs devem ser acessíveis usando a chave SSH de produção, que é protegida com segurança.

- Básico:
  - <span id="assignment.42.1" lang="nolang" no>**CPU**</span>: 1
  - <span id="assignment.145.1" lang="nolang" no>**Memory**</span>: 1
  - <span id="assignment.45.1" lang="nolang" no>**SSHKey**</span>: prod/default

Nosso SO base padrão é o SLES 16.

- <span id="assignment.6.4" lang="nolang" no>Volumes</span>:
  - <span id="assignment.45.2" lang="nolang" no>**Image**</span>: official-images/SLES-16.0-Minimal-VM.x86_64-Cloud-GM.qcow2
  - <span id="assignment.45.3" lang="nolang" no>**Size**</span>: 5

Queremos que os servidores de produção ofereçam seus serviços na rede de serviço de produção.

- <span id="assignment.49.1" lang="nolang" no>Networks</span>:
  - <span id="assignment.49.2" lang="nolang" no>**Network**</span>: prod/service

Todas as VMs de produção devem ser executadas apenas em hosts prontos para produção.

- <span id="assignment.51.1" lang="nolang" no>Node Scheduling</span>:
  1. Selecione <span id="assignment.51.5" lang="nolang" no>**Run virtual machine on node(s) matching scheduling rules**</span>
  2. Clique em <span id="assignment.51.6" lang="nolang" no>**Add Node Selector**</span>, depois em <span id="assignment.51.7" lang="nolang" no>**Add Rule**</span>:


- <span id="assignment.51.8" lang="nolang" no>**Key**</span>:</span>

<div class="cred">

```txt
stage
```

</div>

<span id="assignment.52" lang="pt-br" no>Valor</span>

<div class="cred">

```txt
prod
```

</div>


<span id="assignment.146" lang="pt-br" no>Queremos que as VMs sejam devidamente etiquetadas:

- <span id="assignment.53.1" lang="nolang" no>Labels</span>:
  - Clique em <span id="assignment.53.3" lang="nolang" no>**Add Label**</span>:


- <span id="assignment.51.8" lang="nolang" no>**Key**</span>:</span>
<div class="cred">

```txt
stage
```

</div>

<span id="assignment.52" lang="pt-br" no>Valor</span>
<div class="cred">

```txt
prod
```

</div>


<span id="assignment.147" lang="pt-br" no>Finalmente, queremos padronizar todas as máquinas de produção em um conjunto de pacotes e configurações:

- <span id="assignment.54.1" lang="nolang" no>Advanced Options</span>:
  - <span id="assignment.54.4" lang="nolang" no>**User Data Template**</span>: prod/prod

Para finalizar, clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>.

Consegue imaginar preencher todos esses detalhes toda vez? As pessoas desistiriam, e o ambiente ficaria cheio de inconsistências, e a inconsistência torna a automação ainda mais difícil.


> [!NOTE]
> Os templates são **versionados**. Se você editar o template mais tarde, uma nova versão é criada, enquanto as máquinas construídas a partir de versões anteriores mantêm sua linhagem: um registro de auditoria completo do que foi implantado a partir de qual blueprint, o que seus reguladores vão apreciar.


📈 Tarefa 2: Escale a frota sob pressão
=========================================

Como o template já existe, implantar múltiplos servidores leva apenas alguns cliques.


  


Em</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.148" lang="pt-br" no>Vá até **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>** e clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>, depois preencha os seguintes detalhes:

1. Selecione <span id="assignment.148.1" lang="nolang" no>**Multiple Instance**</span>
2. Defina o <span id="assignment.39.3" lang="nolang" no>**Namespace**</span> como prod
3. Defina o <span id="assignment.148.2" lang="nolang" no>**Name Prefix**</span> como:</span>

<div class="cred">

```txt
appcluster
```

</div>


<span id="assignment.149" lang="pt-br" no>4. Defina o <span id="assignment.149.1" lang="nolang" no>**Count**</span> como 2
5. Marque <span id="assignment.149.2" lang="nolang" no>**Use VM Template**</span> e defina o <span id="assignment.149.3" lang="nolang" no>**Template**</span> como prod/prod-basic
6. Clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span></span>




<div id="702" class="story">

<span id="assignment.150" lang="pt-br" hist="vertrex-bank">A equipe de análise de risco começa a alimentar dados na frota expandida, estabilizando a posição do banco no mercado bem a tempo.</span>

</div>


<span id="assignment.151" lang="pt-br" no>🧹 Tarefa 3: Desativando a frota
==================================</span>

<div id="703" class="story">

<span id="assignment.152" lang="pt-br" hist="vertrex-bank">A onda de mercado diminui. As máquinas virtuais ficam paradas, à espera da próxima leva — mas será que ela virá hoje? Amanhã? Mês que vem? Para esses nobres servidores, esperar é mais doloroso do que fazer todo o processamento de números.</span>

</div>

<span id="assignment.153" lang="pt-br" no>Você não precisa mais de tantas máquinas virtuais, exclua todas de uma vez (não se preocupe se elas ainda estiverem iniciando).</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.154" lang="pt-br" no>navegue até a seção <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>:

1. Marque a caixa <span id="assignment.154.1" lang="nolang" no>**checkboxes**</span> ao lado de todas as novas máquinas virtuais que você criou
2. Clique em <span id="assignment.137.2" lang="nolang" no>**Delete**</span>, marque <span id="assignment.154.2" lang="nolang" no>**Delete All**</span> e clique em <span id="assignment.154.3" lang="nolang" no>**Delete**
</span></span>

<div id="704" class="story">

<span id="assignment.155" lang="pt-br" hist="vertrex-bank">O sofrimento dessas nobres máquinas virtuais chegou ao fim. Está vendo as chamas, minha criança? Agora elas descansam no Valhalla.</span>

</div>




<span id="assignment.156" lang="pt-br" no>🏋️ Treinos Bônus: para os curiosos por linha de comando (opcional)
==========================================================

Novo em <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Pule à vontade.** Caso contrário, prove no</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.157" lang="pt-br" no>que a UI, a frota e a API estejam todas em concordância:

- **Inspecione o template como um objeto de API**: templates e suas versões também são recursos:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplates,virtualmachinetemplateversions -n prod
```

- **Recupere a definição do template em formato yaml**:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplates -n prod prod-basic -o yaml > template_prod-basic.yaml
template_version_name=`kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachinetemplateversions -n prod -o name |grep '/prod-basic-'`
kubectl --kubeconfig .rodeo/harvester-kubeconfig get -n prod ${template_version_name} -o yaml >> template_prod-basic.yaml
```

Você pode examinar o arquivo `template_prod-basic.yaml`:


```bash,wrap,run
less template_prod-basic.yaml
```


Ele contém uma definição semelhante à que você usou para criar o template na Tarefa 2.



💼 Por que isso importa?
==============================================

- **Elasticidade em hardware próprio.** <span id="assignment.157.1" lang="pt-br" hist="vertrex-bank">Escala horizontal (scale-out e scale-in) no estilo cloud dentro do próprio datacenter do banco: sem questões de residência de dados, sem custos de egress.</span>
- **O erro humano é eliminado por engenharia.** As máquinas vêm de um blueprint dourado versionado, não da memória e da prática manual: o desvio de configuração não pode acontecer às 2 da manhã.
- **Economia completa do ciclo de vida.** Desativar é uma caixa de seleção e um clique, então a capacidade temporária nunca se torna custo permanente, exatamente o oposto da antiga proliferação de <span id="ch1.intro1.1" lang="nolang" no>hypervisor</span>.

Clique <span id="assignment.32.1" lang="nolang" no>**Check**</span> para continuar. ⚔️

📚 Mais informações
===================</span>

- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Creating <span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)

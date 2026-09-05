---
slug: the-flash-crash-first-vm
id: 09d4eiczcvaw
type: challenge
title: '<span id="assignment.33" lang="pt-br" hist="vertrex-bank">⚡ Capítulo 3: O Flash Crash</span>'
teaser: <span id="assignment.34" lang="pt-br" hist="vertrex-bank">Os mercados asiáticos estão em colapso e os quants precisam de um mecanismo de cálculo AGORA. Implante uma VM totalmente configurada com armazenamento e credenciais em minutos, não em dias.</span>
tabs:
- id: 6byxu4pxkfpm
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: 381amyptjwzi
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: wxzurljjianr
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: basic
timelimit: 3000
enhanced_loading: null
---
<span id="assignment.35" lang="pt-br" hist="vertrex-bank">⚡ Capítulo 3: O Crash Relâmpago
=============================</span>

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
    max-height: 1.5vh;
    max-width: 1.5vh;
    margin: 0;
    padding: 0;
    display: inline-block;
  }

</style>

<img class="logos" alt="Welcome!" src="../assets/03-chapter-img.png"/>

<div id="301" class="story">

<span id="assignment.36" lang="pt-br" hist="vertrex-bank">Você está sentado em um escritório improvisado logo fora do datacenter, no meio da revisão da topologia de rede, quando as luzes de emergência do teto de repente piscam num amarelo intenso. Seu rádio ganha vida com um estalo. É o **Chefe de Trading Quantitativo**, e ele parece em pânico.

*"Temos uma anomalia enorme nos mercados asiáticos!"* ele grita por cima do barulho caótico de um pregão em polvorosa. *"Nossos modelos algorítmicos atuais estão falhando em processar o fluxo de dados recebido rápido o suficiente. Precisamos de um novo mecanismo de cálculo de alto desempenho, dedicado, implantado imediatamente, com um volume de dados secundário de alta velocidade, ou vamos sangrar milhões nos próximos dez minutos!"*

No passado, atender a essa solicitação de emergência no Vertex Trust Bank significava abrir um chamado prioritário, esperar a equipe de infraestrutura reservar alocações de armazenamento e instalar manualmente um sistema operacional. Era um processo que levava **dias**.

Você não tem dias. **Você tem minutos.**

Você ignora completamente o sistema de chamados legado e se prepara para implantar uma máquina virtual <span id="assignment.2.6" lang="nolang" no>Linux</span> totalmente configurada (com credenciais de segurança injetadas e armazenamento anexado) em meros segundos.</span>
</div>


<span id="assignment.37" lang="pt-br" no>## 🎯 Seus Objetivos da Missão

1. Verifique a imagem do sistema operacional
2. Provisione o <span id="assignment.37.1" lang="pt-br" hist="vertrex-bank">motor de cálculo</span>
3. Acesse o Console Web



🔐 Credenciais de Login
====================

A UI do **<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>** e a UI do **Rancher Prime** usam as mesmas credenciais.</span>

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




<span id="assignment.38" lang="pt-br" no>📀 Tarefa 1: Verifique a imagem do sistema operacional
========================================================

Vá até o</span> [button label="<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> UI" variant="success"](tab-0) <span id="assignment.39" lang="pt-br" no>, navegue até **<span id="assignment.6.3" lang="nolang" no>Images</span>** no painel lateral esquerdo e confirme que a imagem do sistema operacional base <span id="assignment.39.1" lang="nolang" no>**SLES-16.0-Minimal-VM.x86_64-Cloud-GM.qcow2**</span> está presente e marcada como **<span id="assignment.6.17" lang="nolang" no>Active</span>**.

> [!NOTE]
> <span id="assignment.6.3" lang="nolang" no>Images</span> em <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> são imagens-mestre globais para todo o cluster. Cada VM que você inicializar a partir dessa imagem obtém seu próprio disco copy-on-write. A imagem em si nunca é modificada.

**Se a imagem estivesse ausente**, você mesmo poderia adicioná-la em segundos, sem precisar esperar por um administrador de armazenamento.

As imagens podem ser criadas a partir de uma URL, enviadas do seu computador de trabalho ou exportadas de um volume existente por meio de <span id="assignment.39.2" lang="nolang" no>**Images > Create**</span>:


  


Por exemplo, vamos adicionar uma nova imagem:

1. Vá até **<span id="assignment.6.3" lang="nolang" no>Images</span>** no painel esquerdo e clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>, depois preencha os seguintes detalhes:
   - <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: official-images
   - <span id="assignment.19.4" lang="nolang" no>**Name**</span>: preenchido automaticamente
   - Básico:
     - <span id="assignment.39.4" lang="nolang" no>**URL**</span>:</span>

<div class="cred">

```txt
http://192.168.122.1:8889/SLES15-SP7-Minimal-VM.x86_64-Cloud-GM.qcow2
```

</div>


<span id="assignment.40" lang="pt-br" no>2. Clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>

A imagem que você acabou de criar aparece na lista com o estado <span id="assignment.40.1" lang="nolang" no>**Downloading**</span>. Você pode acompanhá-la na coluna de progresso.

Avance para a próxima tarefa; assim que o download for concluído, um alerta aparece no **sino de notificações** no canto superior direito da tela.


> [!NOTE]
> O download é executado no lado do servidor, a partir de um espelho local na própria rede deste laboratório, por isso é concluído em segundos. A imagem se torna **<span id="assignment.6.17" lang="nolang" no>Active</span>** assim que <span id="assignment.2.8" lang="nolang" no>Longhorn</span> a tiver replicado.


🚀 Tarefa 2: Provisionar o mecanismo de cálculo
===========================================


Para esta tarefa, vamos criar nossa primeira VM.


> [!NOTE]
> Por favor, não clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span> até que seja instruído.


  



Navegue até <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span> e clique no botão <span id="assignment.19.3" lang="nolang" no>**Create**</span>.

<span id="assignment.40.3" lang="pt-br" hist="vertrex-bank">Configure o motor exatamente como os quants precisam.</span>

- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>
<div class="cred">

```txt
the-engine-01
```

</div>

<span id="assignment.41" lang="nolang" no>
- **Namespace**:
</span>
<div class="cred">

```txt
prod
```

</div>


<span id="assignment.42" lang="pt-br" no>Se o namespace não existir, crie-o.

- <span id="assignment.42.1" lang="nolang" no>**CPU**</span>:</span>
<div class="cred">

```txt
2
```

</div>


<span id="assignment.43" lang="nolang" no>
- **Memory**:
</span>
<div class="cred">

```txt
2
```

</div>


<span id="assignment.44" lang="pt-br" hist="vertrex-bank">Perceba os recursos muito baixos: nossa futura equipe de quants é altamente qualificada, e sua aplicação é extremamente otimizada para baixa latência e baixo uso de recursos.</span>

<span id="assignment.45" lang="pt-br" no>- <span id="assignment.45.1" lang="nolang" no>**SSHKey**</span>: prod/default

Na aba <span id="assignment.6.4" lang="nolang" no>Volumes</span> (verde, não confundir com a preta), preencha os seguintes detalhes:

- <span id="assignment.45.2" lang="nolang" no>**Image**</span>: official-images/SLES-16.0-Minimal-VM.x86_64-Cloud-GM.qcow2
- <span id="assignment.45.3" lang="nolang" no>**Size**</span>:</span>
<div class="cred">

```txt
5
```

</div>

<span id="assignment.46" lang="pt-br" no>Em seguida, adicione um novo volume clicando em <span id="assignment.46.1" lang="nolang" no>**Add Volume**</span> e preencha os seguintes detalhes:

- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>
<div class="cred">

```txt
market-data-vol
```

</div>

<span id="assignment.47" lang="nolang" no>
- **Size**:
</span>
<div class="cred">

```txt
1
```

</div>

<span id="assignment.48" lang="pt-br" hist="vertrex-bank">Agora conecte o motor à rede do banco.</span><span id="assignment.49" lang="pt-br" no>Na aba <span id="assignment.49.1" lang="nolang" no><b style="color:#30ba78;">Networks</b></span> (verde, para não confundir com a preta):

- <span id="assignment.49.2" lang="nolang" no>**Network**</span>: <span id="assignment.49.3" lang="nolang" no><b class="highlightcopy">prod/service</b></span></span>
<div id="302" class="story">


<span id="assignment.50" lang="pt-br" hist="vertrex-bank">Isso atende ao pedido do trader por um segundo disco de dados de alta velocidade. Nos bastidores, ambos os discos se tornam volumes <span id="assignment.2.8" lang="nolang" no>Longhorn</span> replicados, os dados de mercado sobrevivem mesmo que um disco físico falhe durante uma negociação.</span>

</div>


<span id="assignment.51" lang="pt-br" no>Já que este é um cluster de ambiente misto, vamos garantir que a VM seja executada apenas em nós de produção.

Clique em <span id="assignment.51.1" lang="nolang" no><b style="color:#30ba78;">Node Scheduling</b></span>: <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> oferece três opções:

- <span id="assignment.51.2" lang="nolang" no>**Any available node**</span>: o agendador do <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> escolhe onde posicionar a VM, e **a migração ao vivo permanece habilitada**
- <span id="assignment.51.3" lang="nolang" no>**Specific node**</span>: fixa a VM em um nó (nenhuma migração é possível)
- <span id="assignment.51.4" lang="nolang" no>**Scheduling rules**</span>: regras de afinidade baseadas em rótulos de nó (capacidade de GPU, topologia NUMA, zona de rede…)

Configure a regra de produção:

1. Selecione <span id="assignment.51.5" lang="nolang" no>**Run virtual machine on node(s) matching scheduling rules**</span>
2. Clique em <span id="assignment.51.6" lang="nolang" no>**Add Node Selector**</span>, depois em <span id="assignment.51.7" lang="nolang" no>**Add Rule**</span>:

- <span id="assignment.51.8" lang="nolang" no>**Key**</span>:</span>
<div class="cred">

```txt
stage
```

</div>

<span id="assignment.52" lang="nolang" no>
- **Value**:
</span>
<div class="cred">

```txt
prod
```

</div>


<span id="assignment.53" lang="pt-br" no>Agora atribua uma etiqueta a ele:

Vá até a aba <span id="assignment.53.1" lang="nolang" no><b style="color:#30ba78;">Labels</b></span> (não confundir com <span id="assignment.53.2" lang="nolang" no>"Instance Labels"</span>) e clique em <span id="assignment.53.3" lang="nolang" no>**Add Label**</span>:

- <span id="assignment.51.8" lang="nolang" no>**Key**</span>:</span>
<div class="cred">

```txt
stage
```

</div>

<span id="assignment.52" lang="nolang" no>
- **Value**:
</span>
<div class="cred">

```txt
prod
```

</div>

<span id="assignment.54" lang="pt-br" no>Isso ajudará a gerenciar a VM com automação futura.


Navegue até <span id="assignment.54.1" lang="nolang" no><b style="color:#30ba78;">Advanced Options</b></span> (não confunda com <span id="assignment.54.2" lang="nolang" no>'Advanced'</span>, na coluna da esquerda) e, em seguida, selecione <span id="assignment.54.3" lang="nolang" no>**Cloud Configuration**</span>, para garantir que o sistema seja iniciado com todas as configurações e pacotes necessários instalados.

Clique em <span id="assignment.54.4" lang="nolang" no>**User Data Template**</span> e selecione <span id="assignment.54.5" lang="nolang" no>**Create New**</span> para definir um modelo padrão. Nomeie-o como:

- <span id="assignment.19.4" lang="nolang" no>**Name**</span>:</span>
<div class="cred">

```txt
prod
```

</div>


<span id="assignment.55" lang="pt-br" no>Para o <span id="assignment.55.1" lang="nolang" no>**User Data**</span>, insira:

```yaml
#cloud-config
packages:
  - qemu-guest-agent
runcmd:
  - - systemctl
    - enable
    - --now
    - qemu-guest-agent.service
write_files:
  - path: /etc/issue
    content: |
      \e{red}Production\e{reset}
    append: true
ssh_authorized_keys:
  - ssh-ed25519
    AAAAC3NzaC1lZDI1NTE5AAAAIFdt8wX4G0WGg/l4uDq/LntBO7WiNyqh0+pNUzF/NfMa
```

Salve o template clicando em <span id="assignment.19.3" lang="nolang" no>**Create**</span> (dentro da caixa do template)

Como o template está no namespace <span id="assignment.55.2" lang="nolang" no><b class="highlightcopy">prod</b></span> e tem o nome <span id="assignment.55.2" lang="nolang" no><b class="highlightcopy">prod</b></span>, ele se torna prod/prod: o padrão de produção, pronto para ser usado em todas as VMs.</span>
<div id="303" class="story">
<span id="assignment.56" lang="pt-br" hist="vertrex-bank">A equipe de firewall da mesa de operações tem mais uma exigência:</span>
</div>

<span id="assignment.57" lang="pt-br" no>O engine precisa subir com um **endereço previsível**, não o que o DHCP fornecer. No campo <span id="assignment.57.1" lang="nolang" no>**Network Data**</span>, insira:

```yaml
version: 2
ethernets:
  enp1s0:
    addresses:
      - 192.168.122.50/24
    gateway4: 192.168.122.1
    nameservers:
      addresses:
        - 192.168.122.1
```

O cloud-init aplica ambos na primeira inicialização: <span id="assignment.57.2" lang="nolang" no><b class="highlightcopy">the-engine-01</b></span> ficará online em `192.168.122.50` sem nenhuma configuração manual pós-implantação.

> [!NOTE]
> Isso é **cloud-init**, o mesmo mecanismo padrão da indústria usado por todas as grandes nuvens públicas.
> Em um cenário real haveria automação mais completa e templates dedicados para a finalidade deste servidor.


Agora que terminamos a configuração, clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span> para iniciar a implantação da Máquina Virtual.

Não espere que ela termine de inicializar, prossiga para a próxima tarefa.</span>

<div id="304" class="story">
<span id="assignment.58" lang="pt-br" hist="vertrex-bank">As regras de escalonamento permitem separar sistemas críticos de outras cargas de trabalho, por exemplo, fixando os motores de negociação em nós de baixa latência enquanto os jobs em lote compartilham o restante. Manter "qualquer nó disponível" aqui é importante: é isso que torna possível a evacuação com zero downtime no próximo capítulo.</span>

</div>

<span id="assignment.59" lang="pt-br" hist="vertrex-bank">> [!NOTE]
> **Quando microssegundos valem dinheiro:** a mesa de negociação de alta frequência vai exigir mais do que regras de posicionamento e hardware dedicado. <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> pode **fixar núcleos de CPU dedicados** em uma VM, repassar hardware diretamente, virtualizar hardware usando **SR-IOV** (tanto para NICs quanto para GPUs) e dividir GPUs de datacenter em partições **MIG** isoladas por hardware, para que várias VMs compartilhem uma única GPU sem interferência entre vizinhos. Dedicar recursos físicos a uma VM garante **latência previsível e consistente**. Este exercício tem apenas fins educacionais e não é uma recomendação de como configurar uma aplicação de negociação de alta frequência.</span>

<span id="assignment.60" lang="pt-br" no>> [!IMPORTANT]
> Já que este laboratório roda em uma **configuração aninhada**, o desempenho de I/O é um pouco mais lento que o normal, e o processo de provisionamento levará alguns minutos. Enquanto sua VM é inicializada, preparamos um pouco de entretenimento para você! Acesse os Bonus Drills para aprender a interagir com a API do <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> usando a CLI. Tudo em <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> é um objeto <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>, o que significa que você pode gerenciá-lo por meio da API do <span id="assignment.2.2" lang="nolang" no>Kubernetes</span> através do cluster RKE2 subjacente.
> Quando terminar, volte para a Tarefa 3.

🖥️ Tarefa 3: Acessar o Console Web
=================================

Monitore o</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.61" lang="pt-br" no>até que a máquina virtual passe para o estado **Em execução**.


  



1. Clique no botão <span id="assignment.61.1" lang="nolang" no>**Console**</span> na linha da máquina virtual para abrir o console web VNC
2. Observe que podemos acessar o sistema sem uma conexão usando esse método, **não espere a instalação terminar, apenas avance para o próximo**.
3. Feche a janela do console



🏋️ Exercícios bônus: enxergando através da abstração (opcional, para os curiosos de linha de comando)
========================================================================================

Novo em <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Pule à vontade.** Caso contrário, de volta ao</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.62" lang="pt-br" no>, dê uma olhada no que a plataforma realmente criou para você:

- **As imagens douradas também são objetos de API:**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachineimages -A
```

- **A VM é um recurso <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>:**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachines -n prod
```

- **A instância em execução, com seu nó e IP** (o mesmo IP que você usou para SSH):

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get vmi -n prod -o wide
```

- **Os discos são <span id="assignment.62.1" lang="nolang" no>PersistentVolumeClaims</span> comuns respaldados por <span id="assignment.2.8" lang="nolang" no>Longhorn</span>:**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get pvc -n prod
```

Você deve reconhecer `market-data-vol` na lista: <span id="assignment.62.2" lang="pt-br" hist="vertrex-bank">uma unidade de dados bancários, expressa como armazenamento nativo em nuvem</span>.

💼 Por que isso importa?
========================

- **Dias se tornam minutos.** Um processo de provisionamento multiequipe orientado por tickets se transformou em um fluxo de autoatendimento de dois minutos, <span id="assignment.62.3" lang="pt-br" hist="vertrex-bank">durante uma crise de mercado ao vivo.</span>
- **Consistência por construção.** Imagens douradas mais cloud-init significam que cada engine que os quants solicitam inicializa idêntica, configurada e pronta.
- **Sem armazenamento órfão.** <span id="assignment.6.4" lang="nolang" no>Volumes</span> são extraídos sob demanda do pool compartilhado de <span id="assignment.2.8" lang="nolang" no>Longhorn</span>.</span>

<div id="305" class="story">

<span id="assignment.63" lang="pt-br" hist="vertrex-bank">Você chama a equipe de operações pelo rádio. *"Seu motor está online e o volume de dados está anexado."* A crise foi evitada — mas o dia está longe de terminar.</span>

</div>

<span id="assignment.64" lang="pt-br" no>Clique em <span id="assignment.32.1" lang="nolang" no>**Check**</span> para continuar. 🌊

📚 Mais informações
===================</span>

- [Creating <span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)
- [<span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>: Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)

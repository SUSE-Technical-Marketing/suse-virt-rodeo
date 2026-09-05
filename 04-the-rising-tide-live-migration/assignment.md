---
slug: the-rising-tide-live-migration
id: xjv2r0tfyztq
type: challenge
title: '<span id="assignment.65" lang="pt-br" hist="vertrex-bank">🌊 Capítulo 4: A Maré Crescente</span>'
teaser: <span id="assignment.66" lang="pt-br" hist="vertrex-bank">Um vazamento de refrigerante está inundando o rack que hospeda o Payment Gateway. Execute uma migração ao vivo sem downtime antes que o hardware entre em curto, enquanto as transações continuam fluindo.</span>
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
<span id="assignment.67" lang="pt-br" hist="vertrex-bank">🌊 Capítulo 4: A Maré Crescente
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

<span id="assignment.68" lang="pt-br" hist="vertrex-bank">A adrenalina do incidente no pregão mal havia baixado quando um gemido metálico e profundo ecoa pelas paredes do datacenter. Você e Sarah se viram simultaneamente em direção ao **Rack 4**. Uma válvula primária de refrigeração se rompeu no teto, e um fluxo constante de água gelada e tratada quimicamente está caindo diretamente sobre o chassi do servidor físico que hospeda o **Gateway de Pagamentos** principal do banco.

*"Se esse servidor entrar em curto, o gateway cai,"* diz Sarah, um pânico genuíno tomando conta de sua voz enquanto observa a poça de água se formar. *"Se o gateway cair, toda e cada transação de cartão de crédito do Vertex Trust Bank falha. Estaremos enfrentando investigações regulatórias federais até de manhã."*

*"Não vamos deixar ele cair,"* você responde, seus dedos voando pelo teclado.</span>

</div>

<span id="assignment.69" lang="pt-br" no>Você não pode desligar a máquina para movê-la; o fluxo de transações é muito crítico, processando milhares de requisições por segundo. Você deve executar uma **migração ao vivo**, movendo uma VM em execução, memória e tudo mais, para um nó físico diferente com **zero downtime**.

Mas antes, para garantir a máxima largura de banda disponível para a migração de emergência, você decide suspender um servidor de processamento em lote não crítico nas proximidades.

## 🎯 Objetivos da sua Missão

1. Suspender cargas de trabalho não críticas para liberar recursos
2. Estabelecer um heartbeat de serviço
3. Executar a Migração ao Vivo
4. Monitorar a transferência perfeita
5. Retomar as operações normais
6. Entregar o rack danificado para a equipe de reparo

🔐 Credenciais de Login
====================

A interface do <span id="assignment.69.1" lang="nolang" no>**SUSE Virtualization**</span> e a interface do **Rancher Prime** usam as mesmas credenciais.</span>

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



<span id="assignment.72" lang="pt-br" no>⏸️ Tarefa 1: Suspender workloads não críticos para liberar recursos
===========================================================</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.73" lang="pt-br" no>, vá até <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>:

1. Localize a máquina virtual chamada:</span>

<div class="cred">

```txt
daily-batch-processor
```

</div>

<span id="assignment.74" lang="pt-br" no>2. Clique no  no lado direito da sua linha
3. Selecione <span id="assignment.74.1" lang="nolang" no>**Pause**</span> e depois clique em <span id="assignment.74.2" lang="nolang" no>**Apply**</span> quando solicitado a confirmar.
4. Aguarde até seu estado mudar para <span id="assignment.74.3" lang="nolang" no>**Paused**</span>

Isso interrompe seus ciclos de CPU, dedicando o máximo de recursos de hardware à sua operação de emergência.

> [!NOTE]
> Isso não é realmente necessário, já configuramos uma rede dedicada para o tráfego de live migration, está aqui apenas para fins educacionais</span>



<span id="assignment.75" lang="pt-br" no>📡 Tarefa 2: Estabeleça um heartbeat de serviço
================================================


  


Mude para o</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.76" lang="pt-br" no>Você precisa de um monitor de heartbeat contínuo para comprovar que a conexão de rede permanece intacta durante a evacuação.

Inicie o monitor de heartbeat a partir de <span id="assignment.76.1" lang="nolang" no><b class="highlightcopy">webserver-prod</b></span>:

```bash,run
ssh -o StrictHostKeyChecking=accept-new  sles@[[ Instruqt-Var key="PAYMENT_GATEWAY_IP" hostname="kvm-host" ]] 'ping 192.168.122.1'

```

> [!IMPORTANT]
> Deixe o ping em execução contínua no terminal. **Não o interrompa.** Esse fluxo contínuo de respostas é a sua prova de zero downtime. Volte o foco para a interface <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span>.</span>

<span id="assignment.77" lang="pt-br" no>🚚 Tarefa 3: Executar a Migração ao Vivo
=====================================


  


No</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.78" lang="pt-br" no>, acesse **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>** e localize a seguinte instância:</span>

<div class="cred">

```txt
webserver-prod
```

</div>

<span id="assignment.79" lang="pt-br" no>1. Anote na coluna <span id="assignment.79.1" lang="nolang" no>**Node**</span> em qual node o gateway está rodando: você vai querer provar que ele foi movido
2. Clique no ícone do lado direito da linha correspondente
3. Selecione <span id="assignment.79.2" lang="nolang" no>**Migrate**</span> no menu de contexto
4. Escolha um node de destino diferente e seguro na lista suspensa
5. Clique em <span id="assignment.74.2" lang="nolang" no>**Apply**</span>

Nos bastidores, o <span id="assignment.2.3" lang="nolang" no>KubeVirt</span> copia as páginas de memória ativa da VM para o node de destino pela rede, rastreando e recopiando quaisquer páginas que o gateway ocupado altere durante o processo, até conseguir congelar, alternar e retomar a execução no novo node em uma fração de segundo.</span>

<span id="assignment.80" lang="pt-br" no>👀 Tarefa 4: Monitore a transferência contínua
================================================


  


Volte imediatamente para</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.81" lang="pt-br" no>Fique nesta aba e observe a sequência de ping.</span>

<div id="402" class="story">

<span id="assignment.82" lang="pt-br" hist="vertrex-bank">Você prende a respiração enquanto o <span id="ch1.intro1.1" lang="nolang" no>hypervisor</span> coordena a transferência massiva de memória pela rede. Os pings continuam rolando pela tela, **completamente ininterruptos**. A máquina virtual se materializa perfeitamente no novo nó físico bem quando faíscas começam a sair do chassi danificado pela água no Rack 4.</span>

</div>

<span id="assignment.83" lang="pt-br" no>Pressione `Ctrl+C` para encerrar o ping.</span>

<div id="403" class="story">
<span id="assignment.84" lang="pt-br" hist="vertrex-bank">Você solta a respiração com força. O fluxo de transação sobreviveu.</span>
</div>


<span id="assignment.85" lang="pt-br" no>Estritamente falando, *há* sim um momento de transferência: uma vez que a cópia de memória converge, a VM congela por um último instante enquanto a execução muda para o novo nó, uma microinterrupção. Em uma infraestrutura devidamente dimensionada, isso passa completamente despercebido; mesmo neste laboratório, que roda virtualização *dentro* de virtualização *dentro* de virtualização, o máximo que você poderia ter notado seriam tempos de latência ligeiramente mais altos nos pings.

Voltando ao</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.86" lang="pt-br" no>, a coluna <span id="assignment.79.1" lang="nolang" no>**Node**</span> do webserver-prod agora mostra um **nó diferente** daquele que você anotou.</span><span id="assignment.87" lang="pt-br" hist="vertrex-bank">O portão foi fisicamente movido enquanto seus clientes nunca notaram.</span>

<div id="404" class="story">
<span id="assignment.88" lang="pt-br" hist="vertrex-bank">Agora produza a evidência que Sarah vai encaminhar aos reguladores — o contador de tempo de atividade do convidado nunca foi reiniciado, o que significa que o sistema operacional nunca parou de funcionar:</span>
</div>

```bash,wrap,run
ssh -o StrictHostKeyChecking=accept-new  sles@[[ Instruqt-Var key="PAYMENT_GATEWAY_IP" hostname="kvm-host" ]] "hostname && uptime"
```

<span id="assignment.89" lang="pt-br" no>▶️ Tarefa 5: Retomar as operações normais
===========================================


  


Volte para o</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.90" lang="pt-br" no>Localize a máquina virtual que você pausou anteriormente:</span>

<div class="cred">

```txt
daily-batch-processor
```

</div>

<span id="assignment.91" lang="pt-br" no>1. Clique no  na sua linha
2. Selecione <span id="assignment.91.1" lang="nolang" no>**Unpause**</span> para permitir que os trabalhos não críticos sejam retomados

🛠️ Tarefa 6: Entregar o rack danificado à equipe de reparo
====================================================</span>


<div id="405" class="story">
<span id="assignment.92" lang="pt-br" hist="vertrex-bank">O gateway está seguro — mas o nó danificado pela água ainda está pingando, e cargas de trabalho menores ainda podem estar rodando nele. Você não vai migrá-las uma por uma enquanto uma poça se espalha pelo chão. Deixe a plataforma gerenciar isso.</span>
</div>


<span id="assignment.93" lang="pt-br" no>The text to translate appears to be cut off — I only see "In the " with nothing after it. Could you provide the complete text?</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.94" lang="pt-br" no>, vá para <span id="assignment.94.1" lang="nolang" no>**Hosts**</span>:

1. Encontre o node em que o webserver-prod estava sendo executado **antes** da migração, aquele que você anotou.</span>

<i id="406" class="story"><span id="assignment.95" lang="pt-br" hist="vertrex-bank">Essa é a máquina danificada pela água</span></i>

<span id="assignment.96" lang="pt-br" no>2. Clique no ícone na linha correspondente e selecione <span id="assignment.96.1" lang="nolang" no>**Enable Maintenance Mode**</span>, depois <span id="assignment.96.2" lang="nolang" no>confirm</span>

Agora observe a página **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>**: toda VM que ainda está no nó danificado faz live-migration para fora dele **automaticamente**. A plataforma escolhe nós de destino saudáveis, move as cargas de trabalho uma a uma e deixa o nó vazio. Sem planilhas, sem escolha manual de destino, sem VM esquecida.

> [!NOTE]
> Isso pode levar algum tempo neste ambiente de laboratório.

Quando o nó mostrar <span id="assignment.96.3" lang="nolang" no>**Maintenance**</span> e a contagem de VMs chegar a zero, a equipe de reparo (virtual) troca a válvula de refrigeração (virtual). Coloque o nó de volta em serviço:

3. Clique novamente no ícone na linha correspondente e selecione <span id="assignment.96.4" lang="nolang" no>**Uncordon**</span> e depois <span id="assignment.96.5" lang="nolang" no>**Disable Maintenance Mode**</span>

O nó volta a fazer parte do tecido do cluster, pronto para receber cargas de trabalho novamente.

> [!NOTE]
> A mesma inteligência funciona na direção oposta também: toda vez que uma nova VM é criada, o agendador a posiciona no nó adequado com menor carga, mantendo o cluster naturalmente equilibrado, sem necessidade de Tetris manual. Entre o posicionamento automático na entrada e a evacuação automática na saída, os humanos só decidem *o que* deve rodar; a plataforma decide *onde*.</span>

<span id="assignment.97" lang="pt-br" no>🏋️ Exercícios Bônus: o rastro em papel das migrações (opcional, para os curiosos de linha de comando)
======================================================================================


  


Novo em <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>? **Pule à vontade.** Caso contrário: toda migração é, ela própria, um objeto <span id="assignment.2.2" lang="nolang" no>Kubernetes</span>, o que significa que ela é auditável. Na</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.98" lang="pt-br" no>- **Revise o registro de migração** (quem migrou, quando, de onde para onde):

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get virtualmachineinstancemigrations -A
```

- **Inspecione os detalhes da migração concluída:**

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig describe virtualmachineinstancemigrations -A | grep -A 10 "Status"
```

- **Pense adiante:** o que acontece se um *nó* falhar sem aviso, antes que alguém consiga migrar? Verifique a estratégia de execução de cada VM: <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> pode reagendar VMs de um host com falha automaticamente:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get vm -A -o custom-columns=NAME:.metadata.name,RUNSTRATEGY:.spec.runStrategy
```

> [!NOTE]
> **Além da computação:** a mesma ideia de zero downtime também se aplica a *discos*. <span id="ch1.intro1.2" lang="nolang" no>SUSE Virtualization</span> oferece suporte à **migração ao vivo de armazenamento in-place** (mover os volumes de uma VM em execução entre backends de armazenamento, por exemplo de <span id="assignment.2.8" lang="nolang" no>Longhorn</span> para um array externo <span id="assignment.2.9" lang="nolang" no>CSI</span>) sem parar a VM. Computação evacuada hoje à noite, armazenamento evacuado no próximo trimestre, e o gateway nunca percebe nenhuma das duas.</span>

<span id="assignment.99" lang="pt-br" no>💼 Por que isso importa?
==============================================

- **Falhas de hardware deixam de ser interrupções.** Vazamentos de refrigerante, atualizações de firmware, reinicializações de host: as cargas de trabalho simplesmente migram para nós saudáveis enquanto seus serviços continuam funcionando.
- **Manutenção planejada sem janelas à meia-noite.** Um clique em **Modo de Manutenção** drena automaticamente um nó inteiro. A aplicação de patches de rotina acontece às 14h em vez de 2h da manhã, e ninguém precisa manter uma planilha de qual VM está em qual lugar.
- **Uma trilha de auditoria que os órgãos reguladores conseguem ler.** Cada migração é um objeto de API registrado, chega de reconstruir o que aconteceu a partir de capturas de tela do console.

Clique em **Check** para continuar. 🕵️

📚 Mais informações
===================</span>

- [Live Migration](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/live-migration.html)

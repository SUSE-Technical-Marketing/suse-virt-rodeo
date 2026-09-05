---
slug: the-unthinkable-error-snapshots
id: nkrkc4vyyywt
type: challenge
title: '<span id="assignment.116" lang="pt-br" hist="vertrex-bank">⏪ Capítulo 6: O Erro Inconcebível</span>'
teaser: <span id="assignment.117" lang="pt-br" hist="vertrex-bank">Um cursor escorregou e apagou um registro de liquidação de US$ 100 milhões. Volte no tempo com snapshots de VM, verifique a recuperação em um clone de staging seguro e, em seguida, torne a proteção permanente com backups agendados fora do cluster.</span>
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
<span id="assignment.118" lang="pt-br" hist="vertrex-bank">⏪ Capítulo 6: <span id="assignment.118.1" lang="pt-br" no>O Erro Impensável</span>
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

<span id="assignment.119" lang="pt-br" hist="vertrex-bank">Na manhã seguinte, o silêncio exausto do turno da noite é bruscamente interrompido por um palavrão abafado vindo da mesa do administrador júnior de banco de dados.

Você e Sarah vão até lá imediatamente. O administrador júnior está olhando para a tela em completo horror, as mãos tremendo sobre o teclado. Ao tentar limpar arquivos temporários obsoletos no servidor primário de livro-razão de transações, o cursor dele escorregou. Ele executou acidentalmente um comando de exclusão recursiva no diretório errado.

Um registro de liquidação de transação corporativa de cem milhões de dólares, finalizado apenas momentos antes, foi completamente apagado do disco.

*"Eu destruí,"* sussurra o administrador, trêmulo. *"A execução da fita de backup só acontece à meia-noite. Os dados simplesmente sumiram."*

Sarah fecha os olhos, esfregando as têmporas, se preparando para o impacto devastador que isso terá no preço das ações e na reputação do banco. Mas você coloca uma mão firme no ombro do administrador.

*"Os dados não sumiram,"* você diz com calma. *"Nossa nova arquitetura de armazenamento depende de snapshots distribuídos em nível de bloco. Eu tirei uma captura de estado de referência bem antes do início do turno da manhã."*

Você se aproxima do terminal dele. É hora de voltar no tempo. Mas você precisa ter cuidado: quer **verificar os dados restaurados em um ambiente isolado seguro antes de sobrescrever a produção**.</span>

</div>

<span id="assignment.120" lang="pt-br" no>## 🎯 Seus Objetivos da Missão

1. Simule a criação e a destruição do registro
2. Clone um ambiente de staging a partir do snapshot
3. Verifique os dados na sandbox de staging
4. Restaure o sistema de produção
5. Conecte o <span id="assignment.120.1" lang="nolang" hist="vertrex-bank">bank's off-cluster backup vault</span>
6. Coloque os backups em uma programação



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



<span id="assignment.121" lang="pt-br" no>💥 Tarefa 1: Simule a criação e destruição do registro
==============================================================


  


Você reproduzirá os eventos desta manhã por conta própria, para entender exatamente o que o snapshot protege.

No</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.122" lang="pt-br" no>, faça login na máquina virtual (pode levar alguns minutos até a VM iniciar):

```bash,wrap,run
while [[ "${IPA}" ==  "" ]]; do IPA=`kubectl --kubeconfig .rodeo/harvester-kubeconfig get vmi core-services -n prod -o jsonpath='{.status.interfaces[0].ipAddress}'|grep -v ':'`; sleep 5; echo -n '.'; done ; while [[ "$?" != "0" ]] ; do ssh -T -o StrictHostKeyChecking=accept-new sles@${IPA} 2>/dev/null ; sleep 5; done ; ssh -o StrictHostKeyChecking=accept-new sles@${IPA}

```

Gere o registro de transação altamente sensível no disco digitando exatamente isto:

```bash,wrap,run
echo "CLIENT: BRUCE WAYNE | AMOUNT: 100,000,000 | STATUS: CLEARED" > /home/sles/ledger.txt
```

**Agora capture a linha de base.** Mude para o</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.123" lang="pt-br" no>1. Navegue até <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>, depois localize a seguinte VM e clique no botão ao lado dela:</span>

<div class="cred">

```txt
core-services
```

</div>
<span id="assignment.124" lang="pt-br" no>2. Clique em <span id="assignment.124.1" lang="nolang" no>**Take Virtual Machine Snapshot**</span>
3. Nomeie como:</span>

<div class="cred">

```txt
pre-disaster-backup
```

</div>

<span id="assignment.125" lang="pt-br" no>4. Clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>

5. Navegue até <span id="assignment.125.1" lang="nolang" no>**Backup and Snapshots**</span>, depois clique em <span id="assignment.125.2" lang="nolang" no>**Virtual Machine Snapshots**</span> e aguarde até que a que acabamos de criar tenha o estado <span id="assignment.125.3" lang="nolang" no>**Ready**</span>: o ponto de rollback está definido

Retorne para o</span> [button label="Cluster Terminal" variant="success"](tab-1) <span id="assignment.126" lang="pt-br" no>e simule o erro terrível do administrador júnior:

```bash,run
rm -f /home/sles/ledger.txt
```

Cem milhões de dólares, sumidos do disco. Saia do console da VM:

```bash,run
exit
```


🧪 Tarefa 2: Clonar um ambiente de staging a partir do snapshot
================================================================


  


Em vez de restaurar a produção imediatamente, você vai construir um **clone** para verificar os dados primeiro; a recuperação não destrutiva é sempre recomendada.

No</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.127" lang="pt-br" no>1. Navegue até <span id="assignment.125.1" lang="nolang" no>**Backup and Snapshots**</span> e clique em <span id="assignment.125.2" lang="nolang" no>**Virtual Machine Snapshots**</span>

2. Clique no snapshot <span id="assignment.127.1" lang="nolang" no>**pre-disaster-backup**</span>:

3. Clique no  ao lado dele e selecione <span id="assignment.127.2" lang="nolang" no>**Restore New**</span>

4. Nomeie a nova máquina virtual:</span>


<div class="cred">

```txt
core-services-staging-verify
```

</div>


<span id="assignment.128" lang="pt-br" no>5. Clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>


> [!Note]
> Devido ao hardware usado neste laboratório, esse processo levará mais tempo do que em condições normais; por favor, continue para a próxima tarefa.



🏦 Tarefa 3: Conecte o cofre de backup fora do cluster
======================================================


  


Os snapshots nos salvaram hoje de manhã, mas os snapshots ficam no **mesmo cluster** que a carga de trabalho. Eles protegem contra dedos gordos, mas não contra danos físicos ou ataques cibernéticos. Para uma recuperação de desastres real, operamos um **cofre de backup** fora do cluster: um compartilhamento NFS em um sistema de armazenamento separado. Hora de conectá-lo.

No</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.129" lang="pt-br" no>Vá até <span id="assignment.129.1" lang="nolang" no>**Advanced > Settings**</span> e localize:</span>

<div class="cred">

```txt
backup-target
```

</div>
<span id="assignment.130" lang="pt-br" no>2. Clique no menu na sua linha e selecione <span id="assignment.130.1" lang="nolang" no>**Edit Setting**</span>, adicione o seguinte:

- <span id="assignment.110.2" lang="nolang" no>**Type**</span>: <span id="assignment.130.2" lang="nolang" no><b class="highlightcopy">NFS</b></span>
- <span id="assignment.130.3" lang="nolang" no>**Endpoint**</span>:</span>

<div class="cred">

```txt
192.168.122.1:/srv/backups/
```

</div>

<span id="assignment.131" lang="pt-br" no>3. Clique em <span id="assignment.114.7" lang="nolang" no>**Save**</span>

O cluster agora pode enviar backups completos de VMs para fora do cluster, o equivalente moderno da fita rodada à meia-noite, sem a meia-noite. Um bucket **S3** funciona igualmente bem como endpoint; em uma implantação de produção, isso apontaria para uma instalação fisicamente separada.


⏰ Tarefa 4: Agendar os backups
====================================</span>

<div id="602" class="story">
<span id="assignment.132" lang="pt-br" hist="vertrex-bank">Snapshots avulsos podem salvar o dia uma vez; a política mantém o banco seguro todos os dias depois.</span>
</div>

<span id="assignment.133" lang="pt-br" no>Coloque o próprio core-services sob uma programação automática de backup para que ninguém mais precise se lembrar de fazer isso manualmente.</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.134" lang="pt-br" no>1. Vá para <span id="assignment.134.1" lang="nolang" no>**Backup & Snapshot > Virtual Machine Schedules**</span> e clique em <span id="assignment.134.2" lang="nolang" no>**Create schedule**</span>
2. Defina os seguintes detalhes:

  - <span id="assignment.39.3" lang="nolang" no>**Namespace**</span>: <span id="assignment.55.2" lang="nolang" no><b class="highlightcopy">prod</b></span>
  - <span id="assignment.134.3" lang="nolang" no>**Virtual Machine Name**</span>: <span id="assignment.134.4" lang="nolang" no><b class="highlightcopy">core-services</b></span>
  - <span id="assignment.134.5" lang="nolang" no>**Basics**</span>:
    - <span id="assignment.134.6" lang="nolang" no>**Retain:**</span> 5
    - <span id="assignment.134.7" lang="nolang" no>**Max Failure:**</span> 2
    - <span id="assignment.134.8" lang="nolang" no>**Cron Schedule:**</span> (no minuto 00, a cada 5 horas)</span>

<div class="cred">

```txt
0 */5 * * *
```

</div>


<span id="assignment.135" lang="pt-br" no>4. Clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>

A partir de agora, a plataforma faz backup da VM no cofre NFS a cada cinco horas, mantém as cinco cópias mais recentes e pausa a programação se duas execuções consecutivas falharem. Configure uma vez, proteja para sempre.



🔍 Tarefa 5: Verificar os dados no sandbox de staging
=================================================


  


Agora que o core-services-staging-verify está em execução, vamos verificar se o arquivo está lá.

Desta vez usaremos o console gráfico, já que a VM não tem rede.

No</span> [button label="SUSE Virtualization UI" variant="success"](tab-0) <span id="assignment.136" lang="pt-br" no>1. Vá para <span id="assignment.40.2" lang="nolang" no>**Virtual Machines**</span>
2. Clique no menu suspenso <span id="assignment.61.1" lang="nolang" no>**Console**</span> e selecione <span id="assignment.136.1" lang="nolang" no>**Open in WebVNC**</span>, uma nova janela aparecerá com o terminal, fique à vontade para redimensioná-la.
3. Faça login usando as seguintes credenciais:
   - <span id="assignment.136.2" lang="nolang" no>**username**</span>: 'sles'
   - <span id="assignment.136.3" lang="nolang" no>**password**</span>: '1234'

4. Depois de entrar, execute o seguinte comando:</span>


<div class="cred">

```txt
cat /home/sles/ledger.txt
```

</div>

<span id="assignment.137" lang="pt-br" no>5. Deve retornar:

**CLIENTE: BRUCE WAYNE | VALOR: 100.000.000 | STATUS: LIBERADO**


O texto é exibido perfeitamente. <span id="assignment.137.1" lang="pt-br" hist="vertrex-bank">Os dados estão seguros.</span>


Agora vamos excluir o clone que não precisamos mais.

1. Feche a janela com o console.
2. Clique no  na linha **core-services-staging-verify** e selecione <span id="assignment.137.2" lang="nolang" no>**Delete**</span>, e novamente <span id="assignment.137.2" lang="nolang" no>**Delete**</span>.



♻️ Tarefa 6: Restaurar o sistema de produção
=========================================


  


Agora que você verificou a integridade do snapshot, prossiga para restaurar o sistema de produção:

1. Vá para **<span id="assignment.6.2" lang="nolang" no>Virtual Machines</span>**
2. Clique no  na linha **core-services** e selecione <span id="assignment.137.3" lang="nolang" no>**Stop**</span>, e novamente <span id="assignment.74.2" lang="nolang" no>**Apply**</span>.
3. Assim que estiver completamente parado, navegue até <span id="assignment.125.1" lang="nolang" no>**Backup and Snapshots**</span>, depois clique em <span id="assignment.125.2" lang="nolang" no>**Virtual Machine Snapshots**</span>

4. Clique no snapshot **pre-disaster-backup**:

5. Clique no  ao lado dele e selecione <span id="assignment.137.4" lang="nolang" no>**Replace Existing**</span>

6. Clique em <span id="assignment.19.3" lang="nolang" no>**Create**</span>

A VM ligará novamente sozinha, pois é isso que a estratégia de execução define.

Opcionalmente, conecte-se via SSH novamente e execute `cat` no arquivo uma última vez, depois faça logout da VM. <span id="assignment.137.5" lang="pt-br" hist="vertrex-bank">O registro voltou ao seu devido lugar.</span>


🏋️ Exercícios Bônus: veja o mecanismo por trás da rede de segurança (opcional)
======================================================================

- **Para os curiosos de linha de comando:** cada snapshot de VM é construído a partir de snapshots em nível de volume, e cada um deles é um objeto de API, assim como o seu novo agendamento de backup:

```bash,wrap,run
kubectl --kubeconfig .rodeo/harvester-kubeconfig get VirtualMachineBackup -A; kubectl --kubeconfig .rodeo/harvester-kubeconfig get volumesnapshots -A; kubectl --kubeconfig .rodeo/harvester-kubeconfig get schedulevmbackups -A
```

> [!NOTE]
> Certifique-se de fazer logout da VM antes de executar estes comandos.


💼 Por que isso importa?
==============================================

- **O erro humano deixa de ser catastrófico.** A recuperação passou de "esperar pelas fitas da meia-noite e torcer" para um rollback self-service de cinco minutos.
- **Verifique antes de sobrescrever.** Restaurar para um clone significa que você nunca aposta a produção em um backup não verificado, um padrão que fará tanto seus auditores quanto seus administradores juniores dormirem mais tranquilos.
- **A proteção agora é política, não heroísmo.** Um cofre de backup NFS fora do cluster e um agendamento de backup a cada cinco horas garantem que a rede de segurança funcione sozinha a partir de agora.

Clique em <span id="assignment.32.1" lang="nolang" no>**Check**</span> para continuar. 🤠

📚 Mais informações
===================</span>

- [Virtual Machine Backup and Restore](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/backup-restore.html)

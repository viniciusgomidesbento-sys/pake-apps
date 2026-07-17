# Rclone Web como aplicativo Windows com Pake

**Data:** 2026-07-17  
**Status:** desenho aprovado pelo usuário; aguardando revisão desta especificação  
**Plataforma-alvo:** Windows 11 x64

## Objetivo

Entregar a interface Web oficial do rclone como um aplicativo instalável do Windows, com entrada no Menu Iniciar, janela própria e sem terminal visível durante o uso normal.

O Pake fornecerá a janela nativa e o instalador. O executável oficial do rclone continuará responsável pelo servidor local da interface Web e pela comunicação com os remotes configurados.

## Resultado esperado

Depois da instalação e da configuração inicial:

1. O usuário entra no Windows.
2. O rclone Web GUI inicia oculto em segundo plano.
3. O usuário abre **Rclone Web** pelo Menu Iniciar.
4. Uma janela nativa do Pake carrega a interface local do rclone.
5. Não é necessário abrir navegador ou manter PowerShell/CMD visível.

## Escopo

### Incluído

- Instalar a versão estável oficial do rclone para Windows x64.
- Usar a Web GUI incorporada ao rclone atual.
- Manter endereços fixos somente em loopback:
  - interface Web: `127.0.0.1:5572`;
  - API local: `127.0.0.1:5573`.
- Criar um inicializador PowerShell não interativo para o servidor local.
- Criar inicialização automática por usuário no Agendador de Tarefas do Windows.
- Adicionar o app **Rclone Web** ao projeto existente `31_pake`.
- Gerar e instalar um pacote Windows x64 pelo Pake.
- Criar documentação operacional, validações e procedimento de remoção.

### Não incluído

- Expor a interface do rclone à rede local ou à internet.
- Desabilitar autenticação com `--no-auth`.
- Configurar automaticamente Google Drive, OneDrive ou outro provedor.
- Instalar WinFsp ou criar unidades montadas; isso pertence a uma etapa futura.
- Incorporar `rclone.exe` dentro do binário do Pake.
- Alterar ou apagar remotes e configurações rclone existentes.

## Arquitetura

```text
Menu Iniciar
    |
    v
Rclone Web (Pake/Tauri)
    |
    | HTTP somente em 127.0.0.1
    v
rclone Web GUI :5572
    |
    v
rclone RC API :5573
    |
    v
rclone.conf e remotes do usuário
```

O aplicativo Pake não iniciará processos por conta própria. O servidor rclone será iniciado no logon do usuário pelo Agendador de Tarefas. Essa separação preserva o uso do Pake CLI sem manter um fork personalizado do Tauri.

## Componentes

### 1. rclone oficial

- Instalação pelo identificador oficial `Rclone.Rclone` do winget.
- A versão efetivamente instalada será registrada no relatório de implementação.
- A configuração continuará no local padrão do perfil do usuário, confirmado por `rclone config paths`.
- A Web GUI será iniciada com `gui`, `--no-open-browser`, os dois endereços de loopback e arquivo de log.

### 2. Credencial local da Web GUI

- Será criada uma credencial exclusiva para a interface local.
- O usuário e a senha não serão gravados em Markdown, Git, argumentos do Agendador de Tarefas ou no arquivo `apps.json`.
- A credencial ficará em um arquivo `PSCredential` protegido pelo DPAPI do Windows e legível somente pelo mesmo usuário que o criou.
- O inicializador importará a credencial e fornecerá usuário e senha ao processo rclone por variáveis de ambiente do processo, evitando texto secreto no comando persistido da tarefa.
- No primeiro acesso, um auxiliar local mostrará o nome de usuário e copiará a senha diretamente para a área de transferência do Windows, sem imprimi-la no chat, terminal ou logs.
- O mesmo auxiliar permitirá recuperar a credencial depois, sempre descriptografando-a somente na sessão do usuário. Se a WebView mantiver o login após a validação inicial, o auxiliar não será necessário no uso diário.

### 3. Inicializador do servidor

Responsabilidades:

- localizar `rclone.exe` sem caminhos frágeis;
- verificar se `127.0.0.1:5572` já está atendendo antes de iniciar outra instância;
- carregar a credencial protegida;
- criar a pasta de logs se necessário;
- iniciar o rclone sem console visível;
- registrar apenas estado e erros, nunca credenciais;
- encerrar com código de erro claro se a porta estiver ocupada por outro programa.

### 4. Inicialização automática

- Tarefa por usuário, disparada no logon.
- Execução sem privilégios administrativos depois da instalação.
- Ação limitada ao inicializador do rclone Web GUI.
- A tarefa não armazenará senha nem incluirá opções que exponham o serviço fora de `127.0.0.1`.

### 5. Aplicativo Pake

Entrada nova em `config/apps.json` com estas propriedades funcionais:

- nome: `Rclone Web`;
- URL: `http://127.0.0.1:5572`;
- janela inicial: 1400 x 900;
- tamanho mínimo: 900 x 600;
- janela maximizada;
- decoração nativa do Windows preservada;
- pesquisa interna habilitada;
- arrastar e soltar habilitado;
- navegação limitada a `127.0.0.1` e `localhost`;
- idioma do instalador: `pt-BR`;
- versão inicial do app: `1.0.0`;
- ícone local do rclone preparado no formato aceito pelo Pake.

Nenhuma credencial será incorporada à URL ou ao pacote.

### 6. Estratégia de build

O caminho principal será o workflow Windows já validado do projeto `31_pake`, evitando instalar localmente vários gigabytes de compiladores Microsoft e toolchain Rust apenas para um pacote. Publicar o commit e executar o workflow dependerá de autorização explícita do usuário no momento da implementação.

Se o build remoto não puder ser autorizado ou estiver indisponível, o fallback será build local com Pake CLI, Rust MSVC e Microsoft C++ Build Tools, após confirmar espaço em disco e permissões administrativas.

## Fluxo de instalação

1. Verificar arquitetura, portas, winget e ausência de instalação conflitante.
2. Instalar rclone e validar `rclone version` e `rclone config paths`.
3. Criar a credencial local protegida.
4. Criar o inicializador e executar um teste manual oculto.
5. Confirmar que GUI e API escutam somente em loopback.
6. Registrar e testar a tarefa de logon.
7. Adicionar o app e o ícone ao projeto Pake.
8. Gerar o pacote Windows x64.
9. Instalar o pacote e validar o atalho do Menu Iniciar.
10. Reiniciar somente os componentes necessários e realizar o teste pós-logon; reinicialização completa do Windows só será solicitada se um instalador exigir.

## Tratamento de erros

- **Servidor indisponível:** verificar processo, tarefa, portas e log local; reiniciar somente o servidor rclone.
- **Porta ocupada:** não matar processos automaticamente; identificar o dono da porta e interromper a instalação para decisão do usuário.
- **Credencial ausente ou ilegível:** não iniciar com autenticação desabilitada; recriar a credencial mediante confirmação.
- **Falha do Pake ao carregar:** testar a URL no navegador apenas como diagnóstico e conferir WebView2.
- **Falha no build remoto:** preservar as alterações locais e usar o fallback somente após confirmação.
- **Falha na configuração de um remote:** preservar o aplicativo e tratar o remote separadamente; a instalação do app não depende de um provedor específico.

## Segurança

- Bind obrigatório em `127.0.0.1` para GUI e API.
- Autenticação obrigatória; `--no-auth` é proibido neste desenho.
- Nenhuma redução de verificação TLS.
- Nenhuma senha, token ou URL autenticada em Markdown, Git, logs ou mensagens do agente.
- Logs não usarão modo excessivamente verboso durante operação normal.
- O aplicativo Pake apontará somente para HTTP local; nenhum certificado será ignorado.
- O arquivo `rclone.conf` não será lido nem copiado para documentação.

## Validação

### Instalação

- `rclone version` retorna sucesso.
- `rclone gui --help` confirma as opções usadas.
- O pacote Pake é reconhecido como aplicativo Windows x64 instalável.

### Serviço local

- Apenas uma instância do servidor é iniciada.
- As portas 5572 e 5573 escutam exclusivamente em `127.0.0.1`.
- A GUI exige autenticação.
- Nenhuma janela de terminal permanece aberta.

### Aplicativo

- O atalho **Rclone Web** aparece no Menu Iniciar.
- A janela abre em dimensão utilizável e carrega a GUI.
- Dashboard, Explorer e Settings renderizam sem erros visíveis.
- Fechar e reabrir o aplicativo não cria outra instância do servidor.

### Persistência

- Após novo logon, o servidor volta a iniciar oculto.
- O aplicativo volta a carregar sem intervenção no terminal.
- A configuração do rclone permanece no perfil correto do usuário.

## Remoção e recuperação

- Desinstalar o pacote Pake pelo Windows não apagará `rclone.conf` nem dados remotos.
- A remoção completa exigirá, separadamente, desregistrar a tarefa, remover os scripts e credencial locais e desinstalar `Rclone.Rclone`.
- Nenhum procedimento de remoção apagará a configuração do rclone sem autorização explícita.
- Antes de alterar artefatos persistentes existentes, será criado backup recuperável quando aplicável.

## Critério de aceite

O trabalho será considerado concluído quando o usuário puder abrir **Rclone Web** pelo Menu Iniciar após entrar no Windows, visualizar a Web GUI autenticada em uma janela nativa, utilizar os recursos locais do rclone e fechar o aplicativo sem precisar administrar manualmente um terminal.

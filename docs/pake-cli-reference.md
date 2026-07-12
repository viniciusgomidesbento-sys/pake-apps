# Pake — Referência Completa

> Fontes:
> - https://github.com/viniciusgomidesbento-sys/Pake/tree/main/docs (11 docs)
> - CLI: docs/cli-usage.md | Advanced: docs/advanced-usage.md
> - FAQ: docs/faq.md | GitHub Actions: docs/github-actions-usage.md
> - Pake Action: docs/pake-action.md
> - Atualizado em: 2026-07-12

---

## O que é o Pake?

Empacota **qualquer site como aplicativo desktop** usando Tauri (Rust + WebView nativo do sistema). Gera instaladores nativos para Windows (.msi/.exe), macOS (.dmg/.app) e Linux (.deb/.AppImage/.rpm).

Vantagem sobre Electron: mais leve e rápido, pois usa o WebView do sistema em vez de empacotar um Chromium inteiro.

---

## Índice

1. [Pré-requisitos](#pré-requisitos)
2. [Instalação](#instalação)
3. [Uso Básico](#uso-básico)
4. [Flags por Categoria](#flags-por-categoria)
5. [Targets](#targets)
6. [Personalização Avançada](#personalização-avançada)
7. [Injeção de JavaScript](#injeção-de-javascript)
8. [Comunicação Container (Web ↔ Rust)](#comunicação-container-web--rust)
9. [Notificações de Erro de Download](#notificações-de-erro-de-download)
10. [Configuração de Janela (pake.json)](#configuração-de-janela-pakejson)
11. [Empacotamento de Arquivos Estáticos](#empacotamento-de-arquivos-estáticos)
12. [Múltiplos Apps para o Mesmo Site](#múltiplos-apps-para-o-mesmo-site)
13. [Permissões de Mídia (macOS)](#permissões-de-mídia-macos)
14. [GitHub Actions (Build Online)](#github-actions-build-online)
15. [Pake Action (GitHub Action para CI/CD)](#pake-action-github-action-para-cicd)
16. [FAQ — Troubleshooting](#faq--troubleshooting)
17. [Estrutura do Projeto](#estrutura-do-projeto)
18. [Workflow de Desenvolvimento](#workflow-de-desenvolvimento)
19. [Testes](#testes)
20. [Docker](#docker)
21. [Comportamento por SO](#comportamento-por-so)
22. [Exemplos Práticos](#exemplos-práticos)
23. [Observações Importantes](#observações-importantes)

---

## Pré-requisitos

| Requisito | Versão |
|-----------|--------|
| Node.js | ≥ 18.0.0 (recomendado ≥ 22.0 LTS) |
| Rust | ≥ 1.85.0 (instalado automaticamente se faltar, ou manual) |
| SO | macOS/Linux: curl, wget, file, tar |

### Platform-Specific

**macOS:**
- Xcode Command Line Tools: `xcode-select --install`

**Windows:**
- **CRÍTICO**: Consultar [Tauri prerequisites](https://v2.tauri.app/start/prerequisites/) antes de prosseguir
- Windows 10 SDK (10.0.19041.0) e Visual Studio Build Tools 2022 (≥17.2)
- Redistribuíveis necessários:
  1. Microsoft Visual C++ 2015-2022 Redistributable (x64)
  2. Microsoft Visual C++ 2015-2022 Redistributable (x86)
  3. Microsoft Visual C++ 2012 Redistributable (x86) (opcional)
  4. Microsoft Visual C++ 2013 Redistributable (x86) (opcional)
  5. Microsoft Visual C++ 2008 Redistributable (x86) (opcional)
- **Windows ARM (ARM64)**: Instalar "MSVC v143 - VS 2022 C++ ARM64 build tools" no Visual Studio Installer → "Individual Components"

**Linux (Ubuntu/Debian):**
```bash
sudo apt install libdbus-1-dev \
    libsoup-3.0-dev \
    libjavascriptcoregtk-4.1-dev \
    libwebkit2gtk-4.1-dev \
    build-essential \
    curl \
    wget \
    file \
    libxdo-dev \
    libssl-dev \
    libgtk-3-dev \
    libayatana-appindicator3-dev \
    librsvg2-dev \
    gnome-video-effects \
    gnome-video-effects-extra \
    libglib2.0-dev \
    pkg-config
```

---

## Instalação

```powershell
# Recomendado (pnpm)
pnpm install -g pake-cli

# Alternativa (npm)
npm install -g pake-cli

# Sem instalação global
npx pake-cli [url] [options]
```

**Problemas de permissão no Linux/macOS:**
```bash
npm config set prefix ~/.npm-global
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

---

## Uso Básico

```powershell
# Mínimo — empacota site com nome
pake https://github.com --name "GitHub"

# Completo (tamanho, ícone, esconder barra)
pake https://weekly.tw93.fun --name "Weekly" --icon ./icon.icns --width 1200 --height 800 --hide-title-bar
```

O instalador gerado fica no **diretório atual de trabalho**.
O **primeiro build é mais lento** — precisa configurar ambiente Rust. Se falhar, instalar Rust manualmente.

> **macOS Output**: Por padrão gera `.dmg`. Para `.app` (sem interação do usuário): `PAKE_CREATE_APP=1`.
> `--install` faz build do .app, copia para /Applications e remove o bundle local.

---

## Flags por Categoria

### 🪟 Janela

| Flag | Descrição | Default |
|------|-----------|---------|
| `--width <n>` | Largura da janela | 1200 |
| `--height <n>` | Altura da janela | 780 |
| `--min-width <n>` | Largura mínima (redimensionamento) | — |
| `--min-height <n>` | Altura mínima (redimensionamento) | — |
| `--zoom <50-200>` | Zoom inicial da página (%) | 100 |
| `--fullscreen` | Inicia em tela cheia | false |
| `--maximize` | Inicia maximizado | false |
| `--always-on-top` | Janela sempre no topo | false |
| `--hide-title-bar` | Barra imersiva (macOS apenas) | false |
| `--hide-window-decorations` | Remove decorações da janela (Win/Linux) | false |
| `--title <string>` | Texto da barra de título | — (macOS: vazio; Win/Linux: fallback pro nome) |

### 🔧 Comportamento

| Flag | Descrição | Default |
|------|-----------|---------|
| `--show-system-tray` | Mostra na bandeja do sistema | false |
| `--system-tray-icon <path>` | Ícone da bandeja (.ico/.png, 32-256px) | — |
| `--start-to-tray` | Inicia minimizado na bandeja (requer `--show-system-tray`) | false |
| `--hide-on-close <bool>` | Oculta em vez de fechar ao clicar no X | true (macOS) / false (Win/Linux) |
| `--multi-instance` | Permite múltiplas instâncias simultâneas (processos separados) | false |
| `--multi-window` | Múltiplas janelas numa mesma instância (1 processo) | false |
| `--incognito` | Modo anônimo (sem cookies/histórico) | false |
| `--activation-shortcut <string>` | Atalho de teclado para trazer à frente (ex: `CmdOrControl+Shift+P`) | — |
| `--new-window` | Permite popups/auth abrirem nova janela no app | false |

### 🌐 Navegação & Rede

| Flag | Descrição | Default |
|------|-----------|---------|
| `--force-internal-navigation` | Toda URL abre dentro do app (nunca no navegador) | false |
| `--internal-url-regex <pattern>` | Regex p/ definir quais URLs são internas | — |
| `--safe-domain <domains>` | Domínios confiáveis (vírgula) que ficam dentro do app | — |
| `--user-agent <string>` | Customiza o User-Agent do navegador | — |
| `--proxy-url <url>` | Proxy p/ todas requisições (http/https/socks5) | — |
| `--ignore-certificate-errors` | Ignora erros de TLS (intranet/certificados próprios) | false |
| `--enable-drag-drop` | Habilita drag & drop nativo | false |

### 🎨 Aparência & Tema

| Flag | Descrição | Default |
|------|-----------|---------|
| `--dark-mode` | Força modo escuro (macOS, Windows, Linux) | false |
| `--icon <path>` | Ícone personalizado (local/remoto; .icns/.ico/.png) | Auto-fetch do site |

### 🔒 Privacidade & Segurança

| Flag | Descrição | Default |
|------|-----------|---------|
| `--incognito` | Modo anônimo | false |
| `--ignore-certificate-errors` | Ignora TLS inválido | false |
| `--wasm` | Suporte WebAssembly + headers COOP/COEP (SharedArrayBuffer) | false |

### 📷 Hardware (macOS)

| Flag | Descrição | Default |
|------|-----------|---------|
| `--camera` | Permissão de câmera (`com.apple.security.device.camera`) | false |
| `--microphone` | Permissão de microfone (`com.apple.security.device.audio-input`) | false |

### 📦 Build & Empacotamento

| Flag | Descrição | Default |
|------|-----------|---------|
| `--targets <alvo>` | Arquitetura/formato do build (ver tabela abaixo) | Auto-detect |
| `--multi-arch` | Suporte Intel + Apple Silicon (macOS) | false |
| `--no-bundle` | Só o binário compilado, sem instalador (Linux) | false |
| `--keep-binary` | Mantém executável standalone junto com instalador | false |
| `--iterative-build` | Modo rápido (app only, sem dmg/deb/msi) | false |
| `--install` | Instala .app direto no /Applications (macOS, substitui se existir) | false |
| `--app-version <string>` | Versão do app (formato package.json) | 1.0.0 |
| `--use-local-file` | Copia recursivamente pasta de arquivo HTML local | false |
| `--identifier <string>` | Bundle identifier explícito (ex: `com.example.app`) | — |

### 🛠️ Desenvolvimento & Debug

| Flag | Descrição | Default |
|------|-----------|---------|
| `--debug` | Ferramentas de desenvolvimento + logging detalhado | false |
| `--enable-find` | Busca interna (Cmd/Ctrl+F, Cmd/Ctrl+G) | false |
| `--disabled-web-shortcuts` | Desabilita atalhos web no container | false |
| `--inject <css/js>` | Injeta arquivos CSS/JS locais na página | — |
| `--iterative-build` | Build rápido (só app, sem instalador) | false |

### 🌍 Região

| Flag | Descrição | Default |
|------|-----------|---------|
| `--installer-language <lang>` | Idioma do instalador Windows (zh-CN, ja-JP, etc.) | en-US |

### 📋 Informação

| Flag | Descrição |
|------|-----------|
| `--help` | Mostra todas as opções |
| `--version` | Mostra a versão do CLI |

---

## Targets (--targets)

### Windows
| Target | Descrição |
|--------|-----------|
| `x64` | 64 bits (auto-detect) |
| `arm64` | ARM64 |

### macOS
| Target | Descrição |
|--------|-----------|
| `intel` | Intel |
| `apple` | Apple Silicon |
| `universal` | Universal (Intel + Apple Silicon) |
| `app` | Só .app (pula DMG) |
| `dmg` | DMG installer (default) |

### Linux
| Target | Descrição |
|--------|-----------|
| `deb` | Debian/Ubuntu x64 |
| `appimage` | AppImage x64 |
| `rpm` | Fedora/RHEL x64 |
| `zst` | Arch Linux x64 (.pkg.tar.zst) |
| `deb-arm64` | ARM64 Debian |
| `appimage-arm64` | ARM64 AppImage |
| `rpm-arm64` | ARM64 RPM |
| `zst-arm64` | ARM64 Arch |

**Notas Linux:**
- Default: Debian/Ubuntu → `deb, appimage`; Fedora/RHEL → `rpm, appimage`
- ARM64 cross-compile precisa de `gcc-aarch64-linux-gnu`
- `zst` requer `binutils` (ar) e `libarchive` (bsdtar)
- Roda em Linux phones (postmarketOS, Ubuntu Touch), Raspberry Pi e outros ARM64

---

## Personalização Avançada

### Estilo (CSS)

Remove anúncios ou customiza aparência editando CSS:

1. Execute `pnpm run dev` (dev mode)
2. Use DevTools para identificar elementos
3. Edite `src-tauri/src/inject/style.js`:

```javascript
const css = `
  .ads-banner { display: none !important; }
  .header { background: #1a1a1a !important; }
`;
```

### Injeção via CLI

Usando a flag `--inject` para injetar CSS/JS sem modificar o código fonte:

```bash
# Vírgula (recomendado)
--inject ./tools/style.css,./tools/hotkey.js

# Múltiplos --inject
--inject ./tools/style.css --inject ./tools/hotkey.js

# Arquivo único
--inject ./tools/style.css
```

---

## Injeção de JavaScript

Adicione funcionalidades como atalhos de teclado editando `src-tauri/src/inject/event.js`:

```javascript
document.addEventListener("keydown", (e) => {
  if (e.ctrlKey && e.key === "k") {
    // Ação personalizada
  }
});
```

---

## Comunicação Container (Web ↔ Rust)

Envie mensagens entre o conteúdo web e o container Pake via Tauri commands.

**Lado Web (JavaScript):**
```javascript
window.__TAURI__.core.invoke("handle_scroll", {
  scrollY: window.scrollY,
  scrollX: window.scrollX,
});
```

**Lado Container (Rust):**
```rust
#[tauri::command]
fn handle_scroll(scroll_y: f64, scroll_x: f64) {
  println!("Scroll: {}, {}", scroll_x, scroll_y);
}
```

---

## Notificações de Erro de Download

O Pake fornece notificações nativas de erro de download automaticamente.

**Features:**
- **Suporte bilíngue**: detecta idioma do navegador (Chinês/Inglês)
- **Notificações nativas do SO**: quando a permissão é concedida
- **Fallback**: vai para console.log se notificação estiver indisponível
- **Cobertura**: HTTP, Data URI, Blob, downloads do menu de contexto

**Exemplo de notificação:**
- Inglês: "Download Error - Download failed: filename.pdf"
- Chinês: "下载错误 - 下载失败: filename.pdf"

**Para solicitar permissão de notificação (JS injetado):**
```javascript
if (window.Notification && Notification.permission === "default") {
  Notification.requestPermission();
}
```

---

## Configuração de Janela (pake.json)

Configure propriedades da janela em `src-tauri/pake.json`:

```json
{
  "windows": [
    {
      "width": 1200,
      "height": 780,
      "fullscreen": false,
      "resizable": true,
      "hide_title_bar": true
    }
  ]
}
```

> `hide_title_bar` é a chave do `pake.json` (o CLI expõe como `--hide-title-bar`). Só funciona no macOS.
> Para Windows/Linux frameless, use `hide_window_decorations` (`--hide-window-decorations`).

---

## Empacotamento de Arquivos Estáticos

Package HTML/CSS/JS local como app desktop. Requer Pake CLI ≥ 3.0.0.

```bash
pake ./my-app/index.html --name my-static-app --use-local-file
```

A flag `--use-local-file` copia recursivamente a pasta que contém o HTML e todos os sub-arquivos para a pasta static do Pake.

---

## Múltiplos Apps para o Mesmo Site

Para contas separadas (ex: dois Gmail com login diferente), use nomes diferentes:

```bash
pake https://gmail.com --name "Gmail Work"
pake https://gmail.com --name "Gmail Personal"
```

O Pake gera um **identificador diferente para cada par URL + nome**, permitindo instalação como apps separados.

Para casos avançados, `--identifier` fixa o bundle identifier explicitamente:

```bash
pake https://gmail.com --name "Gmail Work" --identifier com.example.gmail.work
```

> `--multi-instance` é diferente: só permite múltiplos processos do **mesmo** app, não cria identidades separadas.

---

## Permissões de Mídia (macOS)

Por padrão, apps empacotados com Pake **não** solicitam câmera ou microfone. Adicione as flags no build:

```bash
# Só microfone (ex: ChatGPT)
pake https://chatgpt.com --name ChatGPT --microphone

# Câmera + microfone (ex: Google Meet)
pake https://meet.google.com --name GoogleMeet --camera --microphone
```

- `--microphone`: `com.apple.security.device.audio-input`
- `--camera`: `com.apple.security.device.camera`

macOS pergunta permissão ao usuário no primeiro uso. Só adicione para sites que realmente precisam.

---

## GitHub Actions (Build Online)

Build apps Pake diretamente no GitHub, sem precisar instalar ferramentas localmente.

### Passos Rápidos

1. **Fork** o repositório [tw93/Pake](https://github.com/tw93/Pake)
2. Vá até a aba **Actions** no seu fork
3. Selecione **"Build App With Pake CLI"**
4. Preencha o formulário (mesmos parâmetros do [CLI Usage](/cli-usage))
5. Clique em **"Run Workflow"**
6. Quando o build terminar (✔ verde), vá em **Artifacts** e baixe o app

### Tempos de Build

| Execução | Tempo | Observação |
|----------|-------|------------|
| Primeira | ~10-15 min | Configura cache |
| Seguinte | ~5 min | Usa cache (~400-600 MB) |

### Dicas

- Tenha paciência na primeira execução — deixe o cache ser construído completamente
- Use conexão de rede estável
- Se falhar, apague o cache e tente novamente

---

## Pake Action (GitHub Action para CI/CD)

Use o Pake como **GitHub Action** em seus próprios workflows. Para o workflow embutido do projeto, veja a seção [GitHub Actions](#github-actions-build-online).

### Quick Start

```yaml
- name: Build Pake App
  uses: tw93/Pake@v3
  with:
    url: "https://example.com"
    name: "MyApp"
```

### Inputs

| Parâmetro | Descrição | Obrigatório | Default |
|-----------|-----------|:-----------:|---------|
| `url` | URL alvo para empacotar | ✅ | — |
| `name` | Nome do aplicativo | ✅ | — |
| `output-dir` | Diretório de saída | — | `dist` |
| `icon` | URL/caminho do ícone | — | — |
| `width` | Largura da janela | — | `1200` |
| `height` | Altura da janela | — | `780` |
| `debug` | Modo debug | — | `false` |

### Outputs

| Output | Descrição |
|--------|-----------|
| `package-path` | Caminho para o pacote gerado |

### Exemplos

**Básico:**
```yaml
name: Build Web App
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: tw93/Pake@v3
        with:
          url: "https://weekly.tw93.fun"
          name: "WeeklyApp"
```

**Com ícone customizado:**
```yaml
- uses: tw93/Pake@v3
  with:
    url: "https://example.com"
    name: "MyApp"
    icon: "https://example.com/icon.png"
    width: 1400
    height: 900
```

**Multi-plataforma (matrix):**
```yaml
jobs:
  build:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - uses: tw93/Pake@v3
        with:
          url: "https://example.com"
          name: "CrossPlatformApp"
```

### Como Funciona

1. **Auto Setup**: Instala Rust, dependências Node.js e compila o Pake CLI
2. **Build App**: Executa `pake` com os parâmetros fornecidos
3. **Package Output**: Localiza e move o pacote para o diretório de saída

### Plataformas Suportadas

- **Linux**: `.deb` em runners Ubuntu
- **macOS**: `.app` e `.dmg` em runners macOS
- **Windows**: `.exe` e `.msi` em runners Windows

---

## FAQ — Troubleshooting

### Build Issues

#### Rust: "feature 'edition2024' is required"

**Problema:** Erro de manifesto sobre `edition2024` com sugestão de usar nightly.

**Causa:** A cadeia de dependências (`tauri → image → moxcms → pxfm`) requer edition2024, estável desde Rust 1.85.0 (fev/2025). Versões antigas (ex: 1.82.0) disparam o erro.

**Solução:**
```bash
rustup update stable
rustup install stable
rustc --version  # deve mostrar 1.85.0+
```

#### Linux: "Can't detect any appindicator library" (Ubuntu 24.04+)

**Causa:** Ubuntu 24.04+ substituiu `libappindicator3-dev` por `libayatana-appindicator3-dev`.

**Solução:**
```bash
sudo apt-get update
sudo apt-get install -y libayatana-appindicator3-dev
```

#### Linux: AppImage Build "failed to run linuxdeploy"

Dois cenários distintos compartilham esse erro:

| Erro | Causa | Solução |
|------|-------|---------|
| `strip: Unable to recognise format` | Incompatibilidade de strip | `NO_STRIP=1 pake ...` |
| `Failed to run plugin: gtk` / `gdk-pixbuf` stat error | Plugin GTK sem gdk-pixbuf loaders | Instalar deps e rodar `gdk-pixbuf-query-loaders --update-cache` |

**Solução 1 — NO_STRIP (recomendado):**
```bash
NO_STRIP=1 pake https://example.com --name MyApp --targets appimage
```
O CLI já tenta automaticamente com `NO_STRIP=1` em caso de falha de strip.

**Solução 2 — Instalar dependências de sistema:**
```bash
sudo apt install librsvg2-common gdk-pixbuf2.0-bin
gdk-pixbuf-query-loaders --update-cache
```

**Solução 3 — Usar DEB:**
```bash
pake https://example.com --name MyApp --targets deb
```

**Solução 4 — Docker:**
```bash
docker run --rm --privileged \
  --device /dev/fuse --security-opt apparmor=unconfined \
  -v $(pwd)/output:/output \
  ghcr.io/tw93/pake:latest \
  https://example.com --name MyApp --targets appimage
```

#### Linux: AppImage trava no launch "WebKitNetworkProcess not found"

**Causa:** Limitação do upstream Tauri. O bundler reescreve caminhos absolutos do WebKit baseado no layout do Debian, que usa `/usr/lib/<arch-triple>/webkit2gtk-4.1`. No Arch, os helpers estão em `/usr/lib/webkit2gtk-4.1` (sem arch triple), então o path reescrito não existe dentro do bundle.

**Solução 1 (Arch):** Use o pacote nativo:
```bash
pake https://example.com --name MyApp --targets zst
sudo pacman -U MyApp-*.pkg.tar.zst
```

**Solução 2:** Build em Docker (Debian) — mesmo comando da Solução 4 acima.

**Workaround para AppImage já existente:**
```bash
./MyApp.AppImage --appimage-extract
cd squashfs-root
mkdir -p lib && ln -s ../usr/lib/webkit2gtk-4.1 lib/webkit2gtk-4.1
./AppRun
```

#### Linux: AppImage abre mas botões/teclado não funcionam (Wayland)

**Solução:** O Pake detecta automaticamente sessões niri. Para forçar:
```bash
# Forçar caminho nativo WebKit
PAKE_LINUX_WEBKIT_SAFE_MODE=0 ./MyApp.AppImage

# Se ficar tela branca, reativar workaround:
PAKE_LINUX_WEBKIT_SAFE_MODE=1 ./MyApp.AppImage
```

#### Linux: "cargo: command not found" após instalar Rust

```bash
source ~/.cargo/env
# ou reiniciar o terminal
```
(Pake CLI recarrega automaticamente, mas se persistir, use o comando acima.)

#### Windows: Timeout na primeira instalação (900000ms)

**Causa:** Primeira instalação no Windows é lenta (compilação de módulos nativos, VS Build Tools, download de deps, Windows Defender).

**Solução 1 — Mirror CN (se na China):**
```powershell
$env:PAKE_USE_CN_MIRROR='1'; pake https://github.com --name GitHub
```

**Solução 2 — Instalação manual:**
```powershell
# No diretório de instalação do pake-cli
pnpm install --registry=https://registry.npmmirror.com
```

**Solução 3:** Use conexão estável, desative antivírus temporariamente, ou use VPN.

**Tempo esperado:** 10-15 min no Windows. Builds seguintes são muito mais rápidos (cache).

#### Windows: Missing Visual Studio Build Tools

Baixe em [visualstudio.microsoft.com](https://visualstudio.microsoft.com/). Selecione "Desktop development with C++". Para ARM64, adicione "MSVC v143 - VS 2022 C++ ARM64 build tools" em Individual Components.

#### macOS: erro de compilação CoreFoundation / _Builtin_float (macOS 26 Beta+)

Crie arquivo de config para usar SDK compatível:
```bash
cat > src-tauri/.cargo/config.toml << 'EOF'
[env]
MACOSX_DEPLOYMENT_TARGET = "15.0"
SDKROOT = "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
EOF
```
(Este arquivo está no `.gitignore`.)

### Runtime Issues

#### Janela muito pequena/grande

Use `--width` e `--height`:
```bash
pake https://example.com --width 1200 --height 800
```

#### Ícone não aparece corretamente

Use o formato correto por plataforma: `.icns` (macOS), `.ico` (Windows), `.png` (Linux).
```bash
# macOS
pake https://example.com --icon ./icon.icns
```
(Pake converte automaticamente, mas fornecer o formato certo é mais confiável.)

#### Funcionalidades do site não funcionam (login, upload, etc.)

1. **Custom User Agent:**
   ```bash
   pake https://example.com --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
   ```
2. **Injetar JavaScript:**
   ```bash
   pake https://example.com --inject ./fix.js
   ```
3. **Refresh periódico** (ex: HackerNews a cada 300s):
   ```javascript
   // refresh.js
   setInterval(() => {
     if (!document.hidden && document.activeElement?.tagName !== 'INPUT' &&
         document.activeElement?.tagName !== 'TEXTAREA' && document.activeElement?.tagName !== 'SELECT') {
       location.reload();
     }
   }, 300000);
   ```
   ```bash
   pake https://news.ycombinator.com --name HackerNews --inject ./refresh.js
   ```
4. **WeChat Web:** Detecta WebView e armazena cookie bloqueador. Use `--incognito`:
   ```bash
   pake https://wx.qq.com --name WeChat --incognito
   ```
5. **Cloudflare/ChatGPT loop infinito:** O WebView do sistema (especialmente WebKitGTK no Linux) é frequentemente flagado. Não há workaround confiável no Pake — use um navegador comum.
6. **Google OAuth:** Pode falhar dentro de webviews embutidos por política do provedor, não por bug do Pake.
7. **"Sign in with Apple":** No macOS, Pake mantém esses popups no caminho nativo para o callback da Apple funcionar.

#### App usa mais memória que o esperado

**Esclarecimento:** O valor de "~5 MB" é o **tamanho do instalador em disco**, não o consumo de RAM. Em runtime, o Pake renderiza através do WebView do sistema — e o processo WebKitWebProcess (Linux) ou WebContent (macOS) usa memória compatível com o engine e a página carregada. "Uma SPA pesada como Gemini, Slack ou ChatGPT usa quantidade similar abrindo no GNOME Web ou qualquer browser WebKitGTK." O Pake adiciona muito pouco sobre o WebView, então nenhuma flag do Pake reduz isso.

### Installation Issues

#### Permissão negada na instalação global

```bash
# Opção 1: npx (sem instalação)
npx pake-cli https://example.com

# Opção 2: corrigir permissões npm
npm config set prefix ~/.npm-global
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
npm install -g pake-cli

# Opção 3: pnpm (recomendado)
pnpm install -g pake-cli
```

### Getting Help

Se seu problema não estiver aqui:
1. Veja o [CLI Usage Guide](#uso-básico)
2. Veja [Advanced Usage](#personalização-avançada)
3. Busque issues existentes em [tw93/Pake](https://github.com/tw93/Pake)
4. Abra uma nova issue com: OS + versão, `node --version`, `rustc --version`, mensagem de erro completa e o comando de build usado

---

```
├── bin/                    # CLI source code (TypeScript)
│   ├── builders/          # Platform-specific builders
│   ├── helpers/           # Utility functions
│   └── options/           # CLI option processing
├── docs/                  # Project documentation
├── src-tauri/             # Tauri application core
│   ├── src/
│   │   ├── app/           # Core modules (window, tray, shortcuts)
│   │   ├── inject/        # Page injection logic (style.js, event.js)
│   │   └── lib.rs         # Application entry point
│   ├── icons/             # macOS icons (.icns)
│   ├── png/               # Windows/Linux icons (.ico, .png)
│   ├── pake.json          # App configuration
│   └── tauri.*.conf.json  # Platform-specific configs
├── scripts/               # Build and utility scripts
└── tests/                 # Test suites
```

### Componentes-chave

- **CLI Tool** (`bin/`): Interface de comando TypeScript para empacotamento
- **Tauri App** (`src-tauri/`): Framework desktop em Rust
- **Injection System** (`src-tauri/src/inject/`): CSS/JS customizados injetados na página web
- **Configuration**: Configurações multi-plataforma do app

---

## Workflow de Desenvolvimento

### Setup

```bash
# Clonar e instalar
git clone https://github.com/tw93/Pake.git
cd Pake
pnpm install

# Iniciar desenvolvimento
pnpm run dev
```

### Comandos

| Comando | Descrição |
|---------|-----------|
| `pnpm run dev` | Dev mode (hot reload) |
| `pnpm run build` | Build de produção |
| `pnpm run build:debug` | Build de debug |
| `pnpm run cli:build` | Compila o CLI (TypeScript) |
| `pnpm run cli:dev` | CLI dev com hot reload (watch mode) |
| `pnpm test` | Suíte completa de testes |

### Fluxo de Edição

1. **Mudanças no CLI**: editar `bin/`, depois `pnpm run cli:build`
2. **Mudanças no Core App**: editar `src-tauri/src/`, depois `pnpm run dev`
3. **Injeção**: modificar `src-tauri/src/inject/` para customizações web
4. **Testes**: `pnpm test` para validação completa

### Problemas Comuns

- **Erro de compilação Rust**: `cargo clean` em `src-tauri/`
- **Problema de dependência Node**: deletar `node_modules` e `pnpm install`
- **Permissão macOS**: `sudo xcode-select --reset`

---

## Testes

### Comandos

```bash
# Suíte completa (recomendado): build CLI + Vitest + smoke tests
pnpm test

# Pular build real e smoke tests
pnpm test -- --no-build

# Só Vitest (rápido)
npx vitest run

# Só smoke test de release
node ./tests/release.js
```

### Flags opcionais

| Flag | Descrição |
|------|-----------|
| `--no-unit` | Pular unit tests |
| `--no-integration` | Pular integration tests |
| `--no-builder` | Pular builder tests |
| `--no-build` | Pular build real + smoke tests |
| `--e2e` | Adicionar testes de configuração E2E |
| `--pake-cli` | Adicionar checagens relacionadas a GitHub Actions |

### O que o test completo inclui

- ✅ **Vitest suite**: unit, integration, builder, CLI options
- ✅ **Real build smoke test**: validação de empacotamento multi-plataforma
- ✅ **Release workflow smoke test**: verifica o caminho de build de release usado para apps populares

### Troubleshooting

- **CLI file not found**: executar `pnpm run cli:build`
- **Test timeout**: builds precisam de mais tempo
- **Build failures**: `rustup update`
- **Permission errors**: garantir permissões de escrita

---

## Docker

```powershell
# Build AppImage precisa de FUSE e --privileged
docker run --rm --privileged `
    --device /dev/fuse `
    --security-opt apparmor=unconfined `
    -v ./packages:/output `
    ghcr.io/tw93/pake `
    https://example.com --name myapp --targets appimage
```

---

## Comportamento por SO

- **macOS**: gera `.dmg` por padrão. `--install` copia `.app` pro `/Applications` e substitui se existir. `--hide-title-bar` funciona. `--hide-window-decorations` é ignorado. Sem `--title` a barra não mostra texto.
- **Windows/Linux**: `--hide-window-decorations` funciona (remove barra de título, adiciona região de arrasto). F11 para tela cheia nativa. `--proxy-url` funciona (macOS precisa de 14+).
- **Linux**: `--no-bundle` copia binário como `<name>-binary`. Cross-compile ARM64 precisa de `gcc-aarch64-linux-gnu`. Modo escuro depende do tema WebKitGTK.
- **Naming**: macOS/Windows preservam espaços e maiúsculas ("Google Translate"). Linux converte para minúsculas com hífens ("google-translate").
- **Proxy**: `--proxy-url` disponível no Windows/Linux; macOS requer 14+.

---

## Exemplos Práticos

```powershell
# App simples com ícone automático
pake https://github.com --name GitHub

# App com tamanho customizado e ícone local
pake https://chatgpt.com --name ChatGPT --width 1400 --height 900 --icon ./chatgpt.ico --show-system-tray

# App modo escuro, anônimo e debug
pake https://app.example.com --name App --dark-mode --incognito --debug

# App com domínios seguros (SSO + workspace)
pake https://slack.com --name Slack --safe-domain slack.com,okta.com

# App com WASM (Flutter Web)
pake https://flutter.dev --name FlutterApp --wasm

# macOS: camera + microfone para conferência
pake https://meet.google.com --name Meet --camera --microphone

# App que permite múltiplas janelas
pake https://chat.example.com --name Chat --multi-window

# Build rápido pra testar
pake https://example.com --name Teste --iterative-build

# Apps separados para contas diferentes
pake https://gmail.com --name "Gmail Work"
pake https://gmail.com --name "Gmail Personal"

# App com injeção de CSS/JS e bandeja
pake https://example.com --name App --inject ./custom.css,./custom.js --show-system-tray

# App de arquivo HTML local
pake ./app/index.html --name "Local App" --use-local-file

# Windows com instalador em português
pake https://example.com --name App --installer-language pt-BR
```

---

## Observações Importantes

1. **Primeiro build é mais lento** — precisa configurar ambiente Rust.
2. **macOS**: sem `--title` a barra de título não mostra texto.
3. **macOS DMG vs APP**: `PAKE_CREATE_APP=1` gera .app direto. `--install` copia pro /Applications.
4. `--start-to-tray` exige `--show-system-tray`. Duplo clique no ícone da bandeja mostra/esconde a janela.
5. `--inject` aceita CSS e JS separados por **vírgula** ou múltiplos `--inject`.
6. `--safe-domain` e `--internal-url-regex` são mutuamente exclusivos: se ambos usados, a regex vence.
7. **Google/Gmail bloqueia login em webviews embutidas** — `--new-window` e `--multi-window` não contornam isso.
8. Para debug de permissão: usar `--iterative-build` até acertar flags, depois build final.
9. `--hide-on-close` default: **true** no macOS, **false** no Windows/Linux.
10. `--multi-instance` = processos separados; `--multi-window` = 1 processo, N janelas.
11. `--user-agent` vazio = WebView padrão do SO.
12. **Linux ARM64 cross-compile**: instalar `gcc-aarch64-linux-gnu` e configurar env vars.
13. **Notificações de download** são automáticas — não precisa configurar nada.
14. `--identifier` permite fixar o bundle identifier para cenários avançados.

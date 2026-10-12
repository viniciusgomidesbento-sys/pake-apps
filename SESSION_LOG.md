# Sessão 2026-07-12 — Criação e Build do Pake Apps Project

## Resumo
Projeto criado para empacotar sites como apps desktop via Pake CLI + GitHub Actions.
13 apps configurados, build em 3 SOs (Windows/macOS/Linux).

## Histórico de Workflows

| Run | ID | Resultado | Motivo |
|-----|-----|-----------|--------|
| #1 | 29215582865 | ❌ Falha | user-agent com espaços quebrava args; Rust não instalado no Linux |
| #2 | 29216077903 | ⚠️ Parcial | Windows + macOS ok, Linux falhou (sem Rust) |
| #3 | 29216550021 | ❌ Falha | Linux: cache ~/.cargo corrompido (restaurado de macOS) |
| #4 | 29217145087 | ❌ Falha | Linux: mkdir -p ~/.cargo/bin não resolveu |
| #5 | 29217554141 | ❌ Falha | Linux: apt instalou Rust 1.75 (muito velho, precisa >= 1.85) |
| #6 | 29218009003 | ❌ Falha | Linux: PATH não生效 no mesmo step do rustup |
| #7 | 29218489591 | ✅ **SUCESSO** | Todos OS, todos apps buildados |

## Correções aplicadas no workflow
1. Args com array bash `ARGS=()` em vez de concatenação de string
2. Trigger `[master, main]` no push
3. Rust instalado via rustup com `CARGO_HOME` fresco (`~/.cargo-fresh`)
4. `export PATH` antes de verificar rustc no mesmo step
5. Dependências WebKit/Tauri via apt no Linux

## Artefatos gerados (workflow #7)
Na pasta `apps-final/`:

- **Windows (10 .msi):** NotebookLM, ChatGPT, n8n, Bear Notes, Tec Concursos, Guruja, Google Drive, Google App Script, Google Sheets, Google Docs
- **macOS (10 .dmg):** mesmos apps
- **Linux (10 .deb + 10 .AppImage):** mesmos apps

## Apps configurados (13)
NotebookLM, ChatGPT, n8n, Bear Notes, Tec Concursos, Guruja,
Google Drive, Google App Script, Google Sheets, Google Docs,
Claude AI, GitHub, Hermes Agent

## Observações
- Apple Sign-In funciona no WebView com --new-window + --multi-window + user-agent Chrome ✅ (testado no ChatGPT)
- Pake CLI 3.14.0 instalado
- Cache Rust acelera builds de ~15min para ~5min

# Sessão 2026-07-13 — Expansão para 21 apps (+8 novos)

## O que foi feito
1. **Novas flags no `apps.json`** para todos os 13 apps:
   - `zoom` — zoom inicial (100 padrão, 90 no Google Sheets)
   - `min-width` / `min-height` — limite mínimo de redimensionamento
   - `start-to-tray` — iniciar na bandeja (true no n8n e Hermes Agent)
   - `app-version` — versão dos artefatos ("1.0.0")
   - `installer-language` — instalador Windows em português ("pt-BR")
   - `icon` — preparado para ícones customizados (null = auto-fetch)
2. **Workflow atualizado** em `.github/workflows/build-apps.yml`:
   - Novas env vars: ZOOM, MIN_WIDTH, MIN_HEIGHT, APP_VERSION, INSTALLER_LANG, START_TO_TRAY
   - Args correspondentes no script bash de build
3. **Estrutura de ícones** em `config/icons/` com README
4. **Build #8** (29285042460): 40/40 jobs success — todos os 13 apps nas 3 plataformas

## Apps com configuração especial
- **n8n**: start-to-tray: true, min-width: 900 (roda em background)
- **Hermes Agent**: start-to-tray: true (console em background)
- **Google Sheets**: zoom: 90 (ver mais células)
- **Google Drive/Docs/Sheets/Script/GitHub**: min-width: 900 (mais conteúdo)

## Builds
| Run | ID | Resultado |
|-----|-----|-----------|
| #8 | 29285042460 | ✅ Sucesso — 40/40 jobs |

# Sessão 2026-10-11 — Recorte da lista (14 apps)

## O que foi feito
1. **Manter 12 apps** existentes (objetos JSON intactos): NotebookLM, n8n, Tec Concursos, Guruja, Google App Script, Perplexity, DeepSeek Chat, OpenCut, Onyx, Z.AI, Z.AI OCR, Google Flow.
2. **Remover 15 apps:** ChatGPT, Bear Notes, Google Drive, Google Sheets, Google Docs, Claude AI, GitHub, Hermes Agent, AFFiNE, StackEdit, Dify, Khoj, PaddleOCR, Kanban Local, Grok.
3. **Adicionar 2 apps** no mesmo schema (dark-mode, tray, pt-BR, `user-agent`/`icon` null):
   - **Qwen AI** — `https://chat.qwen.ai` (chat oficial; HTTP 200, sem redirect).
   - **Xiaomi Console** — `https://i.mi.com` (Xiaomi Cloud: app web autenticado; suporte Xiaomi: único site oficial da Mi Cloud). Alternativa considerada: `https://dev.mi.com/platform/console` (管理中心 / console de desenvolvedor, UI em chinês).
4. Docs alinhadas: `APPS.md`, este log, `README.md`, `config/icons/README.md`. Sem pin de `pake-cli` e sem mudança no cache Rust.

## Catálogo (após este recorte inicial): 14
NotebookLM, n8n, Tec Concursos, Guruja, Google App Script, Perplexity, DeepSeek Chat, OpenCut, Onyx, Z.AI, Z.AI OCR, Google Flow, Qwen AI, Xiaomi Console.

## Builds
Nenhum workflow disparado nesta sessão. Instaladores do recorte ainda não existem; o último CI verde em `master` continua o run 34129357644 (07/09/2026, lista de 27 apps, artefatos expirados).

# Sessão 2026-10-11 — +Z.AI Console e Kimi (16 apps)

## O que foi feito
1. **Qwen AI** já estava no JSON — não duplicar.
2. **Z.AI Console** — `https://z.ai/manage-apikey/apikey-list` (plataforma API internacional: chaves; billing em `/manage-apikey/billing`). Distinto de `chat.z.ai` (app Z.AI) e `ocr.z.ai`. `https://z.ai` redireciona para o chat. `https://z.ai/dashboard` = 404. Alternativa China: `https://open.bigmodel.cn/console` (BigModel, login por telefone).
3. **Kimi** — `https://www.kimi.com` (canônico: `kimi.moonshot.cn` e `kimi.com` redirecionam para cá).
4. Docs: catálogo em 16.

## Catálogo atual (16)
NotebookLM, n8n, Tec Concursos, Guruja, Google App Script, Perplexity, DeepSeek Chat, OpenCut, Onyx, Z.AI, Z.AI OCR, Google Flow, Qwen AI, Xiaomi Console, Z.AI Console, Kimi.

# Sessão 2026-10-12 — Pin pake-cli@3.17.3 + cache Rust

## O que foi feito
1. **Pin `pake-cli@3.17.3`** (npm latest na data; docs ainda falavam 3.14.0). `PAKE_CLI_VERSION` no workflow; `npm install -g pake-cli@${{ env.PAKE_CLI_VERSION }}`. README, `build-local.ps1`, handoff e referência alinhados. Sem recorte de apps.
2. **Cache Rust:**
   - Prefixo `pake-v1` → `pake-v2` (invalida caches antigos).
   - Chave exata: `pake-v2-rust-${{ runner.os }}` (Linux / macOS / Windows). Sem `restore-keys` — o prefixo `pake-v1-rust-` sem OS restaurou artefato macOS no Linux (runs #3–#4).
   - Linux passa a cachear `~/.cargo-fresh` + `~/.rustup-fresh` (onde o job instala). Antes gravava `~/.cargo` / `~/.rustup`, inúteis no Linux.
   - Removido `hashFiles('**/Cargo.lock')` — este repo não tem Cargo.lock (hash vazio).
   - Cache npm: `pake-v2-npm-${{ runner.os }}-3.17.3`.

## Catálogo
Inalterado: 16 apps no master.

# Sessão 2026-10-12 — Recorte para 3 apps

## O que foi feito
1. **PR #2 mergeado** (squash `e026a52`): pin `pake-cli@3.17.3` + cache Rust no master. CI 50/50 verde.
2. **Recorte da lista:** manter só 3 objetos JSON já existentes (URLs intactas):
   - **Qwen AI** — `https://chat.qwen.ai`
   - **Kimi** — `https://www.kimi.com`
   - **Xiaomi Console** — `https://i.mi.com`
3. **Removidos (13):** NotebookLM, n8n, Tec Concursos, Guruja, Google App Script, Perplexity, DeepSeek Chat, OpenCut, Onyx, Z.AI, Z.AI OCR, Google Flow, Z.AI Console.
4. Docs: `APPS.md`, este log, `README.md`, `config/icons/README.md`. Sem apps novos.

## Catálogo atual (3)
Qwen AI, Kimi, Xiaomi Console.

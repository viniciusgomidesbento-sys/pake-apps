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

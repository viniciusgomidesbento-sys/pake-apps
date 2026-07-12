# CLAUDE.md — 31_pake (Pake Apps)

## Identidade
Projeto de empacotamento de sites como apps desktop via **Pake CLI** + **GitHub Actions**.
Build multi-plataforma (Windows/macOS/Linux) a partir de config centralizada.

## Estrutura
- `config/apps.json` — definição centralizada de todos os apps
- `config/inject/` — CSS/JS injetados nos apps
- `.github/workflows/build-apps.yml` — workflow matrix (3 SOs × N apps)
- `scripts/add-app.ps1` — adiciona app interativamente ao JSON
- `scripts/build-local.ps1` — build local Windows
- `docs/pake-cli-reference.md` — referência completa do Pake
- `docs/pake-handoff.md` — handoff original do estudo

## Fluxo
1. Adicionar app em `config/apps.json` (ou usar `scripts/add-app.ps1`)
2. Commit + push → GitHub Actions dispara
3. Build em 3 SOs simultaneamente → artefatos disponíveis em 5-15 min
4. Download dos instaladores em Actions → Artifacts

## Comandos
```powershell
# Adicionar app (interativo)
.\scripts\add-app.ps1

# Build local Windows
.\scripts\build-local.ps1 -Name "ChatGPT"
```

## Links
- Fork: https://github.com/viniciusgomidesbento-sys/Pake
- Pake CLI Docs: https://github.com/tw93/Pake/blob/main/docs/cli-usage.md

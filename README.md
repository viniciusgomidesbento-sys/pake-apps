# Pake Apps

Empacotamento de sites como **aplicativos desktop nativos** usando [Pake](https://github.com/tw93/Pake) (Tauri + Rust).

## Como funciona

1. **Configure** os apps em [`config/apps.json`](config/apps.json)
2. **Commit + push** → GitHub Actions dispara automaticamente
3. **Build** em 3 SOs simultâneos (Windows, macOS, Linux)
4. **Download** dos instaladores em **Actions → Artifacts**

## Pré-requisitos

| Recurso | Para quê |
|---------|----------|
| [Fork do Pake](https://github.com/viniciusgomidesbento-sys/Pake) | Workflows GitHub Actions |
| Node.js ≥ 22 | Build local (Windows) |
| pake-cli (`npm install -g pake-cli`) | Build local |

## Estrutura do Projeto

```
31_pake/
├── .github/workflows/
│   └── build-apps.yml         # Workflow matrix (3 SOs × N apps)
├── config/
│   ├── apps.json              # Definição centralizada dos apps
│   └── inject/                # CSS/JS injetados nos builds
├── docs/
│   ├── pake-cli-reference.md  # Referência completa do Pake
│   └── pake-handoff.md        # Handoff original
├── scripts/
│   ├── add-app.ps1            # Adiciona app ao JSON (interativo)
│   └── build-local.ps1        # Build local Windows
├── apps/                      # Artefatos de build local (gitignored)
├── .claude/CLAUDE.md          # Instruções para sessões Claude
├── .gitignore
└── README.md
```

## Adicionar um App

### Opção 1: Editar o JSON diretamente

Edite [`config/apps.json`](config/apps.json) e adicione um novo bloco:

```json
{
  "name": "MeuApp",
  "url": "https://exemplo.com",
  "description": "Descrição opcional",
  "width": 1280,
  "height": 800,
  "dark-mode": true,
  "show-system-tray": true,
  "hide-on-close": true,
  "enable-drag-drop": true,
  "keep-binary": false,
  "safe-domain": null,
  "icon": null
}
```

### Opção 2: Script interativo (Windows)

```powershell
.\scripts\add-app.ps1
```

### Opção 3: Script direto

```powershell
.\scripts\add-app.ps1 -Url "https://chatgpt.com" -Name "ChatGPT" -DarkMode -SystemTray
```

## Workflow GitHub Actions

O workflow [`build-apps.yml`](.github/workflows/build-apps.yml) faz:

- **Matrix 3×N**: 3 sistemas operacionais × N apps definidos no JSON
- **Cache Rust**: acelera builds seguintes (~5 min após primeiro)
- **Upload automático**: artefatos disponíveis por 30 dias
- **Fail-fast false**: se um SO falhar, os outros continuam
- **42 flags suportadas**: todas as opções do Pake mapeadas

### Disparo

- **Manual**: Actions → Build Pake Apps → Run Workflow (permite escolher app)
- **Automático**: push na main com mudanças em `config/apps.json` ou `.github/workflows/`

### Download dos builds

1. Vá até **Actions** no GitHub
2. Clique no workflow concluído
3. Role até **Artifacts**
4. Baixe o artefato do SO desejado: `NomeApp-ubuntu-latest`, `NomeApp-macos-latest`, `NomeApp-windows-latest`

## Build Local (Windows)

```powershell
.\scripts\build-local.ps1 -Name "ChatGPT"
```

Requer `pake-cli` instalado globalmente.

## Injeção de CSS/JS

Coloque arquivos `.css` e `.js` em [`config/inject/`](config/inject/) para serem injetados automaticamente em todos os apps durante o build.

Exemplo: `config/inject/block-ads.css`

```css
.ads-banner { display: none !important; }
```

## Documentação

- [`docs/pake-cli-reference.md`](docs/pake-cli-reference.md) — referência completa: todas as flags, targets, FAQ, GitHub Actions, personalização avançada
- [`docs/pake-handoff.md`](docs/pake-handoff.md) — handoff original do estudo do Pake
- Repositório original: [tw93/Pake](https://github.com/tw93/Pake)
- CLI Docs: [cli-usage.md](https://github.com/tw93/Pake/blob/main/docs/cli-usage.md)

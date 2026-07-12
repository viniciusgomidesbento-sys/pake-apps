# Pake — Handoff Document

## Contexto

Estamos estudando o [Pake](https://github.com/tw93/Pake), ferramenta que empacota **qualquer site como aplicativo desktop** usando Tauri (Rust + WebView nativo). Gera instaladores nativos para Windows (.msi/.exe), macOS (.dmg/.app) e Linux (.deb/.AppImage/.rpm).

A documentação completa que produzimos está em:
`C:\Users\vinic\PROJETOS\04_PROJETOS_ATIVOS\19_hermes_adm\docs\pake-cli-reference.md`

## Documentos Originais Estudados (5 no total)

| Documento | Conteúdo |
|-----------|----------|
| docs/cli-usage.md | Flags, targets, exemplos práticos |
| docs/advanced-usage.md | CSS/JS injection, comunicação Rust, notificações, estrutura, dev workflow, testes |
| docs/faq.md | 11 problemas de build + 4 runtime + 1 instalação |
| docs/github-actions-usage.md | Build online via GitHub Actions |
| docs/pake-action.md | GitHub Action para CI/CD |

## Status Atual

- **Pake CLI 3.14.0** instalado e funcional no ambiente Windows
- Ambiente: Windows 11 Home, Node.js, Rust (via pake)
- Referência completa salva em `19_hermes_adm/docs/pake-cli-reference.md`

## Capacidade Atual

| SO | Build local? | Alternativa |
|:--|:-----------:|------------|
| Windows (.exe/.msi) | ✅ Sim, direto | — |
| macOS (.app/.dmg) | ❌ Não (precisa de macOS) | GitHub Actions |
| Linux (.deb/.AppImage) | ❌ Não (precisa de Linux) | GitHub Actions |

## Limitações Importantes

- Pake só faz **desktop**, não iOS/Android
- Para iOS, alternativas: WKWebView nativo, Capacitor, PWA
- Google OAuth pode falhar em webviews embutidos (política do provedor)
- Cloudflare/WebKitGTK no Linux pode loopar sem workaround
- `--safe-domain` e `--internal-url-regex` são mutuamente exclusivos (regex vence)
- `--multi-window` vs `--multi-instance`: o primeiro é 1 processo N janelas, o segundo é N processos

## Flags Essenciais

```powershell
# Estrutura básica
pake <URL> --name <Nome> [flags]

# Flags comuns
--width <px>          # Largura (default 1200)
--height <px>         # Altura (default 780)
--icon <path>         # Ícone (.icns/.ico/.png)
--dark-mode           # Modo escuro
--show-system-tray    # Bandeja do sistema
--hide-on-close       # Minimizar ao fechar
--multi-window        # Várias janelas (mesmo processo)
--incognito           # Modo anônimo
--inject <css,js>     # Injetar CSS/JS
--keep-binary         # Executável standalone
--iterative-build     # Build rápido (teste)
--activation-shortcut # Atalho de teclado
--safe-domain         # Domínios confiáveis
--user-agent          # Custom User-Agent
--proxy-url           # Proxy
--enable-drag-drop    # Drag & drop nativo
--wasm                # Suporte WebAssembly (Flutter Web)
--camera              # Câmera (macOS)
--microphone          # Microfone (macOS)
```

## Próximos Passos Planejados

1. Criar nova pasta de projeto (ex: `PROJETOS/05_pake_apps` ou similar)
2. Escolher URL(s) alvo para empacotar
3. Definir flags conforme necessidade
4. Build local (Windows) ou via GitHub Actions (macOS/Linux)
5. Testar e validar os apps gerados

## Comandos de Build

```powershell
# Windows - build local
pake <URL> --name "AppName" <flags>

# macOS/Linux - via GitHub Actions (precisa de YAML)
# Usar tw93/Pake@v3 action com matrix OS
```

## Para Retomar

Quando este handoff for lido no novo projeto:
1. A referência completa está em `docs/pake-cli-reference.md` no projeto anterior
2. Pake CLI 3.14.0 já está instalado
3. Verificar com `pake --version`
4. Se for build macOS/Linux, preparar GitHub Actions workflow

# Apps Pake — Situação

Total: 24 apps no `config/apps.json`.

## ✅ Instalados (10)

| App | Instalado em |
|---|---|
| NotebookLM | 12/07/2026 |
| ChatGPT | 12/07/2026 |
| n8n | 12/07/2026 |
| Bear Notes | 12/07/2026 |
| Tec Concursos | 12/07/2026 |
| Guruja | 12/07/2026 |
| Google Drive | 12/07/2026 |
| Google App Script | 12/07/2026 |
| Google Sheets | 12/07/2026 |
| Google Docs | 12/07/2026 |

> ⚠️ Apps com Google Sheets e Bear Notes apresentaram erro de login. **Causa:** user-agent hardcoded como Chrome 126, mas o WebView2 do sistema é Chrome 150. Google detectou o mismatch e bloqueou o login.
>
> **Fix aplicado:** user-agent removido (null) em todos os apps. Build em andamento no Actions.

## 📦 MSI na área de trabalho — build anterior (user-agent Chrome 126)

Os MSIs em `C:\Users\vinic\Desktop\PAKE_APPS\` são do build de 17/07/2026 e AINDA têm o user-agent antigo. **Não usar.** Aguardar o novo build.

| App | MSI |
|---|---|
| Claude AI | `Claude AI.msi` |
| GitHub | `GitHub.msi` |
| Hermes Agent | `Hermes Agent.msi` |
| Perplexity | `Perplexity.msi` |
| DeepSeek Chat | `DeepSeek Chat.msi` |
| AFFiNE | `AFFiNE.msi` |
| StackEdit | `StackEdit.msi` |
| OpenCut | `OpenCut.msi` |
| Dify | `Dify.msi` |
| Onyx | `Onyx.msi` |
| Khoj | `Khoj.msi` |
| Z.AI | `Z.AI.msi` |

## 🔄 Build em andamento — user-agent fix + apps novos

Workflow: [#29642887925](https://github.com/viniciusgomidesbento-sys/pake-apps/actions/runs/29642887925)

Todos os 24 apps serão rebuildados com user-agent nativo do WebView2 (Chrome 150).
Quando concluir, baixo e substituo os MSIs na área de trabalho.

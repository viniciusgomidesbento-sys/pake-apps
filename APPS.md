# Apps Pake — Situação

Total: **16 apps** em [`config/apps.json`](config/apps.json) (fonte da verdade).

Recorte de 2026-10-11: 12 apps mantidos da lista anterior + 4 novos (Qwen AI, Xiaomi Console, Z.AI Console, Kimi). Os demais foram removidos da matrix.

## Catálogo atual

| App | URL |
|---|---|
| NotebookLM | https://notebooklm.google |
| n8n | VPS Hostinger (`n8n-tfxb.srv1724289.hstgr.cloud`) |
| Tec Concursos | https://www.tecconcursos.com.br |
| Guruja | https://portal.guruja.com.br |
| Google App Script | https://script.google.com/home/ |
| Perplexity | https://www.perplexity.ai |
| DeepSeek Chat | https://chat.deepseek.com |
| OpenCut | https://opencut.app |
| Onyx | https://cloud.onyx.app |
| Z.AI | https://chat.z.ai |
| Z.AI OCR | https://ocr.z.ai |
| Google Flow | https://labs.google/fx/pt/tools/flow |
| Qwen AI | https://chat.qwen.ai |
| Xiaomi Console | https://i.mi.com |
| Z.AI Console | https://z.ai/manage-apikey/apikey-list |
| Kimi | https://www.kimi.com |

## Instaladores

Não há MSIs/DMGs/DEBs versionados neste recorte. O último CI verde em `master` foi o run [34129357644](https://github.com/viniciusgomidesbento-sys/pake-apps/actions/runs/34129357644) (07/09/2026, lista antiga de 27 apps); os artefatos já expiraram (retenção 30 dias).

Depois do merge, disparar **Actions → Build Pake Apps** para gerar instaladores dos 16 apps atuais. Qwen AI, Xiaomi Console, Z.AI Console e Kimi ainda não têm build.

### Histórico (lista antiga — não usar)

- User-agent Chrome 126 vs WebView2 150: corrigido (`user-agent: null` em todos).
- Builds de 18/07/2026 ([29630809708](https://github.com/viniciusgomidesbento-sys/pake-apps/actions/runs/29630809708)) e 07/09/2026 são da lista antiga (ChatGPT, Claude, Grok, etc.) e não cobrem este recorte.

## Removidos neste recorte

ChatGPT, Bear Notes, Google Drive, Google Sheets, Google Docs, Claude AI, GitHub, Hermes Agent, AFFiNE, StackEdit, Dify, Khoj, PaddleOCR, Kanban Local, Grok.

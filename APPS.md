# Apps Pake — Situação

Total: **3 apps** em [`config/apps.json`](config/apps.json) (fonte da verdade).

Recorte de 2026-10-12: só Qwen AI, Kimi e Xiaomi Console. Objetos JSON e URLs iguais aos que já estavam no master. Os outros 13 apps da lista de 16 foram removidos.

## Catálogo atual

| App | URL |
|---|---|
| Qwen AI | https://chat.qwen.ai |
| Kimi | https://www.kimi.com |
| Xiaomi Console | https://i.mi.com |

## Instaladores

O pin `pake-cli@3.17.3` + cache Rust já está em `master` ([PR #2](https://github.com/viniciusgomidesbento-sys/pake-apps/pull/2), squash `e026a52`). CI daquele PR: run [38189249819](https://github.com/viniciusgomidesbento-sys/pake-apps/actions/runs/38189249819) (50/50, lista de 16). Artefatos de Qwen / Kimi / Xiaomi existem nesse run (retenção 30 dias).

Depois do merge deste recorte, o workflow passa a gerar só estes 3 apps (9 jobs de build + config).

### Histórico (listas antigas — não usar)

- 16 apps (2026-10-11): NotebookLM, n8n, Tec Concursos, Guruja, Google App Script, Perplexity, DeepSeek Chat, OpenCut, Onyx, Z.AI, Z.AI OCR, Google Flow, Qwen AI, Xiaomi Console, Z.AI Console, Kimi.
- 27 apps (07/09/2026, run [34129357644](https://github.com/viniciusgomidesbento-sys/pake-apps/actions/runs/34129357644)): artefatos expirados.

## Removidos neste recorte

NotebookLM, n8n, Tec Concursos, Guruja, Google App Script, Perplexity, DeepSeek Chat, OpenCut, Onyx, Z.AI, Z.AI OCR, Google Flow, Z.AI Console.

# Ícones Customizados — Pake Apps

Coloque aqui os ícones dos apps no formato correto por plataforma:

| Plataforma | Formato | Tamanho |
|-----------|---------|---------|
| Windows | `.ico` | 256x256 |
| macOS | `.icns` | 512x512 |
| Linux | `.png` | 512x512 |

## Como usar

1. Coloque o ícone com o **mesmo nome do app** na pasta (ex: `notebooklm.ico`, `n8n.png`, `qwen-ai.icns`)
2. O workflow injeta automaticamente via `--icon`

## Apps disponíveis (16)

- NotebookLM, n8n, Tec Concursos, Guruja, Google App Script,
  Perplexity, DeepSeek Chat, OpenCut, Onyx, Z.AI, Z.AI OCR,
  Google Flow, Qwen AI, Xiaomi Console, Z.AI Console, Kimi

## Formato

```json
"icon": "config/icons/nomedoapp.ico"
```

Se o campo `icon` estiver `null`, o Pake usa o favicon do site automaticamente.

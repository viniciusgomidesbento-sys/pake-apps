# Ícones Customizados — Pake Apps

Coloque aqui os ícones dos apps no formato correto por plataforma:

| Plataforma | Formato | Tamanho |
|-----------|---------|---------|
| Windows | `.ico` | 256x256 |
| macOS | `.icns` | 512x512 |
| Linux | `.png` | 512x512 |

## Como usar

1. Coloque o ícone com o **mesmo nome do app** na pasta (ex: `chatgpt.ico`, `github.icns`, `n8n.png`)
2. O workflow injeta automaticamente via `--icon`

## Apps disponíveis

- NotebookLM, ChatGPT, n8n, Bear Notes, Tec Concursos, Guruja,
  Google Drive, Google App Script, Google Sheets, Google Docs,
  Claude AI, GitHub, Hermes Agent

## Formato

```json
"icon": "config/icons/nomedoapp.ico"
```

Se o campo `icon` estiver `null`, o Pake usa o favicon do site automaticamente.

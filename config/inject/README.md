# Inject — CSS/JS customizados

Coloque aqui arquivos `.css` e `.js` para serem injetados automaticamente
em todos os apps durante o build.

## Como usar

1. Crie seus arquivos aqui (ex: `block-ads.css`, `custom-hotkeys.js`)
2. O workflow do GitHub Actions e o script `build-local.ps1`
   detectam automaticamente e passam via `--inject`

## Exemplo: block-ads.css

```css
.ads-banner, .ad-container { display: none !important; }
.premium-upsell { display: none !important; }
```

## Exemplo: custom-hotkeys.js

```javascript
document.addEventListener("keydown", (e) => {
  if (e.ctrlKey && e.key === "k") {
    document.querySelector('input[type="search"]')?.focus();
    e.preventDefault();
  }
});
```

## Observações

- Arquivos são combinados com vírgula (`--inject a.css,b.js`)
- A ordem de injeção segue a ordem alfabética dos arquivos
- Para injetar em apps específicos, use nomes como `chatgpt-hide.css`
  (o workflow atual injeta tudo — refine conforme necessário)

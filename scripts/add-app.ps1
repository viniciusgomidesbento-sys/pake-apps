#!/usr/bin/env pwsh
# =============================================================================
# add-app.ps1 — Adiciona um novo app ao config/apps.json interativamente
# =============================================================================
# Uso:
#   .\scripts\add-app.ps1                                      # modo interativo
#   .\scripts\add-app.ps1 -Url "https://exemplo.com" -Name "MeuApp"   # direto
#
# O script valida os campos, adiciona ao JSON e mostra o resumo.
# =============================================================================

param(
  [string]$Url,
  [string]$Name,
  [int]$Width = 1280,
  [int]$Height = 800,
  [switch]$DarkMode,
  [switch]$SystemTray,
  [switch]$MultiWindow,
  [switch]$Incognito,
  [switch]$Wasm,
  [switch]$DragDrop,
  [switch]$Camera,
  [switch]$Microphone,
  [string]$SafeDomain,
  [string]$Icon
)

$configPath = Join-Path $PSScriptRoot ".." "config" "apps.json"
$configPath = Resolve-Path $configPath -ErrorAction Stop

if (-not $Url) {
  $Url = Read-Host "URL do app (ex: https://chatgpt.com)"
}
if (-not $Name) {
  $Name = Read-Host "Nome do app (ex: ChatGPT)"
}
if (-not $Url -or -not $Name) {
  Write-Error "URL e Name são obrigatórios"
  exit 1
}

# Lê config existente
$config = Get-Content $configPath -Raw | ConvertFrom-Json

# Verifica duplicata
$exists = $config.apps | Where-Object { $_.name -eq $Name }
if ($exists) {
  Write-Warning "App '$Name' já existe em config/apps.json. Pulando."
  exit 0
}

# Monta o objeto do app
$app = [PSCustomObject]@{
  name              = $Name
  url               = $Url
  description       = Read-Host "Descrição (opcional)"
  width             = $Width
  height            = $Height
  "dark-mode"       = $DarkMode -or ((Read-Host "Modo escuro? (s/N)") -eq "s")
  "show-system-tray" = $SystemTray -or ((Read-Host "Bandeja do sistema? (s/N)") -eq "s")
  "hide-on-close"   = $null
  "multi-window"    = $MultiWindow
  incognito         = $Incognito
  wasm              = $Wasm
  "enable-drag-drop" = $DragDrop
  "keep-binary"     = $false
  icon              = if ($Icon) { $Icon } else { $null }
  "safe-domain"     = if ($SafeDomain) { $SafeDomain } else { $null }
  "user-agent"      = $null
  camera            = $Camera
  microphone        = $Microphone
  "hide-title-bar"  = $false
}

# Adiciona e salva
$config.apps += $app
$config | ConvertTo-Json -Depth 10 | Set-Content $configPath -Encoding UTF8

Write-Host "`n✅ App '$Name' adicionado com sucesso!" -ForegroundColor Green
Write-Host "URL: $Url" -ForegroundColor Cyan
Write-Host "Width: $Width | Height: $Height" -ForegroundColor Gray
Write-Host "`nCommit e push para disparar o build no GitHub Actions." -ForegroundColor Yellow

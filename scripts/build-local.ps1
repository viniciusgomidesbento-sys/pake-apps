#!/usr/bin/env pwsh
# =============================================================================
# build-local.ps1 — Build local de um app no Windows
# =============================================================================
# Uso:
#   .\scripts\build-local.ps1 -Name "ChatGPT"
#
# Lê os parâmetros do config/apps.json e executa o pake localmente.
# Requer: pake-cli instalado (npm install -g pake-cli)
# =============================================================================

param(
  [Parameter(Mandatory = $true)]
  [string]$Name
)

$configPath = Join-Path $PSScriptRoot ".." "config" "apps.json"
$configPath = Resolve-Path $configPath -ErrorAction Stop

# Lê config
$config = Get-Content $configPath -Raw | ConvertFrom-Json
$app = $config.apps | Where-Object { $_.name -eq $Name }

if (-not $app) {
  Write-Error "App '$Name' não encontrado em config/apps.json"
  Write-Host "Apps disponíveis:" -ForegroundColor Yellow
  $config.apps | ForEach-Object { Write-Host "  - $($_.name)" }
  exit 1
}

Write-Host "=== Build Local: $Name ===" -ForegroundColor Cyan
Write-Host "URL: $($app.url)" -ForegroundColor Gray

# Monta args
$args = @()

$args += "--width"; $args += "$($app.width)"
$args += "--height"; $args += "$($app.height)"

if ($app.icon)                { $args += "--icon"; $args += $app.icon }
if ($app."dark-mode")         { $args += "--dark-mode" }
if ($app."show-system-tray")  { $args += "--show-system-tray" }
if ($app."multi-window")      { $args += "--multi-window" }
if ($app.incognito)           { $args += "--incognito" }
if ($app.wasm)                { $args += "--wasm" }
if ($app."enable-drag-drop")  { $args += "--enable-drag-drop" }
if ($app."keep-binary")       { $args += "--keep-binary" }
if ($app."multi-instance")    { $args += "--multi-instance" }
if ($app."new-window")        { $args += "--new-window" }
if ($app.fullscreen)          { $args += "--fullscreen" }
if ($app.maximize)            { $args += "--maximize" }
if ($app."always-on-top")     { $args += "--always-on-top" }
if ($app."enable-find")       { $args += "--enable-find" }
if ($app."disabled-web-shortcuts") { $args += "--disabled-web-shortcuts" }
if ($app."force-internal-navigation") { $args += "--force-internal-navigation" }
if ($app."ignore-certificate-errors") { $args += "--ignore-certificate-errors" }
if ($app."hide-on-close" -eq $true)   { $args += "--hide-on-close" }
if ($app."hide-on-close" -eq $false)  { $args += "--hide-on-close"; $args += "false" }
if ($app."safe-domain")       { $args += "--safe-domain"; $args += $app."safe-domain" }
if ($app."user-agent")        { $args += "--user-agent"; $args += $app."user-agent" }
if ($app."activation-shortcut") { $args += "--activation-shortcut"; $args += $app."activation-shortcut" }
if ($app.title)               { $args += "--title"; $args += $app.title }
if ($app.camera)              { $args += "--camera" }
if ($app.microphone)          { $args += "--microphone" }
if ($app."hide-title-bar")    { $args += "--hide-title-bar" }

# Verifica inject
$injectDir = Join-Path $PSScriptRoot ".." "config" "inject"
if (Test-Path $injectDir) {
  $cssJs = @(Get-ChildItem $injectDir -Include "*.css","*.js" -Recurse)
  if ($cssJs) {
    $paths = ($cssJs | ForEach-Object { $_.FullName }) -join ","
    $args += "--inject"; $args += $paths
  }
}

Write-Host "`nComando:" -ForegroundColor Yellow
Write-Host "pake $($app.url) --name `"$($app.name)`" $($args -join ' ')" -ForegroundColor White

Write-Host "`nIniciando build..." -ForegroundColor Green
$env:CARGO_TERM_COLOR = "always"

& pake $app.url --name $app.name $args

if ($LASTEXITCODE -eq 0) {
  Write-Host "`n✅ Build concluído!" -ForegroundColor Green
  Write-Host "Arquivos gerados no diretório atual." -ForegroundColor Cyan
} else {
  Write-Error "Build falhou (exit code: $LASTEXITCODE)"
}

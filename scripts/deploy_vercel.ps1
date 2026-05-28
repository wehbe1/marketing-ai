# Deploy pre-built Flutter web to Vercel.
$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)

if (-not (Test-Path "build/web/index.html")) {
    Write-Error "Run scripts/build_web_release.ps1 first."
}

Push-Location build/web
try {
    npx vercel --prod --yes
} finally {
    Pop-Location
}

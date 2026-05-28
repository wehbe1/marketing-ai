# Builds a production Flutter web bundle for Firebase Hosting or Vercel.
# Usage (PowerShell):
#   copy deploy\env.example deploy\.env
#   # edit deploy\.env with your Firebase values
#   .\scripts\build_web_release.ps1

param(
    [string]$EnvFile = "deploy/.env"
)

$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)

function Get-EnvValue([string]$Key, [string]$Default = "") {
    if (Test-Path $EnvFile) {
        Get-Content $EnvFile | ForEach-Object {
            if ($_ -match "^\s*$Key=(.*)$") { return $matches[1].Trim() }
        }
    }
    return $Default
}

$apiBaseUrl = Get-EnvValue "API_BASE_URL" "https://marketing-ai-jspk.onrender.com"
$firebaseApiKey = Get-EnvValue "FIREBASE_API_KEY"
$firebaseAppId = Get-EnvValue "FIREBASE_APP_ID"
$firebaseSenderId = Get-EnvValue "FIREBASE_MESSAGING_SENDER_ID"
$firebaseProjectId = Get-EnvValue "FIREBASE_PROJECT_ID"
$firebaseAuthDomain = Get-EnvValue "FIREBASE_AUTH_DOMAIN"
$firebaseStorageBucket = Get-EnvValue "FIREBASE_STORAGE_BUCKET"
$firebaseWebClientId = Get-EnvValue "FIREBASE_WEB_CLIENT_ID"

Write-Host "Building Flutter web for production..."
Write-Host "API_BASE_URL=$apiBaseUrl"

$defines = @(
    "--dart-define=API_BASE_URL=$apiBaseUrl"
)

if ($firebaseApiKey) { $defines += "--dart-define=FIREBASE_API_KEY=$firebaseApiKey" }
if ($firebaseAppId) { $defines += "--dart-define=FIREBASE_APP_ID=$firebaseAppId" }
if ($firebaseSenderId) { $defines += "--dart-define=FIREBASE_MESSAGING_SENDER_ID=$firebaseSenderId" }
if ($firebaseProjectId) { $defines += "--dart-define=FIREBASE_PROJECT_ID=$firebaseProjectId" }
if ($firebaseAuthDomain) { $defines += "--dart-define=FIREBASE_AUTH_DOMAIN=$firebaseAuthDomain" }
if ($firebaseStorageBucket) { $defines += "--dart-define=FIREBASE_STORAGE_BUCKET=$firebaseStorageBucket" }
if ($firebaseWebClientId) { $defines += "--dart-define=FIREBASE_WEB_CLIENT_ID=$firebaseWebClientId" }

flutter build web --release @defines

Write-Host ""
Write-Host "Build complete: build/web"
Write-Host "Deploy with one of:"
Write-Host "  Firebase: firebase deploy --only hosting"
Write-Host "  Vercel:   npx vercel deploy build/web --prod"

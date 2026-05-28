#!/usr/bin/env bash
# Builds a production Flutter web bundle for Firebase Hosting or Vercel.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="${ROOT}/deploy/.env"
cd "$ROOT"

get_env() {
  local key="$1"
  local default="${2:-}"
  if [[ -f "$ENV_FILE" ]]; then
    local val
    val="$(grep -E "^${key}=" "$ENV_FILE" | head -n1 | cut -d= -f2- | tr -d '\r')"
    if [[ -n "$val" ]]; then
      echo "$val"
      return
    fi
  fi
  echo "$default"
}

API_BASE_URL="$(get_env API_BASE_URL https://marketing-ai-jspk.onrender.com)"
echo "Building Flutter web for production..."
echo "API_BASE_URL=${API_BASE_URL}"

DEFINES=(--dart-define="API_BASE_URL=${API_BASE_URL}")

append_define() {
  local key="$1"
  local val
  val="$(get_env "$key" "")"
  if [[ -n "$val" ]]; then
    DEFINES+=(--dart-define="${key}=${val}")
  fi
}

append_define FIREBASE_API_KEY
append_define FIREBASE_APP_ID
append_define FIREBASE_MESSAGING_SENDER_ID
append_define FIREBASE_PROJECT_ID
append_define FIREBASE_AUTH_DOMAIN
append_define FIREBASE_STORAGE_BUCKET
append_define FIREBASE_WEB_CLIENT_ID

flutter build web --release "${DEFINES[@]}"

echo ""
echo "Build complete: build/web"
echo "Deploy with one of:"
echo "  Firebase: firebase deploy --only hosting"
echo "  Vercel:   npx vercel deploy build/web --prod"

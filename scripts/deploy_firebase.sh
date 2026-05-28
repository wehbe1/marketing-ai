#!/usr/bin/env bash
# Deploy pre-built Flutter web to Firebase Hosting.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -d "build/web" ]]; then
  echo "Run scripts/build_web_release.sh first."
  exit 1
fi

firebase deploy --only hosting

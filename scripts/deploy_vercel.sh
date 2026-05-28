#!/usr/bin/env bash
# Deploy pre-built Flutter web to Vercel.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -d "build/web" ]]; then
  echo "Run scripts/build_web_release.sh first."
  exit 1
fi

cd build/web
npx vercel --prod --yes

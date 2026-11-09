#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="${1:-all}"

package_checks() {
  cd "$ROOT"
  npm ci --no-audit --no-fund
  rustup toolchain install 1.88.0 --profile minimal --target wasm32-unknown-unknown
  cargo install wasm-bindgen-cli --version 0.2.126 --locked
  CARGO_BUILD_JOBS="${CARGO_BUILD_JOBS:-2}" npm run build:package
  npm run test:package
}

browser_check() {
  cd "$ROOT"
  npm ci --prefix testfoss --no-audit --no-fund
  export PATH="$ROOT/testfoss/node_modules/.bin:$PATH"
  if [[ -z "${TESTFOSS_CHROME_EXECUTABLE:-}" ]]; then
    export TESTFOSS_CHROME_EXECUTABLE="$(cd "$ROOT/testfoss" && node --input-type=module -e "import { chromium } from '@playwright/test'; console.log(chromium.executablePath())")"
  fi
  local port="${TESTFOSS_PORT:-8107}"
  python3 -m http.server "$port" --bind 127.0.0.1 --directory "$ROOT/packages/manim-web" >"${TMPDIR:-/tmp}/testfoss-manim-http.log" 2>&1 &
  local server_pid=$!
  trap "kill $server_pid 2>/dev/null || true" EXIT
  for attempt in {1..40}; do
    if curl --fail --silent "http://127.0.0.1:$port/example/" >/dev/null; then
      break
    fi
    if [[ "$attempt" == 40 ]]; then
      echo "Manim static server did not become ready" >&2
      exit 1
    fi
    sleep 0.25
  done
  (cd "$ROOT/testfoss" && TESTFOSS_BASE_URL="http://127.0.0.1:$port" lmscript browser.lms)
}

case "$MODE" in
  package) package_checks ;;
  browser) browser_check ;;
  all) package_checks; browser_check ;;
  *) echo "Usage: $0 [package|browser|all]" >&2; exit 2 ;;
esac

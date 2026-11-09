# Testfoss demo agent guide

## Scope and source pin

This branch is `testfoss-demo`, based on upstream commit `f604cb5b9e6fd19660635821c00d5ea641047d8f` (package version 0.6.1). The public fork is `https://github.com/testfoss/realtime-manim-rs`; upstream is `https://github.com/adamholter/realtime-manim-rs`.

The Testfoss change is additive. Apart from the appended README section, keep changes inside `AGENTS.md`, `durable-memory/**`, `testfoss/**`, and `.github/workflows/testfoss.yml`. Do not change upstream scripts, examples, source, lockfiles, or other workflows. Do not commit generated Wasm, build output, `node_modules`, screenshots, or browser results. Do not open upstream issues or pull requests from this demo work.

## Reproduce

The lab used Node 22; fork commands and Actions use Node 24 because lmscript 0.2.463 requires Node 24.15 or newer. Rust 1.88.0 with `wasm32-unknown-unknown` and `wasm-bindgen-cli` 0.2.126 remain the recorded build toolchain. From the repository root:

```sh
./testfoss/run.sh package
(cd testfoss && npm ci && npx playwright install chromium)
LMCODE_HEADED=1 ./testfoss/run.sh browser
```

`package` runs `npm ci`, `npm run build:package`, and `npm run test:package`; the recorded upstream result is 35/35 package tests plus strict TypeScript, pack dry-run, and packed-consumer checks. The package build regenerates `packages/manim-web/runtime/realtime_manim_web_preview.js` and `packages/manim-web/runtime/realtime_manim_web_preview_bg.wasm` in the working tree. Those are upstream generated files, not Testfoss source: preserve their pinned contents in the change set and never commit the regenerated versions. `scripts/build-web-package.sh` and `scripts/test-browser-package.mjs` must remain pristine.

The browser check uses `lmwebtest playwright` through `testfoss/browser.lms`; it does not use upstream `test:browser-package`. Install lmwebtest and lmscript only from `testfoss/package-lock.json` (`lmwebtest` commit `2920befd355eacc654697820d690db074e94dce3`, `@lmctl-ai/lmctl` 0.2.463, Playwright 1.62.1). It checks a real local package scene, pause stability, an exact `2.00s` seek, resume past 2.05 seconds, and browser errors.

## Limitations

This is a third-party experimental Manim-style runtime, not official Manim Community or full Manim compatibility. WebGPU is required; there is no WebGL fallback in this demo. The recorded lab pass used headful hardware-backed Chrome on Intel Gen 12 LP. Headless Chrome exposed no default adapter, and SwiftShader runs lost the device or left a blank canvas; do not claim those as passes. The Actions rendered-browser job is therefore manual and hardware-dependent. The package build/test job is the portable CI gate. See `durable-memory/status.md` for what has and has not been rerun in this fork.

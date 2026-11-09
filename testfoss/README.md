# Real-time Manim Testfoss demo

This directory is the only demo/tooling addition; upstream examples and scripts stay unchanged. The source pin is `f604cb5b9e6fd19660635821c00d5ea641047d8f`.

## Build and package tests

From the repository root:

```sh
./testfoss/run.sh package
```

The runner installs the locked root dependencies and `wasm-bindgen-cli` 0.2.126, builds the package with Rust 1.88.0, and runs the upstream package gate. The recorded result is 35/35 tests plus TypeScript, npm-pack, and packed-consumer checks.

The build refreshes upstream `packages/manim-web/runtime/` in the working tree. Do not commit that generated JavaScript/Wasm or any build output. The Testfoss branch retains the pinned runtime files.

## Browser timing check

Use a machine with reliable hardware WebGPU and a display:

```sh
(cd testfoss && npm ci && npx playwright install chromium)
LMCODE_HEADED=1 ./testfoss/run.sh browser
```

Open <http://127.0.0.1:8107/example/> to inspect the same local package example manually. The runner starts and stops a loopback-only Python static server. Set `TESTFOSS_CHROME_EXECUTABLE=/path/to/chrome` to use an installed Chrome instead of the Playwright-managed Chromium. `browser.lms` drives Chromium through `lmwebtest playwright` and verifies:

- `__MANIM_PACKAGE_READY__` and a WebGPU adapter;
- pause leaves the clock unchanged and changes the button to **Play**;
- setting the timeline to 2 seconds displays exactly `2.00s`;
- resume advances beyond 2.05 seconds;
- no page errors or failed requests occur.

A screenshot is disposable output under `testfoss/artifacts/`.

**WebGPU limitation:** the lab passed with headful hardware-backed Chrome. Headless Chrome had no default adapter; SwiftShader was unstable and is not a supported fallback here. Accordingly, the regular Actions job builds/tests the package, while the rendered job is an explicit manual run. This project is an experimental third-party Manim-style runtime, not official Manim Community.

Useful syntax checks without rebuilding:

```sh
bash -n testfoss/run.sh
(cd testfoss && npm ci && npm run check)
```

See `../durable-memory/status.md` for pins and verification status.

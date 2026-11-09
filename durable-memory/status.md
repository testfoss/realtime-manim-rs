# Testfoss status

## Exact pins

- Upstream source: `f604cb5b9e6fd19660635821c00d5ea641047d8f` (`f604cb5`, 0.6.1).
- Branch: `testfoss-demo`.
- Rust: 1.88.0; target `wasm32-unknown-unknown`; wasm-bindgen CLI 0.2.126.
- Node: 24 for fork commands/Actions (24.15+ for lmscript); the lab used Node 22. Playwright: 1.62.1.
- Browser host: `https://github.com/lmctl-ai/lmwebtest` at `2920befd355eacc654697820d690db074e94dce3`.
- lmscript package: `@lmctl-ai/lmctl` 0.2.463.

## Recorded lab evidence

The independent source-build lab run at the same source pin built fresh release Wasm and passed 35/35 package tests, strict TypeScript, package dry-run, and packed-consumer smoke. Its local package example passed pause (`1.81s` stable), exact seek (`2.00s`), and resume (`2.44s`) with no page errors or external requests. That browser pass used headful Chrome 157 on an Intel Gen 12 LP adapter. These are historical lab results, not claims that this fork's Actions run has completed.

Headless Chrome had no default WebGPU adapter. Software WebGPU with SwiftShader produced device loss, blank output, or a one-pixel difference in the stricter upstream Arabic mask check. No software result is promoted to a pass.

## Fork verification

Shell/JSON/YAML syntax checks and real lmwebtest schema discovery plus `lmscript --check browser.lms` passed. The browser scenario also passed 12/12 checks through `lmwebtest playwright` against the existing lab-built package at the same source pin, using headful Chrome 157 and the hardware WebGPU path: pause was stable at `1.36s`, the slider and clock reached exactly 2 seconds, and resume reached `2.45s` with no page errors or failed requests. This verifies the new LMS scenario, not a fresh fork package rebuild or an Actions run.

GitHub Actions runs 42643986673 and 42645114577 passed the full package build and 35-test gate. The hardware-dependent rendered browser job remains manual; the 12/12 local result above is not an Actions browser claim. `TESTFOSS_CHROME_EXECUTABLE=/usr/bin/google-chrome` was used locally to select the installed browser. No generated runtime, build, dependency, or screenshot output belongs in the commit.

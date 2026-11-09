# Testfoss decisions

## Additive fork only

Base the demo on `f604cb5b9e6fd19660635821c00d5ea641047d8f`. Add documentation, memory, `testfoss/**`, and one Testfoss workflow; do not carry the lab's modifications to `scripts/test-browser-package.mjs` or its generated runtime changes into this branch.

## External package runner

`testfoss/run.sh package` invokes the pristine upstream `build:package` and `test:package` commands. Building necessarily rewrites the tracked runtime in the working tree, so generated output is disposable CI state and must not be committed. The browser runner serves `packages/manim-web` directly and does not patch the upstream browser test.

## lmwebtest owns browser integration

`testfoss/browser.lms` embeds an `_lmcode_ cli="lmwebtest playwright"` program and executes it with `run_lmcode`. Dependencies are isolated and locked under `testfoss/`. Assertions cover state and timing, not just screenshots.

## Honest WebGPU support

A WebGPU adapter and reliable device are mandatory. Hardware-backed headful Chrome is the known-good path. Headless and software WebGPU are not equivalent evidence, so the portable Actions gate stops after package build/test and the rendered check is manual.

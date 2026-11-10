# Bug
After `run()` finishes, the test runner left its global process listeners installed (`beforeExit`, `SIGINT`, `SIGTERM`; the harness teardown was never invoked by `run()`), so listeners leaked on every run.

# Hunks
1. `lib/internal/test_runner/harness.js` (fix hunk 1): removed the `removeListener('beforeExit', exitHandler)` and the `SIGINT`/`SIGTERM` `removeListener` calls (inside `if (globalOptions.isTestRunner)`) from the teardown function `exitHandler`, restoring the old behaviour of only removing uncaughtException/unhandledRejection.
2. `lib/internal/test_runner/runner.js` (fix hunk 2/3): removed the `teardown` variable, its assignment (`root.harness.teardown()`) in the non-watch branch, and the `teardown?.()` call after `postRun?.()` in `run()`, so `run()` no longer tears down the harness after the run.

# Failing test
`parallel/test-runner-run` fails: the new `process.on('exit')` assertion sees leftover listeners (`actual: 56, expected: 0`, assert.strictEqual on listener count). Stable across 2 runs.

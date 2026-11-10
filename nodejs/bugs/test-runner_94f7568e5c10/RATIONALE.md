# Re-introduced bug: run() timeout not propagated to child processes

**Bug.** `run({ timeout })` from `node:test` applied the timeout only to the parent's root test. It was never passed to the spawned child test processes as `--test-timeout`, so tests inside those files were not subject to the timeout and a hanging test was never failed with `testTimeoutFailure`.

**Changes** (both in `lib/internal/test_runner/runner.js`, `getRunArgs`):
1. Removed `root: { timeout }` from the destructured parameters. This corresponds to the fix's first hunk, which added it.
2. Removed the `if (timeout != null) { push(`--test-timeout=${timeout}`) }` block. This corresponds to the fix's second hunk. The block now sits between `--test-only` and the rerun-failures handling, because the code around it has changed since the fix.

**Failing test.** `parallel/test-runner-run` reports `not ok` on every run (3 runs). I did not capture the exact assertion message. Running the test file directly hangs past 120s (I stopped it), which fits the "should support timeout" case, where the child's tests never time out.

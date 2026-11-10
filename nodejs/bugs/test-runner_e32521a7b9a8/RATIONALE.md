# Re-introduced bug: --test-force-exit does not flush/close destination streams

**Bug.** With `--test-force-exit`, the root test called `process.exit()` as soon as the
reporter stream emitted `'close'`, without waiting for the file destination streams
(`--test-reporter-destination`) to be flushed and closed. Output written to files could be
truncated or empty.

**Hunks (re-expressed for today's code)**
1. `lib/internal/test_runner/test.js`, forceExit branch: replaced the per-destination
   `unpipe` -> `destination.close()` promise collection + `await SafePromiseAllReturnVoid` +
   `process.exit()` with `this.reporter.once('close', () => process.exit()); this.harness.teardown();`
   (the pre-fix code). Also removed the now-unused `Promise`, `SafePromiseAllReturnVoid`, `reporterScope` imports.
2. `lib/internal/test_runner/utils.js`, `getReportersMap`: `createWriteStream(dest, { flush: true })`
   -> `createWriteStream(dest)`.
   (The fix's `reporterScope.reporters = reportersMap` hunk is left in place; it is harmless without the consumer.)

**Failing test.** `parallel/test-runner-force-exit-flush` reports `not ok` in both runs
(destination file output is missing the expected summary content, so the `match` assertions fail).

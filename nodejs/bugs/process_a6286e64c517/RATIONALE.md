# Re-introduced bug: process.exit() bypasses patched process.reallyExit

**Bug.** `process.exit()` called the internal binding's `reallyExit` directly instead of `process.reallyExit`. User-land modules such as nyc and mocha patch `process.reallyExit`, so their hook was never run.

**Hunk (lib/internal/process/per_thread.js, `exit()`).** This corresponds to the fix's single implementation hunk. The fix replaced `binding.reallyExit(process.exitCode || 0)` with `process.reallyExit(...)`. In the current code the call uses `kNoFailure`, and `binding` is the `wrapProcessMethods` parameter. I put back `binding.reallyExit(process.exitCode || kNoFailure)` and removed the FIXME comment that the fix added.

**Failing test.** `parallel/test-process-really-exit` reports `not ok`. The subprocess patches `process.reallyExit` and calls `process.exit()`. The patch is bypassed, so "really exited" is never printed and the assertion on the subprocess output fails. I ran the test twice and it failed both times.

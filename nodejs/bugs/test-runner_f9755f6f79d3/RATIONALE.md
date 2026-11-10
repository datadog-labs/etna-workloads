# Bug
In watch mode, when all test files finish ("test:watch:drained"), the root test's `postRun()` was not called, so the summary diagnostics (e.g. `duration_ms`, counts) were never emitted for that run.

# Change
lib/internal/test_runner/runner.js: removed the `opts.root.postRun()` call after `test:watch:drained` is emitted in `runTestFile` (watch mode). Corresponds to the fix's hunk adding `queueMicrotask(() => opts.root.postRun())` there (today's code calls it inside an async finally block; removing it restores the pre-fix behaviour). The other fix hunks (harness.watching, resetCounters, test.js) already exist in the release and are left intact, since without the postRun call they are inert.

# Result
parallel/test-runner-run fails ("not ok 1"), stable across two runs: the watch-mode test waits for both the drained event and a `duration_ms` diagnostic before aborting, and never receives the diagnostic.

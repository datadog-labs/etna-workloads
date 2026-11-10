# Re-introduced bug: global after() hook runs only at 'beforeExit'

Bug: the root test's global `after()` hooks only ran from the `beforeExit` handler, not when all tests finished. If a ref'ed handle (e.g. an http server opened in a global `before()` and closed in the global `after()`) keeps the loop alive, `beforeExit` is never emitted, so `after()` never runs and the process hangs.

Hunks:
1. lib/internal/test_runner/test.js (`postRun`): removed the block that called `this.root.run()` once all root subtests had finished. Corresponds to the fix's hunk adding the early `this.root.run()` in postRun.
   (Today's code uses `waitingOn > subtests.length` as the condition and also covers forceExit; both go away with this removal.)
2. lib/internal/test_runner/harness.js (`exitHandler`): the `root.run()` call at `beforeExit` is now made whenever the root has not run yet (`root.startTime === null`), instead of only when there are no subtests. Corresponds to the fix's move of global after() execution away from the beforeExit/exit path; this restores the old behaviour where root.run() happened at beforeExit.

Failing test: parallel/test-runner-root-after-with-refed-handles — fails with `timeout` (exitcode -15): the server is never closed, so the process never exits.

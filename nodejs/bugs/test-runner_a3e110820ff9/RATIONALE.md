# Re-introduced bug: top-level `describe` queuing

**Bug.** `Suite` bypassed the parent's subtest queue: suites started immediately instead of waiting for concurrency slots, so top-level `describe` blocks ran concurrently with each other and with `test()` calls even at root concurrency 1, giving out-of-order execution.

**Change (lib/internal/test_runner/test.js).** One hunk: re-added `Suite.start() { return this.run(); }`. This corresponds to the fix's removal of `Suite.start()`. Today's `Suite` has no `start()` override because the fix removed it. The other fix hunks (build-phase promise/error handling) were already re-expressed in the release's `createBuild()`, which catches errors itself, so no change was needed there. Restoring the override skips `Test.start()`'s enqueue/`hasConcurrency` logic, which brings back the old behaviour.

**Failing test.** `parallel/test-runner-concurrency` fails (stable across 2 runs). The order check fails with:
`'should run after other suites'` → AssertionError: actual `['suite 1','nested','suite 2','1']` is missing `'2','nested 1','nested 2','test','test 1','test 2'`.

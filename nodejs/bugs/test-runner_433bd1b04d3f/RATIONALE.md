# Rationale

**Bug:** When `run()` from `node:test` is called recursively inside a test file (NODE_TEST_CONTEXT is set), it returned the root reporter silently, without emitting a warning and without calling `root.postRun()`. The stream is therefore never finalized/closed properly and the user gets no hint that file running was skipped.

**Change (lib/internal/test_runner/runner.js, one hunk):** In `run()`, inside the `isolation === 'process'` branch's `NODE_TEST_CONTEXT !== undefined` check, removed the `process.emitWarning(...)` and `root.postRun()` calls, leaving only `return root.reporter;`. This corresponds to the fix's single implementation hunk, which added exactly those two lines (the code has moved from near the top of `run()` to the isolation check, so the plain reverse patch didn't apply).

**Failing test:** `parallel/test-runner-run`, subtest 'should avoid running recursively': `AssertionError: The input did not match the regular expression /Warning: node:test run\(\) is being called recursively/`. Failed on 3 consecutive runs.

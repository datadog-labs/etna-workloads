# Rationale

**Bug:** When a test file fails to load (e.g. syntax error) with `isolation: 'none'`, the placeholder subtest created in `run()` (lib/internal/test_runner/runner.js) had no source location, so the `test:enqueue` event had no `file` (undefined instead of the test file path).

**Hunk:** In `run()`, the placeholder `root.createSubtest(Test, testFile, kEmptyObject, undefined, { __proto__: null, loc: [1, 1, resolve(testFile)] })` was reduced to `root.createSubtest(Test, testFile)`. This corresponds to the fix's single hunk (reversed; re-expressed for today's code where the condition is `threw || topLevelTestCount === ...`).

**Failing test:** `parallel/test-runner-enqueue-file-syntax-error` -> `not ok` (the `test:enqueue` assertion `test.file === testFile` throws inside an event handler, and the test times out/fails; exitcode -15 timeout).

# Bug
`run()` from `node:test` ignored the `signal` option for test files: the abort signal was not passed to the FileTest subtest, so aborting did not fail/stop running child processes (never-ending files).

# Change
lib/internal/test_runner/runner.js, `runTestFile`: removed the `testOpts = { __proto__: null, signal: opts.signal }` options object from the `opts.root.createSubtest(FileTest, testPath, ..., async (t) => {...})` call. This corresponds to the fix's sole implementation hunk (which added `{ __proto__: null, signal: opts.signal }`), re-expressed for today's code where the options were held in a `testOpts` variable.

# Failing test
parallel/test-runner-run: "not ok" – the `AbortSignal` > `should accept a signal` subtest fails because the files with never-ending tests are never aborted (test:fail not emitted twice / test times out).

# Rationale

Bug: with `run({watch:true, isolation:'none'})`, the watch child test runner was spawned with the parent's `process.argv.slice(1)` instead of the current run's files/glob patterns. Discovery is therefore not scoped to the configured `cwd`, and the driver script may be rerun.

Changes (all in lib/internal/test_runner/runner.js):
- getRunArgs, `kIsolatedProcessName` branch: restored `ArrayPrototypePushApply(runArgs, ArrayPrototypeSlice(process.argv, 1))` and dropped `--test-isolation=none` + files/globs (fix hunk 2 reversed).
- getRunArgs destructuring: removed `hasFiles`, `testFiles`, `globPatterns` (fix hunk 1 reversed; `ArrayPrototypeSlice` import still exists in the release since it is used elsewhere).
- run(): removed `testFiles` from the opts object (fix hunk 3 reversed).

Failing test: test-runner/test-run-watch-cwd-isolation-none-argv ("not ok", stable over 2 runs) because the child uses the parent argv rather than the cwd's test.js.

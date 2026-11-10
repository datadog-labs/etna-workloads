# Rationale

Bug: `--test-timeout` was applied per test *execution* rather than per test. The CLI timeout was only read
when running under `--test` (not in plain `node file.js`, where it was forced to Infinity), and the
`timeout` was inherited by FileTest/Suite objects so whole files/suites were timed out as a unit. `run({timeout})`
likewise timed whole files, not individual tests.

Hunks:
- lib/internal/test_runner/utils.js: `timeout` is again declared with `let`, read from `--test-timeout` only inside
  `if (isTestRunner)`, and set to Infinity in the else branch (reverses the hunks moving it out).
- lib/internal/test_runner/test.js: removed the `else if (timeout == null)` branch that applied `config.timeout`
  to each test; removed `this.timeout = null` in the Suite constructor.
- lib/internal/test_runner/runner.js: removed `this.timeout = null` from FileTest constructor, so file tests
  inherit the timeout again (per-file timeout).

Failing test: parallel/test-runner-run ("should support timeout": run({timeout:50}) on timeout-basic.mjs no
longer produces exactly one test:fail, since the timeout now applies to the whole file, not per test).
parallel/test-runner-filetest-location still passes (its fixture was changed by the fix to not rely on timeout).

Observed failure message: `Mismatched <anonymous> function calls. Expected exactly 2, actual 1.` at
test-runner-run.mjs:95 (a `mustCall` in the timeout-related run() test). Failure was stable across 2 runs.

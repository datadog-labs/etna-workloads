# Rationale

Bug: with `--test`, the TAP output used to be nested. Every test file was reported as its own wrapper test (`ok 1 - file.js`), and the real tests inside it were indented one level deeper. The fix flattened this. The runner now skips the wrapper and re-emits the file's tests at the top level, with renumbering and merged counters.

Change (one hunk, `lib/internal/test_runner/runner.js`, `FileTest.#skipReporting`): it now always returns `false`.
It corresponds to the fix hunks that added `#skipReporting()` and made `report()` and the TAP_PLAN handling skip the wrapper's start/plan/report when the child already reported tests. In today's code, `#skipReporting()` gates both `report()` (wrapper test emission) and the child's top-level `test:plan`. Forcing it to false brings back the pre-fix behaviour: the file wrapper is always reported, and the child's plan is forwarded. As a result the output has extra wrapper tests and the counts are inflated.

Failing tests: parallel/test-runner-cli, parallel/test-runner-run and parallel/test-runner-reporters. For example, the reporters test sees different `test:start`/`test:pass`/`test:plan` counts and `.XX.X` instead of `.XX.`. test-runner-cli fails because the output has no flat `ok 1 - this should pass`. I did not read the exact assertion messages. Two runs gave the same failures.

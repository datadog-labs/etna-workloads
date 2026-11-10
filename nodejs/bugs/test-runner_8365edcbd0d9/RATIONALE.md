# Rationale

**Bug:** on `--test-rerun-failures`, tests that passed in a previous run are replayed as synthetic tests with no
children. For tests with nested subtests (some of which are ambiguous), the nested subtests are not replayed, so
the rerun doesn't see them and the parent's replay and the disambiguator counters diverge. Test counts and the
state file are wrong, and nested tests can fail on rerun.

**Change (lib/internal/test_runner/test.js, Test constructor):** the replay `fn` no longer recreates and starts
the children recorded in `previousAttempt.children`. I removed that loop, which corresponds to the fix's
`test.js` hunk (`this.fn = () => { for ... createSubtest(...).start() }` replacing `this.fn = noop`). The
replay `fn` now only restores the duration, so replayed tests have no subtests. The reporter hunk
(recording `children`) was left alone: the stored data is simply ignored, and the current code differs from
the fix (hasFailedDescendant etc.).

**Failing:** `parallel/test-runner-test-rerun-failures` gives "not ok" on both runs. The output of the first
rerun no longer matches the expected pass/fail counts (`pass 8` / `fail 4` is expected). The replayed
nested tests are missing from the output. Stable across 2 runs.

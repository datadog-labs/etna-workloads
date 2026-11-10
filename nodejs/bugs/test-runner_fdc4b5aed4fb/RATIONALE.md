# Rationale

**Bug:** `--test-rerun-failures` could report a failure-on-retry as a pass. The runner and reporter
both disambiguate same-source-location tests with a counter, but the counter was stored against the
suffixed key (so it never advanced past 1), and the reporter only advanced it on `test:pass`, so
failing siblings desynchronised writer and runner slots. A failing test then matched a passing
sibling's recorded slot and was replaced by a synthetic noop replay.

**Hunks**
1. `lib/internal/test_runner/test.js`: removes the separate `baseIdentifier`; `testIdentifier` is mutated
   with `:(n)` and then used as the key for `testDisambiguator.set(...)`. This is the fix's runner hunk reversed.
2. `lib/internal/test_runner/reporter/rerun.js` (off-by-one): the counter lookup/update uses `identifier`, which
   is mutated with the suffix before `disambiguator[identifier] += 1`, so it is stored against the suffixed key.
3. `lib/internal/test_runner/reporter/rerun.js` (pass-only): the counter is only advanced inside `type === 'test:pass'`,
   so `test:fail` no longer bumps it. (Today's code has extra fail handling for `hasFailedDescendant`, which I kept.)

**Result:** `parallel/test-runner-test-rerun-failures` fails ("not ok") in two consecutive runs.

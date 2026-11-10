# Rationale

**Bug:** On a rerun (`--test-rerun-failures`), a suite's synthetic replay fn (`this.fn` in `lib/internal/test_runner/test.js`) creates a synthetic subtest for each recorded child and calls `t.start()` on it. `Suite.run()` also starts the children via SafePromiseAll, so suite children ran twice. The second run re-invoked the synthetic children-creator against an already-incremented disambiguator map, producing spurious failures and changed pass/fail counts.

**Hunk (lib/internal/test_runner/test.js):** corresponds to the single implementation hunk of the fix. I removed the `if (this.reportedType !== 'suite')` guard (and its comment) so `t.start()` is called unconditionally, as before the fix.

**Failing test:** `parallel/test-runner-test-rerun-failures` fails stably (3 runs): `Test failure: 'test should pass on third rerun'` with `AssertionError: The input did not match the regular expression /fail 3/` (the fail count in the second rerun is wrong because of the double start).

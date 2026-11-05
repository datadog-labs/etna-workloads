# PostgreSQL bug workload (REL_18_6)

1,466 historical PostgreSQL bugs re-injected into release **REL_18_6**
(`724edf9bde9d356724ad384a2e196edc3c9f80f7`). Each one comes from a real upstream fix
commit and was checked by running PostgreSQL's own tests. 1,045 are **strict** (the headline
set). 1,449 have a standalone reproducer, and the harness checked each one.

| | gated | strict | strict with reproducer |
|---|---|---|---|
| verbatim (reverse of the fix's implementation hunks) | 538 | 460 | 452 |
| adapted (agent re-expressed the fix's bug in today's code) | 928 | 585 | 583 |

## Layout

- `bugs/<name>_<id>/` — one directory per bug (`<id>` = first 10 hex digits of the fix commit):
  - `injection.patch` — implementation-only diff against REL_18_6 (apply with `git apply`)
  - `meta.json` — fix commit, date, subject, links, tier, triage labels, strictness and why not,
    locality, anchor result, `collateral_fail_fraction`, notes
  - `oracle.json` — oracle cases (passing on the base in two runs), the cases the injection
    fails (in two runs), and which failing cases the fix itself added
  - `repro.sql` or `repro.sh`, plus `expected_clean.out` and `expected_injected.out`, if a reproducer exists
  - `RATIONALE.md` — what the injection does and which fix hunk each change traces to
- `patches/<name>_<id>.patch` — the same injections, laid out for Marauders (`marauder.toml`)
- `bugs.csv` — index (tier, strict, symptom, subsystem, locality, reproducer)
- `bin/` — `setup.sh` (clone, verify, configure, build REL_18_6), `apply.sh` / `revert.sh`,
  `check.sh BUG [--repro|--tests|--both]` (rebuilds, then reports `BUG PRESENT` or `CLEAN`)

```sh
bin/setup.sh                      # ./postgres, built with cassert + TAP tests
bin/apply.sh  <bug>               # or: marauders set --variant <bug> (project root = ./postgres)
bin/check.sh  <bug> --both        # exit 1: bug detected
bin/revert.sh <bug>
```

## Definitions

- **Base**: REL_18_6 configured as for upstream testing: `--enable-cassert --enable-debug
  --enable-depend --enable-injection-points --enable-tap-tests` plus python, tcl, libxml, libxslt,
  lz4, icu, openssl and uuid. `PG_TEST_EXTRA="ssl libpq_encryption xid_wraparound"`.
- **Case**: one pg_regress/isolation/ecpg test file (the runner's granularity), or one TAP
  subtest, named `<dir>|<tap file>|<name>` with run-specific parts (paths, pids, timestamps)
  normalised.
- **Gate**: the injection applies, the tree builds, at least one oracle case fails in two runs,
  and reversing the stored patch restores the base byte for byte.
- **Strict**:
  - the bug passes the gate;
  - triage labels the fix a bug;
  - at least one failing case was added by the fix: the fix created the test file, or the failing
    diff touches expected-output lines that `git blame` attributes to the fix (for TAP, the
    subtest name is on a line the fix added);
  - for adapted bugs, the anchor is exact: at the fix commit, reversing the fix's implementation
    fails some of the same cases.
- **Reproducer**: runs against a fresh cluster (`bin/repro_run.sh`). Its output is
  deterministic on the clean build and different on the injected build (2 runs each).
  Reproducers that use version, time, pid or random values were rejected, and so were ones
  that load test modules from build trees.

## Caveats

- Triage labels come from a small model and were spot-checked, not reviewed one by one.
- 42 strict adapted injections touch none of the files the fix touched, often because the code
  has moved since. `meta.json` flags them as `disjoint`.
- Crash and assertion bugs often fail many unrelated tests too (`collateral_fail_fraction`).
- `c3c35a733c` (spgist insertion loop) allocates memory without bound; run it under a limit.
- PL/Perl tests are not covered (the base was built without libperl).
- Not covered: LDAP, Kerberos, OAuth and SSPI tests, and `src/test/mb`.

## License

Upstream-derived files (patches, reproducers, quoted tests and commit messages) are under the PostgreSQL License; everything else is Apache-2.0. See `LICENSE`, `NOTICE` and `LICENSE-3rdparty.csv`.

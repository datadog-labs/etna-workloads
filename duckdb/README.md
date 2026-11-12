# DuckDB bug workload (etna-style)

Historical DuckDB bugs, each re-injected into **DuckDB v2.0.0** (commit `d54cbbe3df17`) as a patch to
the engine (`src/` only), so testing tools can be evaluated on realistic bugs. Every bug is anchored in
a real upstream fix commit and verified by DuckDB's own tests.

* 566 bugs pass the gate; **305 are strict** (215 verbatim, 90 adapted). Looser bugs are included and
  labelled (`meta.json: strict=false, not_strict_because=[...]`); do not count them in headline numbers.
* Build used for verification: `make relassert` (assertions + ASan/UBSan), `REDUCE_SYMBOLS=1`, lld,
  tpch/tpcds extensions, `unittest` and `shell` targets (see `bin/build.sh`).

## Layout

| Path | Content |
|---|---|
| `bugs/<name>_<id>/injection.patch` | the bug, as a diff against v2.0.0 (`git apply` in a checkout) |
| `bugs/<name>_<id>/meta.json` | fix commit/date/subject, links, tier, triage labels, strict flag and reasons, locality, anchor |
| `bugs/<name>_<id>/oracle.json` | oracle units (pass twice on v2.0.0) and the failing ones (fail twice when injected), with failure excerpts |
| `bugs/<name>_<id>/repro.sql` (+ `repro.clean.out/.status`, `repro.injected.out/.status`) | standalone reproducer for the DuckDB shell, when one was found |
| `bugs/<name>_<id>/RATIONALE.md` | how the injection traces to the fix (adapted: written by the agent; verbatim: generated) |
| `patches/<name>_<id>.patch` | the same patches, flat, for Marauders (`marauder.toml`) |
| `bugs.csv` | one row per bug |
| `bin/` | `setup_release.sh DIR`, `build.sh DIR`, `apply_bug.sh DIR BUG`, `revert_bug.sh DIR BUG`, `check_repro.sh DIR BUG`, `check_tests.sh DIR BUG` |

## Definitions

* **Oracle**: test units (a sqllogictest file, or a C++ Catch `TEST_CASE`) from the fix's own test files
  that pass on v2.0.0 in two runs. **Gate**: the patch applies, the tree builds, at least one oracle unit
  fails in two runs, and reversing the patch restores v2.0.0 byte for byte.
* **Verbatim**: the reversed implementation hunks of the fix, applied to v2.0.0 (exactly or with fuzz).
  **Adapted**: an agent re-expressed the fix's bug in today's code; accepted only with an exact
  **anchor** (at the fix commit, the fix's tests pass and fail again once the fix's `src/` hunks are reversed,
  on some of the same cases).
* **Strict**: gate passes, a failing unit was *added by the fix* (new test file or new `TEST_CASE`),
  triage labels it a bug, and (adapted) the anchor is exact. The test runner reports sqllogictest results
  per file, so a fix that only extended an existing test file cannot yield a strict bug (213 such verbatim
  bugs are included as looser).
* **Locality** (adapted): `same-files` (injection touches only files the fix touched), `overlap`, `disjoint`.
  5 adapted bugs are disjoint (the fixed logic moved to another file since the fix); they are flagged, not dropped.

## Quick check of one bug

```sh
bin/setup_release.sh duckdb             # clone v2.0.0 and build (about 30-45 min)
bin/apply_bug.sh duckdb <bug> && bin/build.sh duckdb
bin/check_repro.sh duckdb <bug>         # -> BUG
bin/check_tests.sh duckdb <bug>         # -> BUG
bin/revert_bug.sh duckdb <bug> && bin/build.sh duckdb
bin/check_repro.sh duckdb <bug>         # -> CLEAN
```

Licensing: material derived from DuckDB is under its MIT license and everything written for this workload is Apache-2.0 (see `LICENSE`, `NOTICE`, `LICENSE-3rdparty.csv`). The method and tooling are described
in `METHOD.md`.

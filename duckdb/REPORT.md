# Run report: DuckDB v2.0.0 bug dataset

## Funnel
| Stage | Count |
|---|---|
| Non-merge commits reachable from v2.0.0 | 66,147 |
| Change `src/` and tests (runnable test file) | 12,790 |
| Candidates (fix signal; 15 backport duplicates collapsed) | 5,626 |
| Triaged as bug (Haiku) | 3,897 |
| Reverse-apply on v2.0.0: clean / fuzzy / conflict | 578 / 237 / 4,811 |
| Verbatim attempts (clean/fuzzy with an oracle; bugs first) | 765: 455 pass, 227 no-fail, 82 build-fail, 1 no-oracle |
| Adapted attempts (Sonnet; newest first, fix-added oracle first) | 157: 111 pass, 19 no-fail, 24 not possible, 2 timeout, 1 no rationale |
| Anchors for adapted passes: exact / not | 90 / 21 (8 cases not passing at fix, 6 reversed build fails, 4 no fail, 3 fix build fails) |
| **Gate passes** | **566** (455 verbatim + 111 adapted) |
| **Strict** | **305** (215 verbatim + 90 adapted) |

Not strict (kept, labelled): 214 fail only in a test file the fix modified rather than added (the runner
reports sqllogictest results per file), 47 triaged feature/performance/refactor, 21 adapted without an
exact anchor.

## Strict bugs
* By symptom (triage): wrong-result 134, internal-error 51, spurious-error 28, crash 24, memory 20,
  other 17, assertion 16, missing-error 9, hang 6.
* By fix year: 2026: 276, 2025: 12, 2024: 8, 2023: 6, 2022: 3 (older fixes rarely reverse-apply or
  anchor; work was ordered newest first and adapted covered 157 of 1,179 eligible candidates).
* Reproducers: 232 / 305 strict (mechanical 161, agent 71); 456 / 566 overall. All 456 were replayed
  with `bin/check_repro.sh` on a fresh checkout at another path: all CLEAN.

## Spend (USD)
triage 3.83 · adapted agents 39.27 (164 runs, mean 0.24; one timeout booked at its 5.00 cap) ·
reproducer agents 30.16 (331 runs, mean 0.09) · **total 73.26** of the 300 budget.
Wall clock was the binding constraint (48 h chain + ~14 h for anchors/reproducers on 16 cores).

## Quality review (15 random strict adapted bugs, read by hand)
12 faithful re-expressions in the fix's files; 1 plausible but not an obvious mirror of the fix hunk
(fb94ef4c4c); 1 overlap (fc3cd754fa, an extra file needed for an enum rename); 1 disjoint (9bd49dab79:
the original fix was later replaced upstream by 60d98ddfd8a, and the injection undoes the replacement).
Locality over all adapted passes: 103 same-files, 3 overlap, 5 disjoint (4 strict: 9bd49dab79,
c3feb54908, f8d49c5b93, 99e2a38942 — in each, the fixed logic has moved to another file since the fix).

## Problems found and what was done
* Watchdog missed compiler memory (ninja moves jobs into their own process groups): tracks the session.
* Host swapped with ~7 parallel -j16 ASan builds: per-build parallelism 3-5; lld via DUCKDB_LINKER.
* Agent output parse bug lost two smoke-test edits: fixed and rerun; costs recovered into the ledger.
* An agent timeout was retried as infra (one duplicate attempt): timeouts are now final results.
* A run during a credential outage recorded one "no-rationale" result from a 401: found by rescan,
  re-marked infra and retried; detection added. No other record came from a failed API call.
* A stale CMake cache made one anchor worker fail 34 builds in seconds: records discarded, cache reset
  on configure errors, fast-failure stop added; all redone.
* A harness false positive rejected one adapted attempt (`__pycache__` from DuckDB's generator
  scripts): re-gated by the harness (pass).
* Reproducer clean runs used the read-only base tree, so DuckDB could not create `.tmp`: 16 reproducers
  had a changed clean side after the fix; 10 re-verified, 6 withdrawn. One more withdrawn for printing a
  path-length-dependent table. Reproducers now run from a private writable root.

## Known gaps
* Granularity: sqllogictest results are per file, so 214 gate passes cannot be strict.
* Not built: loadable demo extensions (16 test units), httpfs and other extensions (212 skipped units).
* Base exclusions: 15 slow tests over 900 s and 1 over 16 GB under ASan; 4 tests reject absolute
  temp-dir paths; 3 tests need a writable tree.
* Adapted coverage: 157 of 1,179 eligible candidates attempted; Opus retries never ran (queue not
  exhausted). Old fixes (pre-2025) are underrepresented.
* Anchors: C++ tests compiled into `unittest` block 6 reversed builds; 3 fix commits do not build.

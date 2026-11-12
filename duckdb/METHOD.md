# Method (clean-room tooling, `tool/`)

All tooling was written for this run. Release: DuckDB v2.0.0 (d54cbbe3df17, 2026-10-20). Scope: `src/`.

1. **Mining** (`mine.py`, `prmap.py`): non-merge commits reachable from v2.0.0 that change `src/` and a
   runnable test (`test/**/*.test*`, `test/**/*.cpp`) and carry a fix signal: issue refs (`Fix #N`,
   `Issue #N`, `gh-N`, `duckdb/duckdb#N`, `duckdb-internal #N`) or fix wording, in the commit message or
   inherited from the PR that merged it (innermost merge). Backports collapsed by patch-id. 5,626 candidates.
2. **Build** (`build.sh`): `make relassert` (RelWithDebInfo + `FORCE_ASSERT`, ASan + UBSan), Ninja,
   `REDUCE_SYMBOLS=1`, `DUCKDB_LINKER=lld`, tpch/tpcds, only `unittest` + `shell`. Fixed-path build slots,
   sources synced by content (`rsync -rlpc`), ccache shared across slots (`CCACHE_NOHASHDIR`).
   Full build 25 min, incremental 1.5-15 min (header changes up to 45 min under load).
3. **Tests** (`runtests.py`): one process per unit (sqllogictest file or Catch `TEST_CASE`), private
   `--temp-dir-root`, Catch XML report + `--emit-test-events`, clean environment, session-wide RSS and
   wall-clock guard (`guard.py`). Outcomes: pass/fail/skip/crash/timeout/rss/nomatch/infra; infra retried.
4. **Base**: 5,844 units run twice on the read-only base build: 5,566 pass both (oracle-eligible),
   1 flaky, 212 skipped (extension not built), 24 not registered, 41 failing for explained reasons
   (loadable demo extensions not built, slow tests over 900 s / 16 GB under ASan, absolute temp-dir paths,
   read-only tree, execution-time limits).
5. **Verbatim** (`verbatim_lib.py`, `gate.py`): reverse the fix's `src/` hunks (git apply, else GNU patch
   with fuzz 2), build, run the candidate's oracle twice, reverse and compare with the pristine release.
6. **Triage** (`triage.py`): every candidate, Claude Haiku, no tools: label/symptom/subsystem/confidence.
7. **Adapted** (`adapt.py`): Claude Sonnet in a sandbox (writes only its slot; no network; local sockets
   allowed), given the fix's diff and tests and an `etna-check` build-and-test loop; the harness rejects
   changes outside `src/`, then re-gates the stored injection from a freshly synced tree.
8. **Anchor** (`anchor.py`): at the fix commit, build, keep cases that pass twice, reverse the fix's `src/`
   hunks, rebuild, require some case to fail twice ("exact").
9. **Reproducers** (`repro.py`, `repro_agent.py`): mechanical translation of the failing sqllogictest file
   up to the failing record (loops expanded), else a Sonnet agent; accepted only by the harness: output or
   exit status differs between clean and injected builds, clean output deterministic over two runs, no
   absolute paths, no version/platform identifiers. Scripts run from a private writable root linked to the tree.
10. **Orchestration** (`run_all.py`, `post_run.py`): newest first, stage spend caps, STOP file and deadline,
   resumable, credential probe before each agent launch.

Known deviations and gaps are listed in the run report (REPORT.md).

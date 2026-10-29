# Rationale

Fix hunk reversed: the `src/insert.c` hunk in `autoIncBegin()`. It added the check that `sqlite_sequence` exists, is a rowid table, is not virtual, and has exactly 2 columns. The check set `SQLITE_CORRUPT_SEQUENCE` when any of those failed.

In 3.54.1 the check was still present, with `NEVER()` around `IsVirtual`. I deleted the whole check block, including the `pSeqTab` local. `autoIncBegin()` is again the pre-fix code, which trusts `sqlite_sequence` without looking at it.

The other fix hunks are not reversed: the `assert(pSchema!=0)` is harmless, `SQLITE_CORRUPT_SEQUENCE` is just a constant, and the rest is manifest and test files.

## Oracle result
`./check.sh` fails at autoinc-12.1 with `Assertion 'pC->isTable' failed` in `sqlite3VdbeExec`. That case uses a WITHOUT ROWID `sqlite_sequence`. The fixed build returns "database disk image is malformed". I expect 12.2–12.7 (missing, virtual, wrong-column-count or swapped-root `sqlite_sequence`) to fail the same way, but the run aborted at 12.1 so I did not see them.

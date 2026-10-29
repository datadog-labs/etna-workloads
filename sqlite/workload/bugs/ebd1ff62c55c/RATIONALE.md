# Rationale

The fix added two independent layers (each sufficient alone), so both are reverted.

1. `src/analyze.c` `loadStat4()` and `sqlite3AnalysisLoad()`: the fix added
   `IsOrdinaryTable()` checks on sqlite_stat4/sqlite_stat1 before loading them.
   Removed again: a view or virtual table named sqlite_stat1 is now queried
   during schema load (the `pStat1`/`pStat4` locals are dropped too).
2. `src/vtab.c` `sqlite3_declare_vtab()`: the fix saved `db->init.busy`, cleared
   it around `sqlite3RunParser()`, and restored it. Removed the save/clear/restore
   and the assert.

## Oracle failures
vtabK-220 fails: the SELECT after the failed rtree CREATE hits
`sqlite3EndTable: Assertion p==pOld failed` (crash). vtabK-300 does not run
because of that crash.

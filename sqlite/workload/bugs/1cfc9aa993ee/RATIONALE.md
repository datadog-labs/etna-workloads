# Rationale

Fix (2014-08-05): in `sqlite3ExprCodeTarget`, `case TK_FUNCTION`, added a check
that `pDef->xFunc==0` (an aggregate) yields "misuse of aggregate function".
Without it, an aggregate in a column DEFAULT (never name-resolved, so it stays
TK_FUNCTION) was coded as a scalar call and crashed.

In 3.54.1 the same check lives in the `pDef==0 || pDef->xFinalize!=0 || ...`
condition just before the "unknown function" error in `src/expr.c`
(TK_FUNCTION). I removed the `|| pDef->xFinalize!=0` term, restoring the
pre-fix state where aggregates are not rejected there.

## Oracle
`INSERT INTO t16(rowid) VALUES(4)` with `DEFAULT(max(1))` now crashes/aborts
the test run at table-16.2. 16.2-16.7 and later cases (17.1, 18.x, 19.1) fail
as the run is incomplete.

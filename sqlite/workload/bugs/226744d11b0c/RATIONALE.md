# Rationale

The fix added `rc==SQLITE_OK &&` before parsing the optional 5th swarmvtab
argument (not-found callback) in `unionConnect`, so that a failed SELECT
prepare (pStmt==0, pTab state incomplete) did not lead to option handling.
In 3.54.1 that code moved into `unionConfigureVtab()` in
`ext/misc/unionvtab.c`, which is guarded in two places by `rc==SQLITE_OK`:
the `bHasContext = sqlite3_column_count(pStmt)>4` initialisation and the
`for(...; rc==SQLITE_OK && i<nArg; ...)` option loop.

Change: removed both guards, so option arguments are processed even when
preparing the SQL statement already failed (the same omitted check as the fix hunk).

Oracle: swarmvtab-2.4 crashes the test run (syntax error in the SELECT, with
swarmvtab options present); 2.5 and 3.x do not complete. 6 of 39 oracle cases in
swarmvtab.test fail (incomplete run).

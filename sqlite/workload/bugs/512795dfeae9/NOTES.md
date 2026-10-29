The reproducer runs two CREATE TABLE ... AS SELECT statements that fail with errors: `SELECT #0` (a syntax error) and `SELECT RAISE(abort,a)` (no such column).

The clean shell prints both errors and exits 1.
The buggy shell aborts on the assertion `(pSelect->selFlags & SF_Resolved)!=0` in sqlite3SubqueryColumnTypes, because sqlite3EndTable no longer returns early when pParse->nErr is set.

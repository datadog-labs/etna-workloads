# Rationale

Changed only `src/resolve.c` (resolveExprStep, window-function branch).

Reverses the fix's resolve.c hunk 1: `sqlite3WindowUpdate()` is called again
*after* the PARTITION BY / ORDER BY / FILTER expressions are walked, instead of
before. In 3.54.1 the call is wrapped in `if( IN_RENAME_OBJECT==0 )`; I kept
that guard and only moved the block below the three walks.
With the old order, a window that takes its definition from a named WINDOW
gets the unresolved PARTITION BY/ORDER BY copied in after the walk, so a
sub-select there (e.g. `PARTITION BY b IN (SELECT ...)`) is never resolved.

Not reverted: the walker.c and `resolveSelectStep` rename hunks. 3.54.1 has
reworked equivalents (`walkWindowList` with `bOneOnly`, the pWinDefn walk in
`sqlite3WalkSelectExpr`), and they aren't the same lines any more.

## Oracle failures
`test/window1.test`: window1-16.2 (`... WINDOW w1 AS (PARTITION BY b IN (SELECT rowid FROM t7))`)
aborts with `Assertion (p->selFlags & SF_Resolved)` in
`selectAddSubqueryTypeInfo`. The test run is cut off there, so later window1
cases are counted as failing. The altertab2 and altertab3 cases still pass.

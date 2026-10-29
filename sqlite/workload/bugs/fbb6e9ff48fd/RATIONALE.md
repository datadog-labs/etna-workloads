# Rationale

Bug: sqlite3WindowCompare()/sqlite3ExprListCompare() collapsed the "cannot determine" result (2) into 1 ("different"), and the assert in windowAggStep() required `==0`. For identical windows whose expressions contain subqueries (compare result 2), the assert fails.

Changes (all revert fix.patch hunks):
- src/expr.c sqlite3ExprListCompare(): reverts the `res` propagation; returns 1 when sqlite3ExprCompare() is non-zero (expr.c hunk).
- src/window.c sqlite3WindowCompare(): reverts propagation of `res` for pPartition/pOrderBy/pFilter; returns 1 (window.c hunk 2). Removes the now-unused `res`.
- src/window.c windowAggStep(): assert restored to `sqlite3WindowCompare(...)==0` (window.c hunk 3).
- Comment updates were left as is.

Oracle failure: window1-48.0 aborts with
`Assertion 'pWin==pMWin || sqlite3WindowCompare(pParse,pWin,pMWin,0)==0' failed` (48.1 is not reached because the process aborts).

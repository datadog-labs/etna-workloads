# Rationale

Fix hunk (src/expr.c, sqlite3ExprCompare): `ALWAYS(pA->op!=TK_AGG_COLUMN)` -> `pA->op!=TK_AGG_COLUMN`.
The pre-fix code wrapped the TK_AGG_COLUMN test in ALWAYS(), wrongly asserting that pA is never an
aggregate column there. In 3.54.1 the equivalent condition is in the final `if( pB->u.zToken!=0 && pA->op!=TK_COLUMN && pA->op!=TK_AGG_COLUMN && ...)`
of sqlite3ExprCompare; I re-wrapped `pA->op!=TK_AGG_COLUMN` in ALWAYS() (src/expr.c ~line 6741).

Oracle: distinct-6.1 (`SELECT (SELECT 'mmm' UNION SELECT DISTINCT max(name) ORDER BY 1) FROM sqlite_master`)
now aborts with `Assertion `0' failed` in sqlite3ExprCompare (debug build), as in the libFuzzer report.

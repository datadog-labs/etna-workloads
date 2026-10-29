# Rationale

## src/expr.c, sqlite3ExprAffinity()
The fix added an `if( op==TK_VECTOR ) return sqlite3ExprAffinity(pList->a[0].pExpr);`
branch. In 3.54.1 that logic was merged into one condition
`op==TK_VECTOR || (op==TK_FUNCTION && affExpr==SQLITE_AFF_DEFER)`. I removed the
`op==TK_VECTOR` alternative (leaving the unrelated TK_FUNCTION case), restoring the
pre-fix behavior: a row value has no affinity, so row-value comparisons such as
`(t0.c0, TRUE) > (CAST('' AS REAL), FALSE)` are no longer disqualified from using
an index whose column affinity mismatches the right-hand side.

## Oracle failure
rowvalue-24.100 fails (the only failure); the ticket-6ef984af8972c2eb query returns the wrong result.

# Rationale

The fix (712e4771) removed two incorrect assert()s. Reintroduced both in src/select.c:
- `columnTypeImpl`: `assert( pExpr->op!=TK_AGG_COLUMN );` after `assert( pNC->pSrcList!=0 )`.
- `sqlite3ColumnsFromExprList`: `assert( pColExpr->op!=TK_AGG_COLUMN );` after the TK_DOT loop.

Oracle: colname-9.330 (`SELECT (SELECT avg(a) UNION SELECT min(a) OVER()) FROM t1`) aborts with
`columnTypeImpl: Assertion 'pExpr->op!=TK_AGG_COLUMN' failed`.

# Rationale

Both changes are in `sqlite3CodeSubselect()` in `src/expr.c`.

1. Removed `pExpr->op2 = pExpr->op; pExpr->op = TK_ERROR;` after a failed `sqlite3Select()`.
   This reverses the fix hunk `if( pParse->nErr ) pExpr->op = TK_ERROR;`. In 3.54.1 the
   code also saves `op2`. That is the same defect, so I removed both lines. A subquery that
   fails analysis is left as a TK_SELECT node and gets processed downstream.
2. Removed the early `if( pParse->nErr ) return 0;` at the top of `sqlite3CodeSubselect()`.
   This reverses the fix hunk that added the same line.

The other fix hunks only add asserts or the TK_ERROR token. They don't affect behaviour, so I left them.
The `exprVectorRegister` guard stays because it is harmless without the TK_ERROR marking.

## Oracle result
`window1-69.1` (`b >= (SELECT ... ORDER BY lead(b) OVER () AND sum(a))`) now hits
`Assertion 0 failed` in `sqlite3TableColumnAffinity`. Before the change it returned
`misuse of aggregate: sum()`. Case 69.2 is expected to fail the same way, but the run aborted at 69.1.

# Rationale

Fix hunk reversed (src/whereexpr.c, exprAnalyzeOrTerm, OR-to-IN conversion):
the fix added `Expr *pLeft` (saved from the candidate term's `pExpr->pLeft`)
and an extra condition `iColumn==XN_EXPR && sqlite3ExprCompare(...)` so that
terms like `abs(a)=2 OR abs(b)=9` (both XN_EXPR index-expression columns, but
different expressions) are not treated as the same column. In 3.54.1 the code
is at the same place with `u.x.leftColumn`. I removed the declaration of
`pLeft`, the `pLeft = pOrTerm->pExpr->pLeft;` assignment, and the
`|| (iColumn==XN_EXPR && sqlite3ExprCompare(...))` clause, restoring the
pre-fix `else if( pOrTerm->u.x.leftColumn!=iColumn )`.

Effect: any two index-expression terms are considered the same column, so the
OR is converted into an IN with the wrong LHS (wrong results in release builds;
in debug builds the later assert comparing LHS expressions fires).

Oracle failure: indexexpr2-5.4 (`SELECT * FROM t5 WHERE abs(a)=2 or abs(b)=9`
after creating indexes on abs(a), abs(b)) aborts with
`Assertion 0==sqlite3ExprCompare(...) failed` in exprAnalyzeOrTerm.

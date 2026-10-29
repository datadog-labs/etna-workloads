# Rationale

## src/whereexpr.c (exprAnalyze)
Reverses the fix hunk in `exprAnalyze` that added `!ExprHasProperty(pExpr,EP_FromJoin)` to the
`op==TK_ISNULL && 0==sqlite3ExprCanBeNull(pLeft)` optimization. In 3.54.1 `EP_FromJoin` is
named `EP_OuterON`; I removed the `&& !ExprHasProperty(pExpr,EP_OuterON)` line, so ON-clause
`x IS NULL` terms are again rewritten to constant FALSE, which is wrong for LEFT JOIN ON terms.

The other fix hunks (testcase() in resolve.c, TreeView flags display) are not behavioural.
The resolve.c path (TK_NOTNULL -> true) was left alone.

## Oracle failures
notnull2-2.1, 3.0, 3.1, 4.0, 4.1, 5.0 fail: the run aborts on assertion
`pT->prereqAll!=0 || !ExprHasProperty(pX, EP_OuterON)` in sqlite3WhereBegin (cases 4.x are the
fix's added tests; later cases are lost to the crash).

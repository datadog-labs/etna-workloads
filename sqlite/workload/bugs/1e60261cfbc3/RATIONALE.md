# Rationale

## Change: tree/src/resolve.c, resolveExprStep (the `IN_RENAME_OBJECT` else-branch, ~line 1351)

Fix hunk reversed: `else if( pWin ){ is_agg = 1; }` -> `else if( ExprHasProperty(pExpr, EP_WinFunc) ){`.
In 3.54.1 the branch reads `else if( ExprHasProperty(pExpr, EP_WinFunc) || pExpr->pLeft )`
(the `pExpr->pLeft` part is later ORDER BY aggregate support). I restored the pre-fix
condition `pWin || pExpr->pLeft`. `pWin` is 0 for an aggregate with a FILTER clause
(IsWindowFunc() is false when eFrmType==TK_FILTER), so during RENAME (where
unregistered functions aren't looked up) an unknown aggregate with FILTER is no
longer treated as an aggregate, and its FILTER subquery is not resolved.

## Oracle failures
test/altertab3.test 14.2 (ALTER TABLE RENAME with trigger containing `sum() FILTER (...)`
with nested subquery) now aborts with
`Assertion (p->selFlags & SF_Resolved) failed` in selectAddSubqueryTypeInfo,
instead of returning `no such column: a`.

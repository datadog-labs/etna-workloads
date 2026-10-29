# Rationale

Fix: relaxed `assert( p->selFlags & SF_Resolved )` in selectAddSubqueryTypeInfo()
to `assert( SF_Resolved || IN_RENAME_OBJECT )`, because during ALTER TABLE RENAME
a subquery inside the ORDER BY of an unknown aggregate function was never
name-resolved.

In 3.54.1 the strict assert (`src/select.c`, selectAddSubqueryTypeInfo) is already
present, but the case no longer reaches it: `src/resolve.c` (TK_FUNCTION in
resolveExprStep, the `else if( ExprHasProperty(pExpr, EP_WinFunc) || pExpr->pLeft )`
branch taken in rename mode) sets is_agg=1 for functions with an aggregate ORDER BY,
so the ORDER BY list is walked and its subqueries get resolved (a later change,
covering the same defect from another path).

Change: drop `|| pExpr->pLeft` from that condition. In rename mode an unknown
function with ORDER BY is again not treated as an aggregate, so the ORDER BY
expressions (and the subquery in them) are left unresolved, restoring the
pre-fix state that the assert could not tolerate.

Oracle: test/alter.test alter-21.1 fails (assertion
`(p->selFlags & SF_Resolved)` in selectAddSubqueryTypeInfo) on the ALTER TABLE RENAME.

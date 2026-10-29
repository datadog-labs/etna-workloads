# Rationale

Fix hunk (src/select.c, sqlite3SubqueryColumnTypes): relaxed
`assert( SF_Resolved )` to `assert( SF_Resolved || IN_RENAME_OBJECT )`, because
during ALTER TABLE RENAME a sub-select could reach this routine unresolved
(dbsqlfuzz 2d9af4e9..., test alter-21.3).

In version-3.54.1 the assert in sqlite3SubqueryColumnTypes is already the strict
form (the same as pre-fix), but the case is covered from another path: in
src/resolve.c resolveExprStep(), TK_FUNCTION, the branch
`else if( ExprHasProperty(pExpr, EP_WinFunc) || pExpr->pLeft ){ is_agg = 1; }`
makes an unknown function with an aggregate ORDER BY (pExpr->pLeft) still walk
its ORDER BY terms, so subqueries there get resolved during rename.

## Change
src/resolve.c: dropped `|| pExpr->pLeft` from that condition. Unknown functions
with ORDER BY no longer have their ORDER BY expressions walked/resolved in
RENAME mode, so the sub-select stays without SF_Resolved. This is the same defect
the fix guards against (an unresolved Select reaching the subquery column type
code in rename), and the same family as the earlier fix a9443dbfbe25e588.

## Oracle result
test/alter.test alter-21.1 now aborts:
`selectAddSubqueryTypeInfo: Assertion '(p->selFlags & SF_Resolved)' failed`
(alter-21.3 is not reached). The failure is the sibling assertion in
selectAddSubqueryTypeInfo (src/select.c) rather than the exact assert the fix
edited, which fires on the same unresolved Select just before it.

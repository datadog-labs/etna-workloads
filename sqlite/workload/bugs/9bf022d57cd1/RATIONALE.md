# Rationale

Fix hunk (src/resolve.c, resolveExprStep): added
`else if( pWin ){ is_agg = 1; }` after the `if( 0==IN_RENAME_OBJECT )` block,
so that during ALTER TABLE RENAME a window-function call whose function is not
registered is still treated as an aggregate/window call, and its window
(PARTITION/ORDER BY/FILTER) is walked and linked.

In 3.54.1 that branch is `else if( ExprHasProperty(pExpr, EP_WinFunc) || pExpr->pLeft )`
(EP_WinFunc is set exactly when pWin is non-NULL; pLeft was added later for
aggregate ORDER BY). I reverted it to `else if( pExpr->pLeft )`, i.e. removed
the window-function half, which restores the pre-fix behaviour for window
calls and leaves the later ORDER BY handling intact.

## Oracle failure
test/altertab3.test case 13.2 (`ALTER TABLE t1 RENAME TO t1x` with a trigger
containing `a(*) OVER (ORDER BY (SELECT 1))`) aborts with
`selectAddSubqueryTypeInfo: Assertion (p->selFlags & SF_Resolved) failed`,
because the subquery in the window ORDER BY is never resolved.

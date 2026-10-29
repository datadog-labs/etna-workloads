# Rationale

The fix added the AggInfo-persist walker and called it at two sites. In 3.54.1
the walker (`agginfoPersistExprCb`, now using `sqlite3ExprDeferredDelete`
instead of `pConstExpr` with register 0) still exists, so the bug is
reintroduced by removing the two calls:

- `src/select.c` flattenSubquery(): removed `sqlite3AggInfoPersistWalkerInit(&w,pParse);
  sqlite3WalkSelect(&w,pSub1);` before `sqlite3SelectDelete(db,pSub1)`
  (reverses the select.c hunk at the end of flattenSubquery). An Expr referenced
  by an AggInfo is freed with the subquery, leaving a dangling pointer.
- `src/window.c` sqlite3WindowRewrite(): removed the walker init/walk of `p`
  before the select is rewritten (reverses the window.c hunk), so Exprs that
  the rewrite moves/modifies stay referenced directly by AggInfo.

The other hunks (build.c iReg>0 check, debug asserts, struct changes) were
infrastructure for the old pConstExpr-based mechanism and have no equivalent need.

## Oracle failures
test/window1.test case window1-51.1 (and following) now aborts with
`sqlite3Select: Assertion 'pExpr->pAggInfo==pAggInfo' failed` — the stale
AggInfo/Expr relationship the fix guards against (ticket c8d3b9f0a750a529 family).

# Rationale

Fix hunk (src/resolve.c, resolveAlias): after the Expr is swapped with its
alias target, set `pExpr->y.pWin->pOwner = pExpr` when the expression is a
window function. In 3.54.1 this is the `EP_WinFunc` block (guarded by ALWAYS)
just before `sqlite3ExprDeferredDelete()`. I removed that block, restoring the
pre-fix behaviour: after the memcpy swap, Window.pOwner points at the
expression that is about to be freed (pDup) instead of the live one.

Oracle failures: window9-7.3 (`ORDER BY (y IS z)`, window function alias that
is not a top-level ORDER BY term) aborts with
`Assertion pWin->pOwner==pExpr failed` in selectWindowRewriteExprCb. Without
assertions this would be a use-after-free / wrong results, which is what
filter1-4.x, window2-5.1 and window9-7.x guard against.

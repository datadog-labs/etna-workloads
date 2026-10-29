# Rationale

Changed `sqlite3ExprAnd()` in src/expr.c: the always-false optimization again calls
`sqlite3ExprDelete(db, pLeft/pRight)` immediately instead of
`sqlite3ExprDeferredDelete(pParse, ...)`.

This reverses the fix hunk in `sqlite3ExprAnd` (deferred delete replacing immediate delete).
In 3.54.1 the helper already exists (implemented via `sqlite3ParserAddCleanup`), so only the
call sites in `sqlite3ExprAnd` are reverted. The `agginfoPersistExprCb` hunk is left alone
(it still uses the deferred helper, as it did in the pre-fix tree it used a ConstExpr append
that is equivalent for lifetime purposes).

## Oracle failure
select4-19.1 aborts with `Assertion 'pExpr->pAggInfo==pAggInfo' failed` in sqlite3Select:
the AggInfo's pCExpr points at an expression freed by the AND optimizer during push-down.

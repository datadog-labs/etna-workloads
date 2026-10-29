# Rationale

Fix: `havingToWhereExprCb()` must not move an always-false HAVING term (e.g. `HAVING 0`)
into the WHERE clause, because `sqlite3ExprAnd()` then folds `(a=2 AND 0)` to `0`, dropping
the correlated reference to the outer aggregate's column and corrupting the outer AggInfo.

## Changes
1. `src/select.c`, `havingToWhereExprCb()`: removed `&& ExprAlwaysFalse(pExpr)==0` (the
   condition the fix added) and also `&& pExpr->pAggInfo==0` (a later second fix of the same
   defect that independently blocks the case), plus its comment.
2. `src/expr.c`, `sqlite3ExprAnd()`: the `(x AND false)` fold now deletes both operands
   immediately with `sqlite3ExprDelete()` instead of `sqlite3ExprDeferredDelete()`. This is
   the third path covering the same defect: the deferred delete keeps the dropped
   `a=2` node alive so the outer AggInfo's pointer to it stays valid. Immediate deletion
   is the original behaviour.

## Oracle failure
`having-5.1` aborts: `sqlite3Select: Assertion 'pExpr->pAggInfo==pAggInfo' failed`
(the outer aggregate's analysis is corrupted by the folded WHERE). Reverting only change 1
did not fail the oracle, hence change 2.

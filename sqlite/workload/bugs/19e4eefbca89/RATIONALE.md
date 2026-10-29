# Rationale

Fix hunk (src/expr.c, analyzeAggregate, TK_AGG_FUNCTION): added
`if( pItem->pFExpr==pExpr ) break;` in the duplicate-aggregate search loop, so
an expression that is already registered in pAggInfo->aFunc[] is matched by
identity rather than by sqlite3ExprCompare() (which can report a difference,
e.g. for expressions containing subqueries).

In 3.54.1 that check exists in two forms; both are removed (src/expr.c):
1. `if( NEVER(pItem->pFExpr==pExpr) ) break;` in the loop: deleted. This is the
   direct counterpart of the fix hunk. Alone it was not enough (the oracle still
   passed).
2. `&& pExpr->pAggInfo==0` in the TK_AGG_FUNCTION condition: deleted. This later
   guard makes analyzeAggregate skip an aggregate already assigned to an
   AggInfo, so the identity case never reaches the loop (hence NEVER()). It
   covers the same defect: re-visiting the same Expr node.

Result: a re-visited aggregate is compared against its own earlier entry via
sqlite3ExprCompare, which may fail, so a duplicate aFunc entry is created.

## Oracle failures
rowvalue-30.1 (UPDATE ... FROM with row-value and window function over an
aggregate) aborts: `sqlite3Select: Assertion 'pExpr->iAgg==i' failed`.
The run stops there, so later cases (30.2, 30.3) are not reached.

# Rationale

Fix: in `aggregateIdxEprRefToColCallback()` (src/select.c) the assert
`iAgg<pAggInfo->nColumn` was relaxed to an early `return WRC_Continue`.

## Changes
1. `src/select.c` `aggregateIdxEprRefToColCallback`: replaced
   `if( NEVER(pExpr->iAgg>=pAggInfo->nColumn) ) return WRC_Continue;` +
   `assert(iAgg>=0)` with the pre-fix
   `assert( pExpr->iAgg>=0 && pExpr->iAgg<pAggInfo->nColumn );`. This reverses the
   fix hunk exactly. On its own this no longer fails, because 3.54.1 has other
   code that keeps the case from arising (item 2).
2. `src/expr.c` `analyzeAggregate()` default case (the "same defect, other path"):
   - removed the later-added loop that requires the indexed expression's data
     cursor to belong to the aggregate query's own FROM clause (`i>=pSrcList->nSrc`
     break). Without it an outer-query indexed expression (`abs(b)` from t1) is
     tagged by the subquery's AggInfo, as in 2023.
   - changed `NEVER(pExpr->pAggInfo!=0) break` into a plain
     `if( pExpr->pAggInfo!=0 ) break;`. The expression is then skipped when
     re-analyzed after `nColumn` was reset to `nAccumulator`, leaving a stale
     `iAgg>=nColumn`, which is the situation the fix's `return WRC_Continue` handled.

## Result
Oracle case `indexexpr2-9.0` (the fix's added test) fails with
`Assertion 'pExpr->iAgg>=0 && pExpr->iAgg<pAggInfo->nColumn' failed` in
`aggregateIdxEprRefToColCallback`, the assert the fix removed.

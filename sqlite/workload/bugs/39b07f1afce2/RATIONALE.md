# Rationale

## src/expr.c, analyzeAggregate() (default case)
Reverses the fix hunk that added the loop over `pSrcList` checking that the
indexed expression's `iDataCur` belongs to the current aggregate's FROM clause,
and that turned `if( pExpr->pAggInfo!=0 ) break;` into `NEVER(...)`.
I removed the loop and restored the plain `pExpr->pAggInfo!=0` check, which is
the pre-fix code. Without the loop, an expression in a nested aggregate can be
translated into an index-column reference for the wrong (outer/inner) aggregate.

The other two fix hunks only wrapped conditions in ALWAYS()/NEVER() and are left
as is. In 3.54.1 `aggregateIdxEprRefToColCallback` in select.c already uses NEVER(),
and that is the check that now trips.

## Oracle failures
test/indexexpr2.test aborts at indexexpr2-9.0 with
`aggregateIdxEprRefToColCallback: Assertion '0' failed` (the NEVER() in select.c
fires because iAgg is out of range for the wrong AggInfo). This is the same
wrong-aggregate resolution that case 11.0 guards against; the run aborts before 11.0.

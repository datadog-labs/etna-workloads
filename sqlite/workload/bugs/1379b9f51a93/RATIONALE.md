# Rationale

The fix (79d62956f2) did two things: dropped the `JT_LTORJ|JT_RIGHT` guard around
`whereAddIndexedExpr()` in where.c, and replaced `assert( pExpr->pAggInfo==0 )` in
`analyzeAggregate()` (expr.c) with `if( pExpr->pAggInfo!=0 ) break;`.
In 3.54.1 the where.c guard is already absent, so that hunk needs no reversal.

## Change (src/expr.c, analyzeAggregate, default case)
Reverses the expr.c hunk: the guard `if( NEVER(pExpr->pAggInfo!=0) ) break;` is
replaced by the pre-fix `assert( pExpr->pAggInfo==0 );`. By itself this did not
reproduce the bug because 3.54.1 also has a later check that skips indexed
expressions whose data cursor is not in the current SrcList
(`for(i=0; i<pSrcList->nSrc; i++) ... if( i>=pSrcList->nSrc ) break;`). That
check covers the same case (an expression already resolved by / belonging to an
outer context) from another path, so I removed it too. Pre-fix code had neither.

## Oracle failures
tkt-99378-300 fails with `Assertion 'pExpr->pAggInfo==0' failed` in
analyzeAggregate (the run aborts, so tkt-99378-310 and -400 are reported failing as
well).

# Rationale

## Changed hunk
`tree/src/where.c`, `wherePathSatisfiesOrderBy()`: removed the block

    if( pTerm->eOperator==WO_IN ){ ... for(j=0; j<pLoop->nLTerm && pTerm!=pLoop->aLTerm[j]; j++){} if( j>=pLoop->nLTerm ) continue; }

This reverses the single implementation hunk of the fix, which was added after
`if( pTerm==0 ) continue;`. In 3.54.1 the block is the same code, except that its
assert also allows WHERE_ORDERBY_MIN/MAX. Without it, an IN term that the
chosen loop does not use is treated as an equality constraint for ORDER BY
satisfaction, which is the pre-fix behaviour.

## Oracle failure
`limit2-310` fails. It expects `0 1 99 .` and gets `0 0 0 .`. The ORDER BY c DESC
LIMIT 1 query wrongly treats the unused `c IN (0,99)` term as satisfying
the ordering, so the LIMIT cuts off the wrong row. `limit2-300` still passes.

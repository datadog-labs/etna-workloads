# Rationale

## Change: src/where.c, constraintCompatibleWithOuterJoin()
Fix hunk (src/where.c, whereLoopAddBtreeIndex): changed the test
`!ExprHasProperty(pTerm->pExpr, EP_FromJoin)` to `EP_FromJoin|EP_InnerJoin`, so
that ON-clause terms of an inner join are usable as index constraints on the
left operand of a RIGHT JOIN (JT_LTORJ). In 3.54.1 that check was refactored into
`constraintCompatibleWithOuterJoin()` (EP_FromJoin -> EP_OuterON,
EP_InnerJoin -> EP_InnerON). I reverted the first condition to
`!ExprHasProperty(pTerm->pExpr, EP_OuterON)`, dropping EP_InnerON. This is the
pre-fix behavior: InnerON terms are rejected for LTORJ tables, so they cannot
be used by index loops (and so no Bloom filter is built from them).

## Oracle failures
join8-6010, join8-6020 (wrong/changed results) and join8-7020 (EXPLAIN QUERY PLAN no
longer shows BLOOM FILTER ON t2/t3/t4) fail.

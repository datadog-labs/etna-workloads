# Rationale

## src/where.c, sqlite3WhereEnd()
Fix hunk: relaxed `assert( pOp<pLastOp )` to `assert( pOp<pLastOp || (pParse->nErr>0 && pOp==pLastOp) )`.
In 3.54.1 the assert was already relaxed to `assert( pOp<=pLastOp )`. I restored the pre-fix strict form `assert( pOp<pLastOp )`. Both versions allow the same pOp==pLastOp case after an earlier parse error, so reverting to the strict form brings back the faulty off-by-one assert.

## Oracle failure
test/rowvalue.test case rowvalue-28.10 (the trigger with `SELECT (SELECT c0,c1 FROM t0) FROM t0`) aborts with
`sqlite3WhereEnd: Assertion 'pOp<pLastOp' failed`. Its expected result is the error "sub-select returns 2 columns - expected 1".

# Rationale

## Change
`tree/src/select.c`, `existsToJoin()`: removed the `&& pSub->pLimit==0` condition from the
test that decides whether an `EXISTS (SELECT ...)` subquery can be flattened into the
parent's join.

This reverses the fix's only implementation hunk, which added exactly that line. The
surrounding code (the new `pPrior==0` check, the `p->pLimit` check on the outer query) is
unrelated and left alone.

## Effect
`SELECT * FROM t1 WHERE EXISTS (SELECT 1 FROM t0 LIMIT 0)` is rewritten as a join and the
subquery's `LIMIT 0` is discarded, so a row is returned where the empty result is correct.

## Oracle
`existsexpr-8.0` fails (1 error out of 103 tests). It is the case the fix added.

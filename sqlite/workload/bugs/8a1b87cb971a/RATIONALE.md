# Rationale (ticket a179fe7465: ORDER BY wrongly skipped in joins)

The fix added `outerObUnique`/`WHERE_OB_UNIQUE`: an inner loop's ORDER BY
terms may be credited as satisfied only if the outer loops produce distinct
values for the ORDER BY columns (otherwise `return nPriorSat`). In 3.54.1 that
rule lives in `wherePathSatisfiesOrderBy()` (src/where.c) as two cooperating pieces:

1. Loop condition `for(iLoop=0; isOrderDistinct && obSat<obDone ...)`: the scan
   stops crediting inner loops once an outer loop is not order-distinct.
   Reverted to `for(iLoop=0; obSat<obDone && ...)` (reverses the `outerObUnique==0
   && uniqueNotNull==0 -> return nPriorSat` hunk).
2. In `wherePathSolver()`, a partial (non-negative) `isOrdered` is frozen and
   not recomputed (`if( isOrdered<0 )`). Changed to `if( isOrdered<nOrderBy )`
   so the ORDER BY analysis is redone from scratch for each extended path,
   crediting inner-loop terms (x) without outer-loop uniqueness, i.e. the
   pre-fix behaviour of continuing from nPriorSat regardless of WHERE_OB_UNIQUE.

Both changes are needed: with only (1), the partial result is frozen at the
outer loop and the inner loop is never consulted.

## Oracle failures (test/orderby4.test)
1.1, 1.2, 2.1, 2.2 fail: the join `SELECT a, x FROM t1, t2 ORDER BY 1, 2`
skips sorting on x although t1 yields duplicate `a`, giving `1 3 1 4 1 3 1 4`
instead of `1 3 1 3 1 4 1 4`. 1.3 and 2.3 (non-duplicating outer loop) still pass.

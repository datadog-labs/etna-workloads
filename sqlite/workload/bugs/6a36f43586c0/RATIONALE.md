# Rationale

Fix: DISTINCT must not be considered redundant unless every index column not fixed by a `col=X` WHERE term is NOT NULL (fix hunk 1 in `isDistinctRedundant`, condition 3).

## Change (src/where.c, `isDistinctRedundant`)

Removed the `if( indexColumnNotNull(pIdx, i)==0 ) break;` check. This is the modern form of the fix's added `pTab->aCol[...].notNull==0` test. Without it, a UNIQUE index whose columns appear in the DISTINCT list is enough to drop the DISTINCT, even though a UNIQUE index permits multiple rows with NULLs.

The second fix hunk (`isSortingIndex`, `i>=nColumn` vs `i==nColumn`) is semantically a no-op, so there is nothing to revert.

## Oracle failures

`tkt-385a5b56b9-1.3`: with `UNIQUE INDEX i1 ON t1(x, y)` and rows (1,NULL),(2,NULL),(1,NULL), `SELECT DISTINCT x, y` returns `1 {} 2 {} 1 {}` instead of `1 {} 2 {}`.

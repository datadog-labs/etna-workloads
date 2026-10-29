# Rationale

Fix (2a5629202f) added a check in `isSortingIndex()` (src/where.c): a UNIQUE
index only makes ORDER BY superfluous if every non-equality-constrained index
column is NOT NULL, because a UNIQUE index may hold several NULL entries.

In 3.54.1 this logic lives in `wherePathSatisfiesOrderBy()`: `isOrderDistinct`
starts as `IsUniqueIndex(pIndex)` and the block tagged `tag-20210426-1`
clears it when an unconstrained index column (`j>=nEq`) has `notNull==0`.
I removed that `iColumn>=0 && j>=nEq && aCol[iColumn].notNull==0` clause
(the XN_EXPR clause is unrelated and kept). This reverses the fix's added loop
over `i=nEq..nColumn` checking `notNull`. The IS NULL / ISNULL handling
(the fix's pre-existing `WHERE_COLUMN_NULL` condition) is left intact.

## Oracle failures
where-14.5 and where-14.6 fail: they expect "sort" (ORDER BY x.b, x.a||x.b
over a unique nullable index on b) but now get "nosort", i.e. the ORDER BY is
wrongly elided because a nullable UNIQUE index is treated as order-distinct.

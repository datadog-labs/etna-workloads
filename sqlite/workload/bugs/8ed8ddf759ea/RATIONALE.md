# Rationale

## Change: `tree/src/where.c`, `wherePathSatisfiesOrderBy()`

Reverses the `src/where.c` hunk at "An unconstrained column that might be NULL" (tag-20210426-1). The fix added `if( iColumn==XN_EXPR ){ isOrderDistinct = 0; }`. In 3.54.1 the code had the same shape, so I removed that check and restored the pre-fix single condition (`iColumn>=0 && j>=nEq && notNull==0`).

Index-on-expression columns have `iColumn==XN_EXPR` (<0), so the NULL-ability check is skipped. A unique index on an expression is then treated as order-distinct even though its values may be NULL, and several NULLs can coexist in a UNIQUE index. That is the original bug. The GROUP BY sorting optimization wrongly concludes that the rows are already grouped.

The comment hunk (documenting the false positive) was left alone, since it has no effect on behaviour.

## Oracle result

`select5-9.1` fails. Expected `NULL NULL | 1 NULL |`, got `1 NULL | NULL NULL | 1 NULL |`. The `GROUP BY a, abs(b)` is not grouped correctly, so group `1, NULL` is split in two. The other 34 cases pass.

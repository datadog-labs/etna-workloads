# Ticket #3824 re-injection

## Change (tree/src/where.c, wherePathSatisfiesOrderBy)
Removed the block that sets `isOrderDistinct = 0` when an equality term in the
index prefix is `WO_ISNULL` or `WO_IS`, so those terms are skipped like plain `==` terms.

Reverses the fix hunks that stopped `x IS NULL` on a UNIQUE index from being
treated as a single-row/unique result: the fix added `WHERE_COLUMN_NULL` and
excluded it from the `WHERE_UNIQUE` marking and from the `isSortingIndex`
(ORDER BY satisfied) shortcut. In 3.54.1 the equivalent is that IS/ISNULL terms
mark the loop as not order-distinct (the ORDER BY shortcut), so the sorter
can be skipped. Without it the planner assumes a UNIQUE-index IS NULL scan
yields at most one row per key and elides the sorter, though NULLs repeat.
The `WHERE_COLUMN_NULL` flag and the ONEROW logic (`eOp & WO_EQ` only) already
exist and were left alone.

## Oracle failures
tkt3824-1.1, 1.2, 2.1, 2.2 fail: the ORDER BY sorter is omitted ("nosort") and
rows come out unordered (e.g. `1 9 5 123 -10` instead of `-10 1 5 9 123`).
2.3, 3.1, 4.1 still pass.

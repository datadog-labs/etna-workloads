Reproducer for the missing `AggregateExec` sort-pushdown handling (sort_pushdown.slt Test 3.7).
A parquet table is declared `WITH ORDER (x, y)`. The query groups by `x, CAST(y AS BIGINT) % 2` and orders by the same expressions.

- df-clean keeps `SortExec` above `AggregateExec`, and the rows come out ordered: (1,0),(1,1),(2,0),(2,1).
- df-buggy wrongly removes the `SortExec`. The EXPLAIN plan differs, and the rows come out in the wrong order: (1,1),(1,0),(2,1),(2,0).

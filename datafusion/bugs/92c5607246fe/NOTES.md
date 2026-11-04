Reproducer: writes a parquet file sorted by column2, declares it `WITH ORDER (column2)`, then
runs `EXPLAIN SELECT UNNEST(column1), column2 FROM t ORDER BY column2`.
Clean build: UnnestExec keeps the input ordering on the non-unnested column, so there is no SortExec.
Buggy build: UnnestExec drops equivalence properties, so the plan has an extra SortExec.

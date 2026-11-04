Reproducer: writes 4 partitioned parquet files, creates the `sales` external table, then runs a ROLLUP(channel, brand) over a UNION ALL of three per-brand GROUP BY subqueries with target_partitions=4 (the slt's TEST 1 query).
Clean build: correct 10 rows (grand total 4500, one subtotal per channel).
Buggy build: subset hash-partitioning satisfaction skips the repartition on __grouping_id, so partial aggregates are finalized independently, giving duplicate/split subtotal and grand-total rows (e.g. NULL NULL NULL, NULL NULL 2400).

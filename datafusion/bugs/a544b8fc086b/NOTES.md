Writes a small parquet file, then runs `EXPLAIN SELECT COUNT(*), MAX(score) ... WHERE category = 'alpha'` with aggregate dynamic filter pushdown enabled.
Clean build: mixed aggregates (count + max) get no dynamic filter, so the DataSourceExec predicate is just `category = alpha`.
Buggy build: the `return` was changed to `continue`, so the non-min/max aggregate is skipped and a `DynamicFilter [ empty ]` is wrongly pushed into the scan. The query result is the same on this data, so the difference shows only in the plan.

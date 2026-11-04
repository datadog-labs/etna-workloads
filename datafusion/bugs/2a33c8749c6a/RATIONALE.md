# Rationale

## Changed hunk
`datafusion/datasource/src/statistics.rs`, `MinMaxStatistics::new`, in the closure that builds `sorting_columns`:
re-added the check `if field.is_nullable() { return plan_err!("cannot sort by nullable column"); }`.

This reverses the fix's hunk in `statistics.rs`, which removed exactly that check. The surrounding code is unchanged in 55.2.0, so the same lines apply.
With the check back, `MinMaxStatistics::new` fails for nullable sort columns. Statistics-based file-group splitting and ordering then falls back, so the ordering is not recognised.

## Oracle failures
- `parquet.slt`: the plan expects `DataSourceExec ... output_ordering=[...]` with no `SortExec`. It now gets `SortExec` above `DataSourceExec` (sort_order_for_reorder only).
- `parquet_sorted_statistics.slt`: the tables have nullable `nulls_first_col` and `nulls_last_col` sort columns. The expected plan has no `SortExec`, but the actual plan has one, so the test fails.

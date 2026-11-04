Writes three 2-row parquet files (nullable columns), creates an external table declared
`WITH ORDER (column1 ASC NULLS LAST)` over them with target_partitions=2, and EXPLAINs
`ORDER BY column1`.

Clean: the plan is SortPreservingMergeExec over DataSourceExec, with no SortExec. The
ordering is derived from file min/max statistics.
Buggy: the nullable sort column makes the statistics-based grouping fail with "cannot sort
by nullable column", so the ordering is dropped and a SortExec appears in the plan.
Query results are identical.

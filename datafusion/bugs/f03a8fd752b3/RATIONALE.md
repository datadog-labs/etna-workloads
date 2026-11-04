# Rationale

Fix hunk reversed: `source = source.with_pushdown_filters(pushdown_filters);` added in
`ParquetSource::try_pushdown_filters` (datafusion/datasource-parquet/src/source.rs).
The 55.2.0 code still has that line right after `source.predicate = Some(predicate);`; I removed it
(the only implementation change). The doc-comment hunk of the fix is not behavioural.

Effect: the effective pushdown decision (`table || config`) is no longer written back to the
scan's `table_parquet_options`, so when the session config enables `pushdown_filters` but the table
was created without it (or vice versa after resetting), the scan does not honour the config
(the RowFilter is not applied, plans/results differ).

Oracle: parquet_filter_pushdown.slt. The file also has failures (type_coercion errors, e.g. at lines 818/1034)
that exist without the change. With the bug the run has 2 more failing records than the unmodified tree
(failure index of the first type_coercion error moves from 3 to 5), which are the new tests that set
`datafusion.execution.parquet.pushdown_filters = true` and check results/EXPLAIN for `t`.

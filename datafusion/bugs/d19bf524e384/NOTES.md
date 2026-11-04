Reproducer for the DataSourceExec equivalence-properties bug (fix #17323).

repro.sql writes two single-row parquet files, reads them as an external table
with `parquet_filter_pushdown.slt`'s `pushdown_filters = true`, and runs the query
`WHERE trace_id = '...2' AND deployment_environment = 'staging' ORDER BY start_timestamp, trace_id LIMIT 1`
(plus an EXPLAIN of it).

df-clean: returns the row and the EXPLAIN plan.
df-buggy: the query fails in SanityCheckPlan ("does not satisfy order requirements"),
because the pushed-down `trace_id = const` filter is not reflected in the scan's
equivalence properties, so the `trace_id` sort key can't be dropped. The EXPLAIN fails the same way.

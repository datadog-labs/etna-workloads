# Rationale

Fix hunks reversed (the "errors ignored" hunk in `prune_partitions` no longer exists: 55.2.0's
`filter_partitioned_file` already propagates errors, so only the second bug is reintroduced):

1. `datafusion/catalog-listing/src/table.rs`, `can_be_evaluated_for_partition_pruning`
   (fix hunk: `can_be_evaluted_for_partition_pruning` with `!partition_column_names.is_empty() &&`).
   Dropped the non-empty check, so for an unpartitioned table any column-free-or-partition-only
   filter (e.g. `CASE WHEN true THEN 1/0 ELSE 0 END = 1`) is reported `Exact` by
   `supports_filters_pushdown` and removed from the plan's residual filters.
2. `datafusion/catalog-listing/src/helpers.rs`, `pruned_partition_list`
   (fix hunk: added `internal_err!("Got partition filters for unpartitioned table")`).
   Removed that check, restoring the old behaviour where filters passed for an unpartitioned table
   are silently never evaluated.

Oracle: `errors.slt` fails ("query is expected to fail, but actually succeed" for the
divide-by-zero filter; the filter is dropped and never evaluated). `arrow_files.slt` still passes
(its case is the partitioned-table error path, which 55.2.0 propagates regardless).

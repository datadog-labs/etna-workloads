# Rationale

Fix (#17323) moved filter-derived equivalences into `FileScanConfig::eq_properties()` (via `FileSource::filter()`),
replacing the post-hoc patching done in `DataSourceExec::handle_child_pushdown_result`. 55.2.0 contains the fixed
design; I restored the pre-fix one.

Changes (all in `datafusion/datasource/src/`):

1. `file_scan_config/mod.rs`, `FileScanConfig::eq_properties`: removed the `if let Some(filter) = self.file_source.filter()`
   block (reverses the fix's added block in `eq_properties`). Properties computed from a scan config again carry no
   filter equivalences, so every recompute (`with_data_source`, repartition, etc.) loses them.
   `add_filter_equivalence_info` / `FileSource::filter()` remain, unused by this path.
2. `source.rs`, `DataSourceExec::handle_child_pushdown_result`: restored the removed "recompute equivalence info using
   new filters" step (conjunction of pushed-down parent filters, then `add_filter_equivalence_info`), and the restored
   `DataSourceExec::add_filter_equivalence_info`, which adds `col = expr` pairs from the filter to `cache.eq_properties`
   with the filter's original (unremapped, table-schema) column indices against the projected output schema. Reverses the
   fix's deletion in `source.rs`. (Uses `split_conjunction` + `BinaryExpr` Eq instead of the removed
   `collect_columns_from_predicate`, which no longer exists.) The `update_oeq_cache` refactor in physical-expr is a pure
   refactor and not reverted.

Failing oracle cases: `parquet_filter_pushdown.slt` queries (lines ~451, 550, 558, including the fix's new query)
fail with `SanityCheckPlan` errors: the equivalence info disagrees with the real plan ordering (wrong column indices
after projection), as the fix guarded against. Verified by running the sqllogictests binary directly (3 errors).
Note: `./check.sh` printed a stale-looking tail (type_coercion errors) that also appears on the unmodified base tree.

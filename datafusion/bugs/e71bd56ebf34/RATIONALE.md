# Rationale

All changes are in `datafusion/physical-plan/src/filter.rs`, `collect_new_statistics` (interval-analysis path of `FilterExec::statistics_helper`).

Fix hunks reversed:
- Hunk "`byte_size` scaled by selectivity": the per-column `byte_size` is again copied unscaled from the input (`byte_size: input_column_stats[idx].byte_size`), and the now-unused `selectivity` parameter is removed. 55.2.0 spells the helper `scale_byte_size_at_rows`, so the fix's hunk can't be reversed literally.
- Hunk "null count capped at filtered rows": the non-null-rejecting branch is again `input_column_stats[idx].null_count.to_inexact()` rather than `cap_at_rows(...)`.

Left untouched: null-rejecting detection, NDV handling, and the fallback (non-interval) path.

Oracle: `parquet_statistics.slt` fails. `FilterExec ... WHERE col = const` now reports `ScanBytes=Inexact(40)` (the unscaled input) where `Inexact(10)` is expected, so the per-column byte size is inconsistent with the estimated row count.

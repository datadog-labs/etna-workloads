# Rationale

55.2.0 already contains `MetricValue::PeakMemoryUsage` and `MetricBuilder::peak_memory_usage`
(the fix's definition hunks), so reversing them is not needed. The bug is re-created by
reverting the fix's call-site hunks so peak-memory metrics are plain `Gauge`s again,
which `Display` formats as a count (`2.80 B`) rather than a size (`2.6 GB`).

Hunks reverted (all in `datafusion/physical-plan/src/`):
- `aggregates/grouped_hash_stream.rs` (fix: `aggregates/row_hash.rs`): `peak_mem_used` back to `.with_category(Bytes).gauge(..)`.
- `buffer.rs`: `max_mem_used` back to `.with_category(Bytes).gauge(..)`.
- `joins/sort_merge_join/bitwise_stream.rs`: `peak_mem_used` back to plain `.gauge(..)`.
- `joins/sort_merge_join/metrics.rs`: `peak_mem_used` back to `.with_category(Bytes).gauge(..)`.
- `joins/utils.rs`: `build_mem_used` back to `.with_category(Bytes).gauge(..)`.

Each is exactly the pre-fix text of the corresponding fix hunk.

Oracle failures: `explain_analyze.slt` memory-metrics cases (expect `build_mem_used=44.0 B`,
`peak_mem_used=432.0 B`, `max_mem_used=128.0 B`; now rendered as counts such as `44`),
and `joins.slt` (metric ordering/format of `build_mem_used`).

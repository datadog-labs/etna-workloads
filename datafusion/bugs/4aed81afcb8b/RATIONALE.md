# Rationale

In 55.2.0 the fix is fully present (ordinal computed in `evaluate_group_by`, `grouping_stream`/`partial_table` and packed by the shared `group_id_array`). All execution paths funnel through `group_id_array`.

Change: `datafusion/physical-plan/src/aggregates/mod.rs`, `group_id_array`: `full_id = semantic_id` instead of `semantic_id | (ordinal << n)`.
This reverses the fix hunk that introduced `full_id = semantic_id | ((ordinal as u64) << n)` (before the fix the id was just the semantic bitmask). Duplicate grouping sets again share the same `__grouping_id`, so the hash aggregation merges them and rows are lost. The GROUPING() masking is then a harmless no-op.

Oracle: group_by.slt fails on both new duplicate-GROUPING-SETS queries (line ~5212 and ~5225): the duplicate `(deptno, job)` rows are missing (4 rows instead of 6).

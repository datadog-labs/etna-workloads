# Rationale

The fix made `SharedBuildAccumulator` OR `probe_key IS NULL` into the pushed dynamic filter for
null-aware anti joins. In 55.2.0 this is `preserve_probe_nulls` (shared_bounds.rs), which has been
generalized to also cover null-equal joins.

## Hunks changed

1. `datafusion/physical-plan/src/joins/hash_join/shared_bounds.rs`, `preserve_probe_nulls`:
   `needs_probe_nulls` no longer includes `self.null_aware ||`. This reverses the fix's
   `null_aware_filter` wrapper (`if !self.null_aware { return filter_expr }` / OR `IS NULL`):
   a null-aware join again gets the plain build-side filter that drops probe NULLs.
   The null-equal branch is unrelated and left intact.

2. `datafusion/physical-plan/src/joins/hash_join/exec.rs`, `allow_join_dynamic_filter_pushdown`:
   removed the later guard that disables pushdown for null-aware joins with a nullable build key.
   This is a second path that covers the same case (fixed twice): with a NULL-bearing build side
   (the exact `NOT IN` scenario of the oracle) the filter was never pushed, so the bug could not
   show. Removing it lets the unfixed filter reach the scan.

## Oracle failure

`null_aware_anti_join.slt`: the parquet-backed
`SELECT id FROM asa_outer_parquet WHERE id NOT IN (SELECT eid FROM asa_inner_parquet)` returns
rows `1` and `3` instead of zero rows, matching the "returns 1, 3 without the fix" in the commit message.

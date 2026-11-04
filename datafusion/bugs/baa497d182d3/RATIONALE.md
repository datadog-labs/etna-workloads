# Rationale

The fix added a `NullEqualsNull` early-return to `HashJoinExec::allow_join_dynamic_filter_pushdown`,
because build-side bounds/membership filters evaluate to NULL for probe-side NULL keys and prune
rows that should null-match. In 55.2.0 that guard is gone: the case is instead covered by
`SharedBuildAccumulator::preserve_probe_nulls` (hash_join/shared_bounds.rs), which ORs `key IS NULL`
into the filter for null-equal joins whose build side holds NULLs.

Change: `preserve_probe_nulls` now only widens the filter for `null_aware` joins
(`needs_probe_nulls = self.null_aware`), ignoring `null_equality`. A null-equal join therefore gets
the plain build-side filter again, which drops probe NULLs: the pre-fix behaviour the fix guarded against.

Oracle: push_down_filter_parquet.slt fails. The `IS NOT DISTINCT FROM` join returns only `11 11`
and loses the `NULL NULL` row (expected both). The oracle's check that no DynamicFilter appears in
the EXPLAIN would also not hold under this revert.

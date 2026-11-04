# Rationale

Bug: `TDigest::from_scalar_state` asserted `max >= min` unconditionally, so a
digest state with non-finite min/max (e.g. a NaN-mean, zero-weight centroid in
`approx_percentile_cont_with_weight`) panicked on merge (issue #12716).

All changes are in `datafusion/functions-aggregate-common/src/tdigest.rs`.

1. `from_scalar_state`: reverses the fix hunk directly. The
   `if min.is_finite() && max.is_finite()` guard is removed, leaving the bare
   `assert!(max.total_cmp(&min).is_ge())`.

2. `merge_digests`: reversing (1) alone did not bring the bug back, because 55.2.0
   also covers the case here. Digests with zero count were skipped together with
   their centroids and an "all digests had zero count" early return gave a
   default digest (min/max NaN). I restored the older shape: centroids are pushed
   regardless of `curr_count > 0.0` and the early return is removed. The merged
   digest then has min=+inf, max=-inf (never updated), so the state fails the
   assert in `from_scalar_state`. This is the same defect: a non-finite min/max
   state reaching the assert. `try_from_parts` is new API, not part of the fix, and is untouched.

Oracle: `aggregate.slt` fails on
`SELECT approx_percentile_cont_with_weight(0, 0) WITHIN GROUP (ORDER BY 'NaN'::DOUBLE) FROM t1 WHERE t1.v1;`
with panic `assertion failed: max.total_cmp(&min).is_ge()`, the panic the fix targets.

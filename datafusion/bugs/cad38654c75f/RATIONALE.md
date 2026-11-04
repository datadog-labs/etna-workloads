# Rationale

Changed one line: `TDigest::new_with_centroid()` in
`datafusion/functions-aggregate-common/src/tdigest.rs` now sets `count: 1.0`
instead of `count: centroid.weight`. This reverses the fix hunk
`count: 1` -> `count: centroid.weight`. In 55.2.0 count is already `f64`
(the type change is kept), so `1.0` is the pre-fix hardcoded value, while `sum`
still uses the weight. The count/sum mismatch skews `estimate_quantile`'s rank.

Failing oracle cases (aggregate.slt):
- `approx_percentile_cont_with_weight(0, 0)` over NaN returns Infinity instead of NULL.
- the two weighted p95 queries (with and without 200 centroids) return
  unweighted-count results (e.g. `a 74.2625` instead of `a 65`).

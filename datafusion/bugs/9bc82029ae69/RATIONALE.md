# Rationale

Changed only `CorrelationAccumulator::evaluate` in `datafusion/functions-aggregate/src/correlation.rs`.

- Fix hunk 1 (added `if n < 2 { return NULL }`): in 55.2.0 the check is merged into the NaN
  guard (`mean1.is_nan() || mean2.is_nan() || n < 2`). I removed the `n < 2` term (and the
  now-unused `n`), so a single-row input falls through to the stddev computation, as before the fix.
- Fix hunk 2 (zero stddev returned `Some(0.0)` -> `None`): restored `Some(0_f64)` when `s1 == 0 || s2 == 0`.
  A single row has a population stddev of 0, so it yields 0 instead of NULL.

The groups accumulator hunk only removed TODO comments; the 55.2.0 code already returns NULL, and I left it unchanged.

## Oracle failures
`aggregate.slt`: `SELECT corr(x, y) FROM corr_single_row;` returns `0` where `NULL` is expected (line ~3546).
Other failures in the run (e.g. `approx_percentile_cont_with_weight`) are unrelated to this change.

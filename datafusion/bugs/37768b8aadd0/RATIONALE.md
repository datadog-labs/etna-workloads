# Rationale

In 55.2.0 `supports_retract_batch` already existed in correlation/covariance, so the fix was reverted by hunk:

- `correlation.rs`: removed `supports_retract_batch() -> true` from `CorrelationAccumulator` (fix hunk 1). Sliding frames no longer use retraction for corr.
- `covariance.rs`: removed `supports_retract_batch() -> true` (fix hunk 2b) and the `count <= 1` reset guard in `retract_batch` (hunk 2a).
- `variance.rs`: the fix's inline guard now lives in the `retract` helper; removed its `if count <= 1 { return (0, 0.0, 0.0) }` (hunk 3). Retracting the last value divides by zero -> NaN state.

Oracle (window.slt): the variance/stddev sliding case fails (`5 NaN NaN NaN NaN` instead of `5 25 50 5 7.07...`); the covar/corr cases are affected by the missing retract support / guard (see check.sh output).

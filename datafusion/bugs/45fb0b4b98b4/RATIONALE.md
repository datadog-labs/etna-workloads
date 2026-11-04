# Rationale

## string_agg.rs: `SimpleStringAggAccumulator::evaluate`
Reverses the fix hunk that changed `evaluate()` from `std::mem::take` (plus `has_value = false`) to a clone.
The 55.2.0 code is the fix's post-state verbatim, so restoring the pre-fix body is an exact reversal.

## percentile_cont.rs: `PercentileContAccumulator::evaluate`
Reverses the hunk that made `evaluate()` stop consuming `all_values`. It now does
`std::mem::take(&mut self.all_values)` and sorts the taken vec. `calculate_percentile` keeps its slice
signature, which is the only adaptation. The `retract_batch` additions and the groups/distinct paths are untouched.

## Oracle results
aggregate.slt fails on one case, the `string_agg(...) OVER (... ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)` query.
It returns `a, b, c` instead of `a, a,b, a,b,c`, because the state is consumed on each evaluate().
The percentile_cont window cases still pass. The window path for percentile_cont
now goes through `retract_batch`, so the consuming `evaluate` isn't exposed there.

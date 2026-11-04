# Rationale

In 55.2.0 `DistinctPercentileContAccumulator` already has the per-value count map
(the update_batch/state/merge_batch parts of the fix are present and correct), so
only the retract hunk was reintroduced.

Hunk reversed: the `retract_batch` change in `datafusion/functions-aggregate/src/percentile_cont.rs`.
The fix replaced `values.remove(&Hashable(value))` (set semantics, drops the value on
the first retract) with decrement-and-remove-at-zero. The `decrement` closure now
just does `self.counts.remove(&Hashable(value))`, ignoring multiplicity and tolerating
absent keys, as the pre-fix code did.

Oracle failure: aggregate.slt, the sliding-window query
`percentile_cont(DISTINCT x, 0.5) OVER (ORDER BY id ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)`
returns `3 9` instead of `3 7`, because the retracted row-1 `5` removes the value
while the row-2 `5` is still in the frame.

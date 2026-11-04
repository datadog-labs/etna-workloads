# Rationale

In 55.2.0 the fix is already present in `datafusion/functions-aggregate/src/sum.rs`
(`SlidingDistinctSumAccumulator`). I reverted the behavioural hunks, keeping the
`update_value`/`retract_value` helpers (which the fix introduced as pure refactors):

- `update_batch`: iterates `arr.values()` directly, including null slots (reverses the
  `apply_valid_values(arr, Self::update_value)` hunk).
- `retract_batch`: same, iterating `arr.values()` directly (reverses the retract hunk).
- `evaluate`: returns `Some(self.sum)` always, so a frame with no non-null values gives 0, not NULL
  (reverses the `(!counts.is_empty()).then_some(sum)` hunk).

`merge_batch` already skipped NULLs via the `Int64(Some(v))` pattern, so it is unchanged.

Expected oracle failure: window.slt `SUM(DISTINCT v) OVER (ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)`
returns 0 instead of NULL for ts=1 and 4, and null slots' garbage values are counted. The unit tests
in sum.rs also fail.

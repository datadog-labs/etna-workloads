# Rationale

55.2.0 already contained the fix in `datafusion/functions-window/src/lead_lag.rs`. I reverted each fix hunk to its pre-fix form, one for one. The only addition from the fix that stays is the `offset_magnitude` helper. `evaluate_all_with_ignore_null` also uses it, and nothing in the fix touches that function.

- Import: `use std::ops::{Neg, Range}` is restored.
- `WindowShiftKind::shift_offset`: Lead is `value.map(|v| v.neg()).unwrap_or(-1)` again, instead of `wrapping_neg`. This panics on `i64::MIN` ("attempt to negate with overflow") in a debug build.
- `partition_evaluator`: the reversed case is `-offset` again, instead of `wrapping_neg`.
- `get_range`: the lag and lead branches again use `self.shift_offset as usize` and `(-self.shift_offset) as usize`, plain `idx + offset (+ 1)`, and no saturating arithmetic.
- `evaluate`: the index is computed as `(range.end as i64 - self.shift_offset - 1) as usize` or `(range.start as i64 - self.shift_offset) as usize` again, instead of the checked arithmetic. The IGNORE NULLS lag and lead paths again use `self.shift_offset as usize`, `(-self.shift_offset) as usize` and `non_null_row_count + 1`.

## Oracle failure
`lead_lag_extreme_offsets.slt` fails on its first query, `lead(value, -9223372036854775808, 0)`. The task panics with "attempt to negate with overflow" at `lead_lag.rs:121`, which is the crash the fix addressed.

I ran `./check.sh` once and stopped at that first failing query. The other extreme-offset queries in the file weren't observed individually.

# Rationale

Only change: `general_repeat` in `datafusion/functions-nested/src/repeat.rs`.

Fix hunk reversed: the first `general_repeat` hunk, which moved the length
validation (`build_repeat_offsets`) ahead of the `take_indices` allocation.
In 55.2.0 the validation is already in shared helpers, so a plain reversal does
not apply. Pre-fix, `Vec::with_capacity(total_repeated_values)` ran on the raw
summed count before any bound check, and the offsets/overflow checks ran
afterwards. I restored that order: I removed
`ensure_repeated_values_fit::<O>(total_repeated_values)?` and moved
`build_repeat_offsets` to after the allocation. The `general_list_repeat` path
is unchanged.

Oracle: `array/array_repeat.slt` fails on
`select array_repeat(1, 9223372036854775807);`. The query panics with
`capacity overflow` where the fix expects the execution error
`array_repeat: requested length exceeds maximum array size`.

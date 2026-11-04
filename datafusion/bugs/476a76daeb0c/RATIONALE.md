# Rationale

55.2.0 still contains the fix's `logical_nulls()` code, so a plain reverse of the hunks wasn't possible.
I reverted its core in `datafusion/functions-nested/src/array_compact.rs`, `compact_list`:
`values.logical_nulls()` became `values.nulls()` (physical validity buffer only).

This reverses the fix's main hunk, "use logical nulls so types without a validity buffer (NullArray) count as null".
`NullArray::nulls()` returns `None`, so the "no validity buffer" fast path returns the input unchanged.
That is the pre-fix behaviour, where `values.null_count() == 0` took the same early return.
The later `values_nulls.is_null(i)` calls and the null counts all use the same physical buffer.
The refactored loop, offsets and `kept` computation are left alone, because they are equivalent to the old code once the null source is physical.

Failing oracle case: `array_distinct.slt:140`, `select array_compact(make_array(NULL, NULL, NULL))`.
It returns `[NULL, NULL, NULL]` instead of `[]`.

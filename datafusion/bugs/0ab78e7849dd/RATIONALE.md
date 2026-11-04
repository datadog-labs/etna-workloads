# Rationale

Changed `datafusion/spark/src/function/array/repeat.rs`, `spark_array_repeat`.

Fix hunk reversed: `compute_null_mask(&arg_values[1..], ...)` back to `compute_null_mask(&arg_values, ...)`.
In 55.2.0 `compute_null_mask` takes no `number_rows`, so only the slice differs. The null mask is again
computed over all arguments, so a NULL element makes the whole result NULL instead of being repeated.
The comment above the call was reverted to "If any argument is null". The doc comments on the function
and the struct were left as they are, since they are not behavior.

Oracle failures (`spark/array/array_repeat.slt`): `array_repeat(NULL, 2)`, `array_repeat(NULL, 1)` and
`array_repeat(NULL, 0)` return NULL instead of `[NULL, NULL]`, `[NULL]` and `[]`. The VALUES case with
`(NULL, 1)` returns NULL instead of `[NULL]`.

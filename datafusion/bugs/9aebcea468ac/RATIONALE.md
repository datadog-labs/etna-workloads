# Rationale

Fix hunk reversed: the `stride_map_fn` / array `try_unary` paths in `date_bin_impl` that scaled
the source timestamp with plain `x * scale` (the fix replaced it with `checked_mul` and an error).
In 55.2.0 this logic lives in `date_bin_timestamp_value` (shared by scalar and array paths) in
`datafusion/functions/src/datetime/date_bin.rs`. I replaced the `checked_mul`-based
`scale_and_bin_to_nanos` call with `stride_fn(stride, value * scale, origin)`, i.e. the original
unchecked multiply. `scale_and_bin_to_nanos` is left in place because the TIME path still uses it.

Oracle: `date_bin_errors.slt` fails. The `Timestamp(Second)` i64::MAX query panics with
"attempt to multiply with overflow" instead of returning the expected execution error.

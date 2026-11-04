# Rationale

The fix replaced unchecked `date + days` / `date - days` in `compute::binary` with `compute::try_binary` and `checked_add`/`checked_sub`, returning `ArrowError::ArithmeticOverflow`. In 55.2.0 the code used `compute::binary` with `wrapping_add`/`wrapping_sub` instead (a different silent-overflow form). I restored the pre-fix plain arithmetic.

- `datafusion/spark/src/function/datetime/date_add.rs`: the three closures (Int8/Int16/Int32) are now `date + days as i32` / `date + days`. This reverses the date_add hunk. Overflow panics in debug builds and wraps in release, and it never returns the `Arithmetic overflow: date_add` error.
- `datafusion/spark/src/function/datetime/date_sub.rs`: the three closures are now `date - days as i32` / `date - days`. This reverses the date_sub hunk in the same way.

## Oracle
`spark/datetime/date_add.slt` fails. `SELECT date_add('2016-07-30'::date, 2147483647::int)` panics with "attempt to add with overflow" at date_add.rs:118. The test expects the error `Arithmetic overflow: date_add`. The `date_sub` overflow case would fail in the same way.

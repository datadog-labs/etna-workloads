# Rationale

Changed `datafusion/spark/src/function/bitwise/bit_count.rs`, in `spark_bit_count`, the Int8, Int16 and Int32 arms.

Each arm now calls `.unary(|v| v.count_ones() as i32)` on the native-width value. 55.2.0 had `(v as i64).count_ones()`.

This reverses the fix hunks that changed those arms to `bit_count(v.into())`. The fix widens the value to i64 and applies Spark's `Long.bitCount`, so negative Int8, Int16 and Int32 values count 64-bit sign-extended bits. 55.2.0 expresses the same widening inline with `as i64`. Dropping it restores the pre-fix behaviour: only the value's own width is counted.

The Boolean support and the Int64 arm are left as they are.

## Oracle failures
`bit_count.slt` now has 6 mismatches (I read the last 4 from the output tail):
- `bit_count(-1::int)` gives 32 instead of 64.
- `bit_count(-2::int)` and `bit_count(-3::int)` give 31 instead of 63 (not seen in the output tail; inferred from the pre-fix expected values).
- `bit_count(arrow_cast(-1, 'Int8'))` gives 8 instead of 64.
- `bit_count(arrow_cast(-1, 'Int16'))` gives 16 instead of 64.
- `bit_count(arrow_cast(-2147483648, 'Int32'))` gives 1 instead of 33.

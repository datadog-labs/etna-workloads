# Rationale

All changes are in `tree/datafusion/functions/src/math/power.rs`. `fix.patch` removed the
`power(decimal, int)` path; I reverse-applied its hunks for that file.

- Imports, `PowerFunc::new`: restored the `one_of` signature with `Coercible([decimal, int64])`
  next to `Coercible([float; 2])` (reverses the signature hunk).
- Restored `pow_decimal_int`, `pow_decimal_float`, the f64 fallback helpers and the Decimal256
  variants, and the unit tests that go with them (reverses the big deletion hunk).
- `return_type`: restored to return the base type (Decimal) instead of always Float64.
- `invoke_with_args`: restored the `decimal_pow_arm!` arms for Decimal32/64/128/256 with Int64
  exponent. They call `calculate_binary_decimal_math_cast(..., &DataType::Int64)`, because the
  old `calculate_binary_decimal_math` is deprecated in 55.2.0 and just forwards to it.
- `simplify` was not reversed. In 55.2.0 it already derives its types from `return_type`, so it
  follows the restored decimal return type. The fix's `cast_to_return_type` hunk is therefore
  harmless here and left alone. The `simplification.rs` test hunk is a test and was not touched.

## Failing oracle cases
- `decimal.slt`: 8 failures. Examples: `power(2.5::decimal(38,3), 4)` gives `39.062 Decimal128(38,3)`
  instead of `39.0625 Float64`. `power(2.5::decimal(20,4), 10)` (issue #22480) fails with
  "Arithmetic overflow: Cannot raise base 25000 to exp 10". Negative exponents give truncated
  decimals (issue #22510).
- `math.slt`: `pow(2.5::decimal(2,1), 4::bigint)` gives `39 Decimal128(2,1)` instead of `39.0625 Float64`.

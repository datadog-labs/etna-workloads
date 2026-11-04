# Rationale

In 55.2.0, `power` was redesigned: decimal paths (`compute_pow_f64_result`,
`pow_decimal_with_float_fallback`) no longer exist in power.rs; coercion turns
every input into Float64/Float64. The only remaining site of the fix is the
Float64/Float64 arm of `PowerFunc::invoke_with_args`.

## Hunk changed
`datafusion/functions/src/math/power.rs`, Float64/Float64 arm: replaced
`float64_power_checked` with `|b, e| Ok(f64::powf(b, e))`.
This reverses the fix hunk `|b, e| Ok(f64::powf(b, e))` -> `float64_power_checked`
verbatim, so `power(0, negative)` returns Infinity again instead of the error
"zero raised to a negative power is undefined". The helper is left in place
(still used by its unit test); the other fix hunks have no counterpart in 55.2.0.

## Oracle failures (math.slt)
All the added `query error ... zero raised to a negative power` cases now succeed
(returning Infinity): `pow(0, -0.5)`, `power(0.0::float8, -1.0::float8)`,
`pow(0::decimal(38,0), -2::bigint)`, `pow(0::bigint, -2::bigint)`,
`pow(0.0::decimal(10,2), -1.0)`, and the decimal-array-exponent query.

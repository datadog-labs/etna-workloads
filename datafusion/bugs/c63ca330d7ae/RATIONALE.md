# Rationale

55.2.0 already contains the whole fix (`return_field_from_args`, `output_scale_for_decimal`, etc.), so the old hunks can't be reversed textually.

## Change (datafusion/functions/src/math/round.rs)
`calculate_new_precision_scale` now returns `T::TYPE_CONSTRUCTOR(precision, scale)` and ignores `decimal_places`.

This reverses the fix hunk that replaced `return_type` (which returned the input decimal type unchanged) with `return_field_from_args`. That hunk does two things:
- It reduces the output scale to `min(scale, max(dp, 0))`.
- It widens the precision by 1 when a carry is possible (dp non-literal, or scale 0 with negative dp).

With the change, ROUND on decimals again returns exactly the input precision and scale, as before the fix. The kernels already use the return type's scale, so they round at the input scale. The result of e.g. `ROUND(999.9::DECIMAL(4,1))` is 10000 raw, which exceeds Decimal(4,1), and it is shown as a truncated value.

## Oracle failures
- decimal.slt:781: `arrow_typeof(round(173975140545.855, 2))` gives `Decimal128(15, 3)`, expected `(15, 2)`.
- scalar.slt: several type mismatches, e.g. `round(decimal(10,-2), -3)` gives `Decimal128(10, -2)` instead of `(10, -3)`, and `round('123.45'::decimal(5,2), -2147483648)` gives `(5, 2)` instead of `(5, 0)`.

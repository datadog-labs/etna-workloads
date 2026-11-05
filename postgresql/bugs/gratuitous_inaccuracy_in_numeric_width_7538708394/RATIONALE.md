# Rationale

File: src/backend/utils/adt/numeric.c, function `compute_bucket`.

Traces to the fix.patch hunk that changed compute_bucket's computation. The fix multiplies by count before dividing; the current code does `(operand-bound1)*count`, then a floor division. I reverted to the old order: divide first with `select_div_scale` rounding, then multiply by count, add one and `floor_var`. The quotient is rounded before the multiplication, so the result is slightly inaccurate. Values near bucket boundaries can land in the wrong bucket. Reversed bounds need no special handling because the signs cancel in the division. The fix's `reversed_bounds` parameter is not reintroduced; the old code branched on it only to pick the subtraction order.

Failing oracle case: src/test/regress||numeric

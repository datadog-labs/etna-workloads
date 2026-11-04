# Rationale

All changes are in `datafusion/optimizer/src/simplify_expressions/expr_simplifier.rs`.

1. `simplify_right_is_one_case` (fix hunk: the new `simplify_right_is_one_case`, used by `A * 1`, `1 * A`, `A / 1`).
   The fix made these rules cast the surviving operand to the `BinaryTypeCoercer` result type. Pre-fix they returned
   `*left` unchanged (`Transformed::yes(*left)`). The function body now does that. The call sites already exist in 55.2.0, so this restores the old result type.
2. Null rules for Multiply and Divide (fix hunks `simplify_right_is_null_case` / `simplify_null_div_other_case`).
   55.2.0 handles these through the generic `op.returns_null_on_null()` rule at the top of `f_up`, which builds a null of the correct result type.
   I excluded `Multiply | Divide` from that rule and restored the pre-fix `A * null`, `null * A`, `A / null` and `null / A` arms. Each returns the null operand with its own type and no cast.
   This reversal alone does not fail any oracle case. It is the same defect as hunk 1.

## Oracle failures
`simplify_expr.slt` fails on three queries (`a * 1.000::DECIMAL(4,3) > ...`, `1.000::DECIMAL(4,3) * a > ...`, `a / 1.000::DECIMAL(4,3) > ...`).
The error is `Invalid comparison operation: Decimal128(20, 0) > Decimal128(25, 3)`. The simplified expression has a different type from the original, which is the decimal precision bug the fix targeted.

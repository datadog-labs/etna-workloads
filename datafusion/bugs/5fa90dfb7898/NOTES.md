repro.sql copies the decimal-precision queries added to simplify_expr.slt (`a * 1.000::DECIMAL(4,3) > 1.2::decimal(2,1)`, the `1 * a`, `a / 1` and `/ NULL` variants).

df-clean returns `false` / `NULL`. df-buggy fails three of the six queries with
`Arrow error: Invalid argument error: Invalid comparison operation: Decimal128(20, 0) > Decimal128(25, 3)`
(and `Decimal128(27, 4)` for the division case). The cause is that the simplifier rewrites `A * 1` or `A / 1` to `A` without the cast the type coercion required, so the comparison gets mismatched decimal types.

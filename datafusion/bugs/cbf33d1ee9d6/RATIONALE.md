# Rationale

Fix hunk reversed: the `simplify` hunk in `datafusion/functions/src/math/log.rs`, which added an early
`ExprSimplifyResult::Original(args)` return when the last argument is a Decimal32/64/128/256 with negative scale.

In 55.2.0 the `log_decimal128` hunk is already covered by a rewrite (`decimal_to_f64` handles negative scale via `powi`),
so only the simplify guard is removed (`LogFunc::simplify`). Without it, simplification calls
`ScalarValue::new_one`/`new_ten` on a negative-scale decimal type, which asserts `scale >= 0`.

Oracle: `decimal.slt` fails. Queries such as `select log(base, CAST(1e4 AS DECIMAL(18, -4))) ...` fail with
"Optimizer rule 'simplify_expressions' failed ... Negative scale is not supported".

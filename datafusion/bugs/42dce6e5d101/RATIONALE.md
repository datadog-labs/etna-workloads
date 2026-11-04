# Rationale

## Change
`datafusion/expr/src/expr_schema.rs`, `verify_function_arguments`: the `map_err` closure
formats `err` directly again (`"{}. {}", err, ...`) instead of unwrapping
`DataFusionError::Plan(msg)` to `msg`.

This reverses all four fix hunks in expr_schema.rs (scalar UDF, aggregate UDF, window UDF,
and the `Expr::to_field`-style paths). In 55.2.0 they were consolidated into this one helper,
so a single edit restores the pre-fix behaviour: a `Plan` error is wrapped by
`plan_datafusion_err!`, producing "Error during planning: Error during planning: ...".

The fix's type_coercion.rs hunks only touched test expectations, so nothing to revert there.
(`DataFusionError` is still imported/used elsewhere in the file.)

## Oracle failures
- aggregate.slt, errors.slt, scalar.slt all fail: e.g. `select position(1 in 1)` now yields
  "Error during planning: Error during planning: Function 'strpos' requires String..." where
  the tests expect a single prefix; errors.slt regr_slope/nth_value cases fail likewise.

# Rationale

## Hunk 1: `datafusion/optimizer/src/extract_leaf_expressions.rs`, `try_push_into_inputs`
Reverses the fix's `if matches!(node, LogicalPlan::Unnest(_)) { return Ok(None); }`
guard. I removed the same guard from 55.2.0 (it was present, minus the second
comment line). `Unnest` is no longer a barrier, so pushdown is routed through it by column name.

## Hunk 2: `datafusion/expr/src/logical_plan/plan.rs`, `LogicalPlan::with_new_exprs` (Unnest arm)
Removing the guard alone doesn't bring the bug back, because 55.2.0 made
`Unnest::with_new_exprs` accept `Expr::Column` exprs. That is a second path that
covers the same defect, namely the rebuild `node.with_new_exprs(node.expressions(), new_inputs)`
the fix message names. I restored the old behaviour: `assert_no_expressions(expr)?`
and use the existing `exec_columns`. `Unnest::expressions()` exposes the exec columns, so the
rebuild errors with "should have no exprs".

## Oracle
`unnest.slt` fails at line 1435 (`SELECT sum(get_field(s, 'c0')) FROM (SELECT s, unnest(arr) ...)`)
with the internal error `Unnest ... should have no exprs, got [Column(__unnest_placeholder(arr))]`.
That is the symptom the fix describes (`Assertion failed: expr.is_empty(): Unnest`).

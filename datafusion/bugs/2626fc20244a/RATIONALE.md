# Rationale

Fix hunk reversed: `datafusion/expr/src/expr_rewriter/mod.rs`, `coerce_exprs_for_schema`,
the fallback arm `_ => expr.cast_to(new_type, src_schema)` that the fix replaced with a cast
followed by `.alias(name)`.

In 55.2.0 the fix had been narrowed to a nested match that aliases only `Expr::Column`
(issue #18818). I collapsed it back to the pre-fix `_ => expr.cast_to(new_type, src_schema)`.
A cast of a non-aliased expression then loses its original output name again, so the name
changes when `datafusion.optimizer.expand_views_at_output` is on.

Oracle: `cast.slt` fails at line 113 (`explain select b from t` with `expand_views_at_output = true`).
The logical plan shows `Projection: CAST(t.b AS LargeUtf8)` instead of `... AS b`, and the physical
plan shows `as t.b` instead of `as b`.

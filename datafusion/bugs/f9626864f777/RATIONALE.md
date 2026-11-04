# Rationale

All changes are in the `LogicalPlan::Projection` arm of `ScalarSubqueryToJoin::rewrite`
(`datafusion/optimizer/src/scalar_subquery_to_join.rs`). 55.2.0 already contained the fix's
alias-keyed code; I restored the pre-fix structure, which reverses every implementation hunk of fix.patch:

- Hunk 1 (map construction): `alias_to_index`/`rewrite_exprs` replaced with `expr_to_rewrite_expr_map` (keyed by Expr)
  and `subquery_to_expr_map` (keyed by `Subquery`).
- Hunk 2 (compensation lookup): look up the owning expr via `subquery_to_expr_map.get(&subquery)`, then its rewrite expr.
  Two structurally equal subqueries collide on the same `Subquery` key, so the second's compensation is applied to the
  wrong (first) expression.
- Hunk 3 (write back): `expr_to_rewrite_expr_map.insert(expr, new_expr)`.
- Hunk 4 (final projection): read `new_expr` from the map by expr, with clones.

(The same-named `physical_uncorrelated` arguments added after the fix are untouched.)

## Oracle
`subquery.slt` fails on `correlated_scalar_subquery_count_agg_duplicated_in_projection`: the first column `a`
returns NULL instead of 1 for unmatched rows (22, 44) because the count-bug compensation isn't applied to it.

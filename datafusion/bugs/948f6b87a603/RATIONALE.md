# Rationale

Fix: `common_subexpr_eliminate.rs`, aggregate path (`CommonSubexprEliminate::try_optimize_aggregate`), second `find_common_exprs`/CSE pass over `new_aggr_expr`.

In 55.2.0 the fix is still present, in a slightly refactored form (`(0..len).map(|_| None).collect()`). I reverted it in place:

- Hunk 1 (computing `saved_names` with `NamePreserver::new_for_projection()` from the original `aggr_expr`): removed.
- Hunk 2 (zipping `saved_names` into the loop and calling `saved_name.restore(expr_rewritten)` when `expr_rewritten == expr_orig`): removed. The loop is back to `zip(rewritten_aggr_expr, new_aggr_expr)`, and `expr_rewritten` is used directly.

The `aggr_expr` tuple element is still threaded through because the `FoundCommonNodes::No` branch uses it. The first-pass name preservation there is unchanged, as in the original fix.

With the fix removed, the second CSE pass puts the already-rewritten names (from the first pass) into the Projection instead of the original names. The output schema then changes and the optimizer fails with a SchemaError / FieldNotFound.

## Oracle
`aggregate.slt` fails at the added query (line ~665, the three `COUNT(a) FILTER (...)` in `WITH s AS ...`). The remaining 4 failures in that file (`x_dict > 3` type_coercion, lines 6717-6732) also appear in the output. They are in code this change does not touch, so I take them to be pre-existing. I did not run a baseline without my change to confirm that.

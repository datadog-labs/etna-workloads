# Rationale

All changes are in `tree/datafusion/optimizer/src/simplify_expressions/expr_simplifier.rs`,
the searched-CASE -> boolean AND/OR rewrite in `Simplifier::mutate`.

- Hunk "loop body": the fix wrapped each `when` in `is_exactly_true(...)` (`X IS NOT DISTINCT FROM true`
  for nullable X). Restored the pre-fix code that uses the raw `when` predicate, so `NOT filter_expr`
  complements nullable conditions incorrectly.
- Hunk "else": the fix always added `NOT(filter) AND else` with a missing ELSE as NULL. Restored the
  `if let Some(else_expr)` form, so a CASE without ELSE no longer yields NULL when no WHEN matches
  (it becomes `false`).
- Hunk "helper": removed `is_exactly_true`, which is now unused (it was added by the fix).
  (The `O(n!)` comment change is cosmetic and not restored.)

## Oracle failures (case.slt)
1. `select case when a=1 then false end from foo;` returns `false` for every row instead of `false, NULL x5`.
2. `SELECT c, CASE WHEN c > 0 THEN true END, CASE WHEN c > 0 THEN true ELSE false END FROM VALUES ...`
   returns wrong results (`0 false false`, `NULL NULL NULL` instead of `0 NULL false`, `NULL NULL false`).

# Rationale

## src/backend/parser/parse_collate.c, assign_aggregate_collations()
Traces to the fix.patch hunk that added the `T_Aggref` case in `assign_collations_walker`.
That case treated resjunk args (ORDER BY/DISTINCT-only expressions) separately, using
`assign_expr_collations()` instead of the shared `loccontext`. In today's code that logic
lives in `assign_aggregate_collations()`. I removed the resjunk branch, so every arg goes
through `assign_collations_walker` with the aggregate's `loccontext`.
ORDER BY expressions then merge their collations with the regular args and with each
other. That produces spurious collation conflicts or the wrong collation for the aggregate.

## Failing oracle cases
- src/test/regress||collate

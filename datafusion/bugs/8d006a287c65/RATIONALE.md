# Rationale

Changed: `datafusion/expr/src/logical_plan/plan.rs`, `Union::derive_schema_from_inputs_by_position`:

    let nullable = fields.iter().any(|field| field.is_nullable());
    ->
    let nullable = first_field.is_nullable();

Fix hunks reversed:
- `builder.rs` `union()`: before the fix, the schema was the left input's schema, so the
  nullability of the other branch was ignored. In 55.2.0 `union()` calls
  `Union::try_new_with_loose_types`, which derives the schema via
  `derive_schema_from_inputs_by_position`; taking nullability only from the first input restores that behaviour.
- `plan.rs` `recompute_schema`: the fix made it call `Union::try_new` (deriving nullability
  from all inputs). In 55.2.0 that still happens, and it goes through the same function, so
  the same one-line change also restores the pre-fix loss of nullability there
  (the old code used the first input's schema).

Oracle: `union.slt` fails. `SELECT a, a IS NOT NULL FROM (SELECT 'foo' AS a, 3 AS b UNION ALL SELECT NULL AS a, 4 AS b)`
returns `NULL true` instead of `NULL false`. Column `a` is wrongly non-nullable, so the simplifier folds `a IS NOT NULL` to `true`.

# Rationale

Fix: union schemas must not reuse the first input's table qualifiers (#15135).

1. `datafusion/expr/src/logical_plan/plan.rs`, `Union::derive_schema`: reverses the hunk that changed
   `Ok((table_reference, ..))` to `Ok((None, ..))`. Restored `first_schema.qualified_field(i).0.cloned()`
   as the field qualifier (the old computation). The unique-name logic stays, since it is not what was reverted.
2. `datafusion/optimizer/src/analyzer/type_coercion.rs`, `coerce_union_schema_with_schema`: reverses the hunk that
   replaced `base_schema.iter()` / `qualifier.cloned()` with `base_schema.fields()` / `None`. Same defect
   (the coerced union schema keeps the first input's qualifier), on the second path.

## Failing oracle cases
`union.slt` fails (e.g. line 967: the `Sort` over the Union is printed as `u1.y` instead of `y`, plus other
`Sort: t1.c1` style plan diffs). `limit.slt`, `order.slt` and `type_coercion.slt` expect unqualified `Sort`/`Aggregate`
columns above a Union and are affected the same way.

# Rationale

Fix: `union()` in expr/logical_plan/builder.rs rejected inputs with differing column counts ("UNION queries have different number of columns").
In 55.2.0 that check moved/was duplicated, so two places were reverted (both the same defect):

1. `datafusion/expr/src/logical_plan/plan.rs`, `Union::derive_schema_from_inputs_by_position`: removed the column-count check loop (the 55.2.0 home of the fix's hunk, since `builder::union` now delegates to `Union::try_new_with_loose_types`).
2. `datafusion/sql/src/set_expr.rs`: removed the call to `validate_set_expr_num_of_columns` in set operations (a later SQL-level path covering the same case). The helper is left in place, now unused-but-compiling.

Result: planning no longer rejects the mismatch; it is only caught late by the analyzer's `coerce_union_schema` ("Union schemas have different number of fields..."), the pre-fix behaviour.

Oracle: type_coercion.slt fails on both cases (UNION and UNION ALL, 1 vs 2 columns): they expect the "UNION queries have different number of columns" planning error but get the type_coercion analyzer error.

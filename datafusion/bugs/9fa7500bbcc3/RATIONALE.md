# Rationale

## Hunk 1: `datafusion/expr/src/expr_schema.rs`, `to_field`, `Expr::WindowFunction` arm
Fix: the arm returned the function's own return field (`window_function_field`) instead of
`Field::new(&schema_name, dt, nullable)`, which dropped the field metadata.
Reversal: both the `AggregateUDF` and `WindowUDF` branches again build
`Field::new(&schema_name, return_field.data_type().clone(), return_field.is_nullable())`.
The logical field for a window function therefore has empty metadata, while the physical
window expression (`WindowExpr::field`, e.g. lag's `field()`) keeps the input metadata.
`get_type`/`nullable`/`metadata` already go through `to_field` in 55.2.0, so this one edit
covers the fix's three call sites.

## Hunk 2 (second path that hid the bug): `datafusion/core/src/physical_planner.rs`, `Projection` planning
55.2.0 plans `ProjectionExec` with `try_new_with_schema_metadata(.., output_schema)`, which
overwrites the physical field/schema metadata with the logical schema's. That masked hunk 1
(the physical projection took the empty logical metadata, so the aggregate schema check
passed). I reverted both calls (sync and async arms) to `ProjectionExec::try_new`, so the
physical projection keeps the metadata of its input as before. The defect is the same one,
a logical/physical mismatch of window output field metadata.

## Oracle
`metadata.slt` fails on the issue #18337 reproducer (`COUNT(CASE WHEN prev_value ...)` over
`LAG(nonnull_name) OVER (ORDER BY ts)`) with: `Internal error: Physical input schema should
be the same as the one converted from logical input schema. Differences: field metadata at
index 1 [prev_value]: (physical) {"metadata_key": "the nonnull_name field"} vs (logical) {}`.

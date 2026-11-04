# Re-injected bug: OuterReferenceColumn loses outer field metadata (#17422 / #17524)

Fix changed `Expr::OuterReferenceColumn(DataType, Column)` to carry the whole `FieldRef`.
Pre-fix, only the data type was kept, so field metadata (e.g. `ARROW:extension:name`) and
nullability were dropped. In 55.2.0 the variant already carries `FieldRef`; I reverted it to `DataType`.

Hunks reversed (all under datafusion/*/src):
- expr/src/expr.rs: variant type `FieldRef` -> `DataType`; hash uses the data type.
- expr/src/expr_schema.rs: `get_type` returns `ty.clone()`; `nullable` is always `true`;
  `to_field` builds `Field::new(&schema_name, ty.clone(), true)` (no metadata). Removed the
  unit-test assertion/import for `out_ref_col_with_metadata`.
- expr/src/expr_fn.rs: removed `out_ref_col_with_metadata`; `out_ref_col` builds the variant directly.
- sql/src/expr/identifier.rs (two sites): use `field.data_type().clone()` instead of the field.
- Other construction sites in 55.2.0 that did not exist in the fix, adapted the same way:
  optimizer/src/rewrite_set_comparison.rs, substrait consumer field_reference.rs.

Oracle failures: joins.slt and unnest.slt. They expect
`OuterReferenceColumn(Field { name: .., data_type: .., nullable: true }, Column ..)` in
physical_plan_error output, but now get `OuterReferenceColumn(Int32, Column ..)`. The metadata-loss
failure in user_defined_scalar_functions.rs (the fix's UDF test) follows from the same change.

# Rationale

Fix hunk reversed: `datafusion/expr/src/logical_plan/builder.rs` (`field_types.push(common_type.unwrap_or(DataType::Null))`, previously `Utf8`).
In 55.2.0 this logic lives in `LogicalPlanBuilder::infer_data`, where `None => (DataType::Null, true)` is the equivalent. It is reverted to `DataType::Utf8`,
so a VALUES column that is entirely NULL is typed Utf8 instead of Null.

The other hunks (coalesce return_type / is_nullable, expr_schema new_data_types, and the signature-to-coerce_types migrations) are already
correct or redesigned in 55.2.0 and were not touched.

Oracle: select.slt (`VALUES (NULL,'a'),...` expecting `?` column type; `arrow_typeof(COALESCE(column1, column2)) FROM VALUES (null, 1.2)`),
which now see Utf8 for the all-NULL column.

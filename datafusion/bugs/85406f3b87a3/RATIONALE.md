# Rationale

All changes are in `datafusion/functions-nested/src/extract.rs`, `general_array_slice` (List/LargeList path). 55.2.0 already had the fix, so each hunk is reverted directly.

- Output field: removed the `list_inner_field(...)` call (fix: "carry the input's list field through"). The result is built again with `Field::new_list_field(array.value_type(), true)`, which loses the field name, nullability and metadata. Restored the `Field` import that the fix removed.
- `use_nulls`: `MutableArrayData::with_capacities(..., true, ...)` again (fix changed it to `false`).
- Null rows: restored `try_extend_nulls(1)` plus an offset advance of 1, instead of an empty slice (fix hunk "emit an empty slice rather than a null child element").

I did not revert the ListView path. It already used the input field, and the fix there only changed `use_nulls` and an error message.

## Oracle failures
- `array/array_slice.slt` "maintains inner nullability" cases fail with the internal error "returned value of type List(Int32) while List(non-null Int32) was promised at planning time". The LargeList and stride cases fail the same way.
- `spark/array/slice.slt` fails with `List(Int64)` returned where `List(Int64, field: 'element')` was promised.
- `array_pop.slt` is not reported as failing.

# Rationale

## Hunk changed
`datafusion/common/src/utils/mod.rs`, `SingleRowListArrayBuilder::build_fixed_size_list_array`:
reverses the fix hunk that replaced `FixedSizeListArray::new(field, list_size as i32, arr, None)`
with `try_new_with_length(..., 1).unwrap()`. Restored the pre-fix call. With list size 0 the
length cannot be inferred from the values (0 / 0), so the scalar gets a 0-row array instead of a 1-row one.
(55.2.0 already contained the fix in this exact spot, so the reversal applies directly.)

## Oracle failures
- `array/array_empty.slt`: `empty(arrow_cast(make_array(), 'FixedSizeList(0, Null)'))` panics (index 0 of a length-0 BooleanArray).
- `arrow_typeof.slt`: `arrow_cast([], 'FixedSizeList(0, Null)')` panics on the assertion in scalar/mod.rs (length 0 vs 1).
- `array/cardinality.slt` still passes.

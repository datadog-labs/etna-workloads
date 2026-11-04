# Rationale

Fix: `flatten_dictionary_array` in `inlist_builder.rs` returned only `array.values()` (unique values) for dictionary arrays; the fix replaced it with a `cast` to the value type.

In 55.2.0 the flatten step had been removed entirely (dictionaries were passed through unchanged), so the fix hunks could not be reversed directly. I re-added the pre-fix code in
`datafusion/physical-plan/src/joins/hash_join/inlist_builder.rs`:

- Re-added `use arrow::downcast_dictionary_array;` and the pre-fix `flatten_dictionary_array` (recursing on `array.values()`). This reverses the fix's rewrite to `cast(array, value_type)`.
- `build_struct_inlist_values` again maps `join_key_arrays` through `flatten_dictionary_array` and builds the struct fields / `StructArray` from the flattened arrays. This reverses the `.collect::<Result<Vec<_>>>()?` hunk.

## Oracle failure
`joins.slt` (issue #20437 case): the multi-key join with a `Dictionary(Int32, Utf8)` key panics in `StructArray::from` with
`Incorrect array length for StructArray field "c1", expected 3 got 2`, the same length-mismatch panic the fix addressed.

The in-crate unit tests in `inlist_builder.rs` that expect dictionaries to be preserved would also fail (they were not run by check.sh).

# Rationale

## Change
`datafusion/expr-common/src/type_coercion/binary.rs`, `struct_coercion`: removed the
`if fields_have_same_names(..) { return coerce_struct_by_name(..) }` branch, so struct
coercion is always positional via `coerce_struct_by_position`.

Reverses the fix hunk in `binary.rs` that added name-based coercion when the two
structs share field names (pre-fix code zipped fields positionally). The other fix hunks
(ColumnarValue/ScalarValue casts, nested_struct) were rewritten in 55.2.0 (they use
`requires_nested_struct_cast`) and were left alone. The helpers `fields_have_same_names`
and `coerce_struct_by_name` are now unused in non-test code.

## Oracle failures
`struct.slt` fails (2 queries):
- join `orders.customer = customers.info` with reordered struct fields: positional
  coercion makes the runtime cast fail, "Cannot cast string 'Alice' to Int32".
- `s in ({b: 'x', a: 1}, ...)`: "Cannot cast string 'x' to Int64".
`case.slt` still passes.

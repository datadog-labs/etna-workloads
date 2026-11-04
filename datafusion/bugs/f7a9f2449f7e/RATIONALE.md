# Rationale

## Hunk reversed
`datafusion/spark/src/function/array/spark_array.rs`, `make_array_inner`: re-added the
`DataType::LargeList(..) => array_array::<i64>(...)` match arm, which the fix removed
(the fix hunk `-        DataType::LargeList(..) => array_array::<i64>(arrays, data_type),`).
The other hunks of the fix (return_type / return_field_from_args refactor) are
already present in 55.2.0 and are only cleanup; the planned return type is always `List`.
The array_array call differs from the original only by the extra field-name argument that 55.2.0 uses.

## Oracle failure
`spark/array/array.slt`: all three added queries with LargeList inputs fail with
"Internal error: Function 'array' returned value of type LargeList(...) while List(...) was promised at planning time".

# Rationale

## Changed: datafusion/datasource/src/write/demux.rs (`compute_partition_keys_by_row`, `DataType::Dictionary` arm)

Reverses the fix's only implementation hunk. The fix replaced iterating
`array.values()` (the dictionary's *distinct values*, with a null check) by
iterating `0..rb.num_rows()` and calling `array.value(i)` (the per-row key
lookup). 55.2.0 still has the fixed form, so I restored the pre-fix loop:
`for val in array.values()` pushing `val` or an error on null. The fix's import
change (`ArrayAccessor`) is not reverted; `array.value(i)` is no longer used
there and the import lives elsewhere in the file, so it builds.

The partition values vector then has one entry per distinct dictionary value
rather than one per row, so it mismatches the row count.

## Oracle failure
`dictionary.slt`: the `COPY (SELECT arrow_cast(column1,'Dictionary(Int32, Utf8)') ...) PARTITIONED BY (column1)`
statement panics with "index out of bounds: the len is 2 but the index is 2"
(3 rows, 2 distinct values 'foo','bar').

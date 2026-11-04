# Rationale

Fix: add Int8/Int16/UInt8-64/Float16/32/64 arms to `compute_partition_keys_by_row` in `datafusion/datasource/src/write/demux.rs`.

Change (same file, 55.2.0): removed those arms (Int32/Int64 remain) and the now-unused `as_int8/16`, `as_uint*`, `as_float*` imports. This reverses both fix hunks (imports and new match arms). Those types now fall through to the default `not_impl_err!` "it is not yet supported to write to hive partitions with datatype ...", as before the fix.

Oracle: `copy.slt` fails. The `COPY ... PARTITIONED BY (column1..column14)` over Int8/UInt8/Int16/... columns errors with the not-yet-supported error, and the follow-up select returns mismatched results.

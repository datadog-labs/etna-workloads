# Rationale

Hunk changed: `src/parser/peg/transformer/transform_alter.cpp`, `TransformAddColumnEntry`.
Removed the `else if (constraint.constraint_name == "ColumnCompression")` branch, which traces to the
last hunk of the fix (it copied `constraint.compression_type` into the AddColumnEntry and rejected
COMPRESSION_AUTO). Without it, `USING COMPRESSION x` in ADD COLUMN is silently ignored, as before the fix.
The other hunks of the fix then have nothing to act on (compression stays COMPRESSION_AUTO).

Oracle: test/sql/alter/add_col/test_add_col_compression.test should fail (the `invalid` statement no
longer errors, and sql lacks `USING COMPRESSION Uncompressed`). Result of etna-check: see below.

etna-check output:
```
FAIL     test/sql/alter/add_col/test_add_col_compression.test
         test/sql/alter/add_col/test_add_col_compression.test:21
         Wrong result in query! SELECT contains(sql, 'USING COMPRESSION Uncompressed') ...
         0 <> true
1 of 1 oracle units fail
```

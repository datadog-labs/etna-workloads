repro.sql calls to_timestamp(<scalar float>, <string column>) on a 2-row table (Float64, Float32 and Float16 scalars).
Clean build: returns the expected timestamp for each row.
Buggy build: each query fails with "Internal error: UDF to_timestamp returned a different number of rows than expected. Expected: 2, Got: 1." because the scalar float result is not broadcast.

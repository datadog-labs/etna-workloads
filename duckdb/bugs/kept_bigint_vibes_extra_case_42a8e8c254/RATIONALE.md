# Rationale
File: src/src/function/table/repeat_row.cpp

1. RepeatRowBind: removed the int64 read + `< 0` check ("num_rows cannot be less than zero"); restored
   `NumericCast<idx_t>(num_rows.GetValue<uint64_t>())`. Traces to the fix's first hunk.
2. RepeatRowTableFunction::RegisterFunction: keyword-only `num_rows` type BIGINT -> UBIGINT. Traces to the second hunk
   (today's code uses the signature API instead of named_parameters).
Negative values are now rejected by the UBIGINT parameter matching, not with the dedicated message.

## Oracle
```
FAIL     test/sql/table_function/test_repeat_row_function.test
         ...:61 Query failed, but error message did not match expected error message: <REGEX>:Binder Error.*num_rows cannot be less than zero.*
         Binder Error: No function matches the given name and argument types 'repeat_row(INTEGER_LITERAL, "num_rows" := INTEGER_LITERAL)'.
1 of 1 oracle units fail
```

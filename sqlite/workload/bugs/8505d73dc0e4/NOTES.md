Reproducer (repro.sql): json_group_array() used as a window function over a
frame of just the current row, with a non-JSON blob in the second row.

The injected bug stops json_group_array's step function from refreshing
`pStr->pCtx` when the accumulated string is empty (nUsed<=1). After the inverse
step removes row 1, row 2's step reports "JSON cannot hold BLOB values" through
a stale sqlite3_context.

Clean shell: prints `[1]` and the error "JSON cannot hold BLOB values", exit 1.
Buggy shell: assertion failure in sqlite3_result_error (mutex_held), exit 134.

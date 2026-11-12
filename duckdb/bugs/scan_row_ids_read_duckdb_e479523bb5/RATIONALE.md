# Rationale
All hunks in src/src/function/table/read_duckdb.cpp revert the upstream fix:
- DuckDBReader members: removed `scan_column_indexes` (hunk 1).
- DuckDBReadLocalState: removed `row_id_chunk` (hunk 2).
- TryInitializeScan: removed the row-id fallback; init_global/init_local again receive `column_indexes` directly, possibly empty (hunk 3), and removed row_id_chunk initialization.
- Scan: always scans directly into `chunk` (hunk 4).
Result: with no projected columns the table scan gets an empty column list, violating its assertion.

Oracle output:
FAIL     test/sql/function/table/read_duckdb_empty_projection.test
         Query unexpectedly failed (...:14) SELECT count(*) FROM read_duckdb(...)
         INTERNAL Error: Assertion triggered in file src/storage/table/scan_state.cpp"
1 of 1 oracle units fail

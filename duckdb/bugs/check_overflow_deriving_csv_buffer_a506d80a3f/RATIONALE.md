# check_overflow_deriving_csv_buffer_a506d80a3f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a506d80a3f8a4da6f95602cd518277d77bcf5db2 ("Check for overflow when deriving CSV buffer size from max_line_size"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/test_linesize.test

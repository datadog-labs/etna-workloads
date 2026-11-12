# csv_invalid_utf_8_error_780872be31

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 780872be3111c6e9da26bfe6796da5ef95a725e7 ("Fix the CSV invalid UTF-8 error for projected columns, and compare extra values with the NULL string by length"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/test_csv_error_projection.test

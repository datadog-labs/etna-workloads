# drop_column_cascade_generated_columns_2ff5bc47ef

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 2ff5bc47efb41a348c92fa5ec58381b5d3325ec6 ("Fix Issue #24378: DROP COLUMN CASCADE with generated columns and CHECK constraints"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/generated_columns/virtual/check.test

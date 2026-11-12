# out_bounds_read_csv_projection_9fb28c934e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9fb28c934e073d9f6b25ad7362fccbdd4c7f7d81 ("Fix out-of-bounds read in CSV projection with escaped extra column"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/26049.test

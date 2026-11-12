# out_bounds_write_empty_csv_4c9cbc6e8d

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 4c9cbc6e8dc12c04cdcfc891bf69272757411d93 ("Fix out-of-bounds write on empty CSV line with duplicate empty nullstr"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/25268.test

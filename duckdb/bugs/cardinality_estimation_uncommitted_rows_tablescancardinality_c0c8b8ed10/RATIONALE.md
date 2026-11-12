# cardinality_estimation_uncommitted_rows_tablescancardinality_c0c8b8ed10

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c0c8b8ed100e66c1dc1ecd4d3c28a7b1d3c9c50c ("Fix cardinality estimation for uncommitted rows in TableScanCardinality"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/transactions/test_cardinality_estimation_uncommitted.test

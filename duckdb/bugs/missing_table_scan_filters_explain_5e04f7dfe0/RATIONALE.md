# missing_table_scan_filters_explain_5e04f7dfe0

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 5e04f7dfe0135ef69677b6816730e3adf9d8d50b ("Fix missing table scan filters in EXPLAIN"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/test_rowid_pushdown.test

# copy_table_filters_lhs_scan_ddafe29e54

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ddafe29e5420621f1eb8ed4f58401ba6a1f9c1a4 ("Copy table_filters to LHS scan in late materialization"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/late_materialization_table_filters.test

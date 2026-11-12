# resolve_partition_columns_non_pushdown_738e26c9fe

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 738e26c9fefc53e12e0a549d0247fd9f51375735 ("Resolve partition columns for non-pushdown table functions"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/sql/function/table/table_partition_info.cpp::Resolve partition columns for table functions without projection pushdown

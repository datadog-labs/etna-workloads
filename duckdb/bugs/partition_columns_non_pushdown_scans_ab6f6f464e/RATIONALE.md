# partition_columns_non_pushdown_scans_ab6f6f464e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ab6f6f464e105c1381c94a33ca48c4a5ee8a2193 ("Fix partition columns for non-pushdown scans"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/sql/function/table/table_partition_info.cpp::Resolve partition columns for table functions without projection pushdown

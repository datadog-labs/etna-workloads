# preserve_cte_metadata_copying_511310a42b

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 511310a42b7b3c5622737e056115488df3fd999e ("fix(parser): Preserve CTE metadata when copying"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_query_node_copy.cpp::CTE containers preserve complete entries when copied

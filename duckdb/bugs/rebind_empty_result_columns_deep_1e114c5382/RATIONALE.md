# rebind_empty_result_columns_deep_1e114c5382

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1e114c5382893b7fe8a6982a8d7d8b7c416b592f ("Rebind empty result columns when deep copying a plan"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/cte/cte_inlining_empty_result.test

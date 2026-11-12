# stale_cte_reader_bindings_pruning_adae019f10

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit adae019f10de7738492da98d43d32ed5aba1ca00 ("Fix stale CTE reader bindings when pruning after common subplan extraction"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/common_subplan_nested_cte.test

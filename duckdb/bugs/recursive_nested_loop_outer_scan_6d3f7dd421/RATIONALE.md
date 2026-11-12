# recursive_nested_loop_outer_scan_6d3f7dd421

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 6d3f7dd4210c36c586b364e5c82b1a9b3af909c5 ("Fix recursive nested loop outer scan reuse"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/cte/materialized/test_outer_joins_recursive_cte_materialized.test
- test/sql/cte/test_outer_joins_recursive_cte.test

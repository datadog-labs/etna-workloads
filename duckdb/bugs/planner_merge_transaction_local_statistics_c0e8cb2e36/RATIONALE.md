# planner_merge_transaction_local_statistics_c0e8cb2e36

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c0e8cb2e36438f449447e1056c6fc03f5aa3a4a7 ("planner: merge transaction-local statistics into GetStatistics"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/join/mark/test_null_safe_semi_uncommitted_stats.test

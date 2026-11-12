# only_enable_refinement_scan_nested_86b4a46d32

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 86b4a46d325240f5cc1fdb6b3443e71a6cb22ed7 ("Only enable refinement scan for nested types if null-containing, early exit for no refinement candidates"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/subquery/any_all/test_multi_column_mark_join_nulls.test

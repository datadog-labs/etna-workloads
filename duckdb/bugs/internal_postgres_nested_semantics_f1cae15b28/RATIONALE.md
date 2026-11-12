# internal_postgres_nested_semantics_f1cae15b28

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f1cae15b28d41684e6f0f5e804bc299b36a8313f ("Internal #10053: Postgres Nested Semantics"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/subquery/any_all/test_multi_column_mark_join_nulls.test
- test/sql/types/union/union_compare.test

# inline_constraint_indexes_after_table_7cec634a8b

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 7cec634a8b9823d9d8fc6daee1213a73673e35a4 ("Fix inline constraint indexes after table constraints"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/constraints/unique/test_unique_multi_constraint.test

# type_coercion_72d0c31731

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 72d0c3173129531f0860fbfb34163b09a8efa47c ("type coercion fix"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/subquery/any_all/test_row_not_equal_any_null_semantics.test

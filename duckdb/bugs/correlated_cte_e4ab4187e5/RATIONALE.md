# correlated_cte_e4ab4187e5

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e4ab4187e575394d2bef0b0d8f5fa323d9248581 ("fix correlated cte issue"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/subquery/any_all/test_correlated_cte_in.test

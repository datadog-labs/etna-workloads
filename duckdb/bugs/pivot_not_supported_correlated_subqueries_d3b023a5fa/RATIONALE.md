# pivot_not_supported_correlated_subqueries_d3b023a5fa

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d3b023a5fa2012183c109f038d1607985c644883 ("PIVOT is not supported in correlated subqueries yet"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/subquery/scalar/correlated_pivot_error.test

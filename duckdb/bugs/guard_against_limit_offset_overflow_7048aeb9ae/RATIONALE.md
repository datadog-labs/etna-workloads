# guard_against_limit_offset_overflow_7048aeb9ae

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 7048aeb9ae1bd5b15fb203db782118ae506c4ede ("guard against LIMIT + OFFSET overflow in correlated subqueries"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/subquery/scalar/test_correlated_subquery.test

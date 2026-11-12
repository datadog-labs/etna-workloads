# propagatesnullvalues_case_expr_c60dcb0b32

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c60dcb0b3205a330bf2e7832a161f5fee98e28d4 ("Fix propagatesNullValues for case expr"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/subquery/scalar/test_correlated_subquery.test

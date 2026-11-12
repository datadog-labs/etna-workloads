# add_parens_functionexpression_tostring_e70ae83764

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e70ae837642bfea1d25d962552932fcd8dc19f4b ("Add parens in FunctionExpression::ToString()"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/parser/statement_tostring_roundtrip.test

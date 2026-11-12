# preserve_old_syntax_76caf46c48

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 76caf46c48551c80b3596fd87ae74acb2f248d4c ("preserve old syntax"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/secrets/create_secret_expression.test

# throw_explicit_unsupported_error_encountering_854885cf94

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 854885cf9482f7ccc9e7b902cc634820839579cf ("Fix #15203: throw explicit unsupported error when encountering positional join in correlated subquery"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/fuzzer/public/positional_join_correlated_subquery.test

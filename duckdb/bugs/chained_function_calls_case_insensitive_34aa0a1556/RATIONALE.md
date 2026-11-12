# chained_function_calls_case_insensitive_34aa0a1556

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 34aa0a155604250b5601e46207b82d2f9d1977f4 ("Fix chained function calls on case-insensitive column matches"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/parser/function_chaining.test

# sanitize_input_1812ecbbde

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1812ecbbde848eec742d1b6ce08f8296a7c6fb98 ("fix: sanitize input"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/logging/logging_call_functions.test

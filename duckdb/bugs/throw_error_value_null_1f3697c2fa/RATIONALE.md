# throw_error_value_null_1f3697c2fa

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1f3697c2fab432ff3ccb593803ee76fa95aa106c ("Throw error when value is NULL"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/fuzzer/duckfuzz/logger_null.test

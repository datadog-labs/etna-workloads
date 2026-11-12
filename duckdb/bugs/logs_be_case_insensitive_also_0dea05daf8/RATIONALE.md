# logs_be_case_insensitive_also_0dea05daf8

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 0dea05daf823237a2de28ec7c0fec53dbb006475 ("Logs to be case-insensitive also at enable_logging callsite"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/logging/logging_call_functions.test

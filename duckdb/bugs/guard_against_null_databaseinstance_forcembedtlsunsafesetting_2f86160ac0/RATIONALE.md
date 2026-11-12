# guard_against_null_databaseinstance_forcembedtlsunsafesetting_2f86160ac0

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 2f86160ac0b459dcb3c14a1c8aeaf330049a8d38 ("Guard against a null DatabaseInstance in ForceMbedtlsUnsafeSetting"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/capi/v1/capi_config_options.cpp::Issue #25056: duckdb_set_config crashes on a boolean option set to false

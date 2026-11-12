# support_ctas_gettablenames_api_c8ec4548e6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c8ec4548e600fc69d4c727178b787069d817b6cd ("Support CTAs for GetTableNames API"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_get_table_names.cpp::Test GetTableNames

# validate_records_buffer_size_hive_828d9a90b4

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 828d9a90b4a241d4c40e9f0836779894742dd612 ("Validate the records, buffer_size and hive_types reader parameters"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/json/table/read_json_records_param_types.test

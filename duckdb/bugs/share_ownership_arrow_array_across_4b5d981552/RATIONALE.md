# share_ownership_arrow_array_across_4b5d981552

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 4b5d981552052037c54559a4d51b61b3ca77867e ("Share ownership of the Arrow array across all columns in duckdb_data_chunk_from_arrow"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/capi/v1/test_capi_arrow.cpp::Test C-API Arrow conversion functions

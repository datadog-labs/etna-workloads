# storage_validate_metadata_block_indexes_c0affdf4ad

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c0affdf4ad44e655bc71ac7f7504ac67ee11f26c ("storage: validate metadata block indexes"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_api.cpp::Test opening a database with invalid metadata block index

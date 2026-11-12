# racy_reader_redownloading_blocks_if_e33a5dcf47

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e33a5dcf474f179de4a4483a095113b7468b8c72 ("fix racy reader redownloading blocks if another reader drops them"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/common/test_external_file_cache.cpp::An evicted block held by an in-flight read is fetched once

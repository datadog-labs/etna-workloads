# enforce_min_request_size_aligned_83014efc9c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 83014efc9c91171b9b0288467c1fe9cf4a44c58b ("enforce min request size aligned with min block size"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/common/test_external_file_cache.cpp::Reads of remote files are rounded out to the minimum blocks around them

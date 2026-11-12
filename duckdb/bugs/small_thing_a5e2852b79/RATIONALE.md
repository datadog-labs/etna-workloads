# small_thing_a5e2852b79

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a5e2852b799d61d151f1a64c47ad26b57ac898ab ("fix small thing"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/common/test_external_file_cache.cpp::Compressed remote files are read in chunks of up to the file size

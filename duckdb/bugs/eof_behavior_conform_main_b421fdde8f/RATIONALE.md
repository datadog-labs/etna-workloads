# eof_behavior_conform_main_b421fdde8f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit b421fdde8f3d7256b1443430e1bdb9f75832ffe7 ("fix eof behavior: conform main"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/common/test_caching_file_system_wrapper.cpp::CachingFileHandle EOF read behavior

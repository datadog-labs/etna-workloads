# out_bounds_path_offset_file_ea44788932

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ea44788932b4bef1808312303ad89bdf6e1fa525 ("Fix out-of-bounds path offset for file:// URIs without a path"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/common/test_file_system.cpp::Path::FromString/ToString round-trips
- test/sql/function/string/path_join.test

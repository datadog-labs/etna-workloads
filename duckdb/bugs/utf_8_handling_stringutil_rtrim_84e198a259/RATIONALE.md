# utf_8_handling_stringutil_rtrim_84e198a259

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 84e198a2597aa195d2d045a4619b37c8450603a7 ("Fix UTF-8 handling in StringUtil::RTrim"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/common/test_string_util.cpp::Test RTrim preserves trailing UTF-8
- cpp:test/common/test_string_util.cpp::Test custom RTrim preserves UTF-8 paths

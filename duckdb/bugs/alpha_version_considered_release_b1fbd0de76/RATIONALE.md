# alpha_version_considered_release_b1fbd0de76

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit b1fbd0de76f118223181436c7a3ca9681134d9cf ("Alpha version is considered a (pre)release"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/common/test_versioning_utils.cpp::Test release version detection

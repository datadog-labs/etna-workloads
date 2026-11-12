# make_sure_we_dont_throw_286c27ca10

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 286c27ca10e0d523c1f66f15abfd128df271b76a ("make sure we dont throw an internal exception for 'allowed_directories' and 'allowed_paths' when setting them in the DBConfig before there is a database associated with the config"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_config.cpp::Test allowed options

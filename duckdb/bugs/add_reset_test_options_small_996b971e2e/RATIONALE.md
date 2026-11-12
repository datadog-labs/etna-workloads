# add_reset_test_options_small_996b971e2e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 996b971e2e19c253961867a58739c42edb9ff53b ("add reset test options, fix small bug"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_reset.cpp::Test RESET statement for ClientConfig options

# default_test_879894df2a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 879894df2aa84ab16b849bcd279322460afc2fdd ("default test"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/common/test_checked_integer.cpp::CheckedInteger default initialization is zero

# copy_constructor_setvariablestatement_42eb1f2d65

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 42eb1f2d6559561b0eb86888b2d94e1b21f18739 ("Fix copy constructor in SetVariableStatement"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_prepared_api.cpp::Test prepared statements with SET
- cpp:test/api/test_prepared_api.cpp::Test prepared statements with extension that can request a rebind

# add_test_bw_compatibility_06bd6bb794

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 06bd6bb794b9c94543ec3c724f33b2f94c20875f ("add test and fix bw-compatibility issue"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/optimizer/function_invocation_serialization.cpp::Serialize-only table functions retain rebinding inputs in legacy plans

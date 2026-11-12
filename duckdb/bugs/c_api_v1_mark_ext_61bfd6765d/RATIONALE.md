# c_api_v1_mark_ext_61bfd6765d

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 61bfd6765d4836c183bb5309b293a4693b81cc52 ("C API V1: mark ext scalar functions as fallible"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/capi/v1/capi_scalar_functions.cpp::Test Scalar Functions - Error Reporting

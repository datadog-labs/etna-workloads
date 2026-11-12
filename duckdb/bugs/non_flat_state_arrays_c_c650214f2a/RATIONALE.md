# non_flat_state_arrays_c_c650214f2a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c650214f2ac6e1bfcb29571dd41c3b206ac2dfd8 ("fix non-flat state arrays in c-api aggregate code"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/capi/v1/capi_aggregate_functions.cpp::Test Aggregate Functions C API
- cpp:test/api/capi/v2/test_capi_v2_aggregate_function.cpp::V2 aggregate: register on connection and execute

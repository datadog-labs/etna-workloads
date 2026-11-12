# avoid_overwriting_streaming_nth_value_cb273d912b

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit cb273d912b3657e009ac7259f2a15173ebde528f ("Avoid overwriting streaming NTH_VALUE result on NULL rows"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_streaming_nthvalue.test

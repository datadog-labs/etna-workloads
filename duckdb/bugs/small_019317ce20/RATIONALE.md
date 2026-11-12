# small_019317ce20

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 019317ce20997142140aa84077a48d3f2dc4a8f5 ("small fixes"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/capi/v2/test_capi_v2_arrow.cpp::V2 arrow result: functions guard null arguments

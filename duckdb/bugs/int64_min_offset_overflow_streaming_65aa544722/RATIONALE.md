# int64_min_offset_overflow_streaming_65aa544722

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 65aa54472274cd4f3acf9874bce5baeedbcbe0d3 ("Fix INT64_MIN offset overflow in streaming LEAD/LAG"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_streaming_lead_lag.test

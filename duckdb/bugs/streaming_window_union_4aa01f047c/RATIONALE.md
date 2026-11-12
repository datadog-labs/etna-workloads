# streaming_window_union_4aa01f047c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 4aa01f047c02e3ee7e6c6c50073e92b4b79496ec ("Issue #25701: Streaming Window UNION"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_streaming_lead_lag.test

# reset_streaming_window_argument_vector_1c3b9bdf9a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1c3b9bdf9a46c7d9bd69f1751066edaff3ed9cfa ("Reset the streaming window argument vector between chunks"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_streaming_window.test

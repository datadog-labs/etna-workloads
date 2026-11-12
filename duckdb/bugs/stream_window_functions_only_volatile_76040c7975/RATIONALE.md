# stream_window_functions_only_volatile_76040c7975

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 76040c7975becea52bbf76f8ebf9158962d9f6ed ("Stream window functions only when volatile arguments run once per row"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/general/test_25700.test

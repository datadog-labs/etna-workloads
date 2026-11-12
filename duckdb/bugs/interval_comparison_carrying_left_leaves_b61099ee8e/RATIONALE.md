# interval_comparison_carrying_left_leaves_b61099ee8e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit b61099ee8e5e1ca32bfa58e9472a092fb09a57e1 ("Fix interval comparison when carrying left leaves a negative field"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/interval/test_interval_comparison.test
- test/sql/window/test_window_interval.test

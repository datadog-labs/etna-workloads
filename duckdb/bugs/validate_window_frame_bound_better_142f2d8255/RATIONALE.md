# validate_window_frame_bound_better_142f2d8255

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 142f2d825552b043f68ade8ba58bcfa7c5dea2f9 ("Validate window frame bound better"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_invalid_window.test

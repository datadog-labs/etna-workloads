# volatile_windowing_31192eac36

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 31192eac3622370195f0de98297f0701790ac430 ("Issue #24830: Volatile Windowing"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/unused_window_columns.test
- test/sql/window/test_window_binding.test

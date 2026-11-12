# windowed_distinct_custom_0dbf363075

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 0dbf363075317d357490aaeb34309b10ce2734a9 ("Issue #24455: Windowed Distinct Custom"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_window_distinct.test

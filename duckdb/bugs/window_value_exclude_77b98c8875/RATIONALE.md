# window_value_exclude_77b98c8875

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 77b98c887510cde19ae021ce71520d805ffb1181 ("Issue #23640: Window Value EXCLUDE"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_value_exclude.test

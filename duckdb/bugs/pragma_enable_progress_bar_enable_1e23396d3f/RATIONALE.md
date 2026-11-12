# pragma_enable_progress_bar_enable_1e23396d3f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1e23396d3fc54a389c60676851e46913d3204346 ("Fix PRAGMA enable_progress_bar and enable_progress_bar_print NULL handling"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/settings/test_progress_bar_null.test

# don_t_allow_distinct_without_6e0bec50ce

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 6e0bec50ce500b7da09faccf59a4d5d3f2684901 ("Don't allow distinct without any arguments"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/aggregate/aggregates/test_count.test
- test/sql/window/test_window_distinct.test

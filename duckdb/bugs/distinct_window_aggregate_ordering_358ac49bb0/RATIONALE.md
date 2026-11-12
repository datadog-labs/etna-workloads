# distinct_window_aggregate_ordering_358ac49bb0

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 358ac49bb016a37caea7254e279ebac97347065b ("Fix distinct window aggregate ordering"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_window_distinct.test

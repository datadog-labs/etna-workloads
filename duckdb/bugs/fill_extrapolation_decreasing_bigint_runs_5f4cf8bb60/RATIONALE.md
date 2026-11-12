# fill_extrapolation_decreasing_bigint_runs_5f4cf8bb60

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 5f4cf8bb60070b4b3ebda0ef2ff97f5979b29445 ("Fix FILL extrapolation for decreasing BIGINT runs (#26042)"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_fill_orderby.test

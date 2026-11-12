# negative_time_intervals_f2118e9a97

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f2118e9a97cb0c949281564c1bd94411e8090ad9 ("Issue #8512: Negative Time Intervals"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/interval/test_interval.test

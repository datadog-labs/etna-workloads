# various_stats_tests_06b43f3c05

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 06b43f3c05ed8dccc466e0ad00abf76de7799a97 ("Fix various stats tests"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/parquet/parquet_stats_function.test

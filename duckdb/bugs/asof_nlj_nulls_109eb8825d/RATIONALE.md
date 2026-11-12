# asof_nlj_nulls_109eb8825d

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 109eb8825db491831b2a2105f8eb24e450c4937e ("Issue #18303: AsOf NLJ Nulls"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/join/asof/test_asof_join_timestamps.test

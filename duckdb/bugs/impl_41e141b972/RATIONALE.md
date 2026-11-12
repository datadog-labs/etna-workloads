# impl_41e141b972

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 41e141b972e0217c56ccf735a24ff85fb2a8ebc0 ("impl fix"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/statistics/statistics_unsigned_arithmetic_pruning.test

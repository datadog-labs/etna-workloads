# regression_double_filter_cardinality_estimation_444c6f519a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 444c6f519a2d7a3450fd99a0f6937ab70664cc5f ("fix regression double filter cardinality estimation"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/statistics/statistics_early_join_range.test

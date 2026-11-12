# floating_point_comparison_770c1644f6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 770c1644f6d73a385c8eb3b1e19798f6643c1772 ("Fix floating point comparison (NaN)"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/topn_window_elimination.test_slow
- test/sql/aggregate/aggregates/arg_min_max_nulls_last.test

# percentile_cont_disc_descending_order_fdae4d8961

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit fdae4d8961a036bc415726d307ed656c6bf241a1 ("Fix percentile_cont/disc(0) with descending order"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/aggregate/aggregates/test_quantile_cont.test
- test/sql/aggregate/aggregates/test_quantile_disc.test

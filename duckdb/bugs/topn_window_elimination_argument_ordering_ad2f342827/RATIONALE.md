# topn_window_elimination_argument_ordering_ad2f342827

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ad2f342827098be210909d7577be58db7577521f ("Fix TopN window elimination with argument ordering"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/topn_window_elimination_argument_order.test

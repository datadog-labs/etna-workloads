# require_full_window_order_by_8b3f30cc90

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 8b3f30cc902e90879a3e61b82be175a23cdbef60 ("Require full window ORDER BY match for peer-based ranking arg orders"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_cume_dist_orderby.test
- test/sql/window/test_rank_orderby.test

# topn_only_follow_order_preserving_7561e30da9

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 7561e30da971522aedf3479df557da8f8decaabe ("topn: only follow order-preserving cast chains for topn and row-group pruning"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/topn/topn_dynamic_filter_cast.test

# use_after_free_multi_column_26cd798cb7

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 26cd798cb7047427c80d7fb2f9631a28dcc67a9b ("Fix use-after-free in multi-column filter pruning"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/pushdown_extract_multiple_filters.test

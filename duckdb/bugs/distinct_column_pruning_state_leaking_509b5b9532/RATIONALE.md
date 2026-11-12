# distinct_column_pruning_state_leaking_509b5b9532

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 509b5b9532f75282e00c298de8c3ece678ac7394 ("Fix DISTINCT column pruning state leaking into sibling inputs"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/distinct_sibling_column_pruning.test

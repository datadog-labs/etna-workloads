# prune_always_true_case_63659402e3

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 63659402e35deed38d69cef5796abcc81c2074a9 ("prune for ALWAYS_TRUE case"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/in_list_row_group_pruning.test

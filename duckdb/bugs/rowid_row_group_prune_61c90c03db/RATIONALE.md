# rowid_row_group_prune_61c90c03db

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 61c90c03dbf2ff5bed11d7d5ec41ec61df56f5f4 ("Fix rowid row group prune"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/test_rowid_pruning.test

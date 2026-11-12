# add_test_48d350dde5

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 48d350dde546a2268aec20f46e86ab7937c777f8 ("Add test and fix"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/topn/test_top_n_distinct_row_group_pruner.test

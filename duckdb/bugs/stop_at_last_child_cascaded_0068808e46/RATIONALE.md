# stop_at_last_child_cascaded_0068808e46

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 0068808e4653c50a6ffd534eb5c2a566a54e0416 ("Stop at the last child in the cascaded levels of MergeSortTree::SelectNth"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_last_ignore_nulls_large_partition.test

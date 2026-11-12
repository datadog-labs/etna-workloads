# track_window_merge_sort_tree_a802c5f852

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a802c5f852831aa4aa6f30e626e93e582625c9f6 ("Track window merge sort tree and aggregate state memory"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/window_distinct_memory_limit.test

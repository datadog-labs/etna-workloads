# compare_window_partitions_as_sets_cd7b9e4686

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit cd7b9e4686edbb33835d5808881bc83be5cc8a39 ("Compare window partitions as sets"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_duplicate_partition.test

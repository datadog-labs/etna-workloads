# hang_partitionedcopystate_regression_test_fa0224b793

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit fa0224b79300b7d9c417370954ef0a743693d3c4 ("Fix hang in PartitionedCopyState with regression test"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/partitioned/partitioned_order_by_flush_race.test

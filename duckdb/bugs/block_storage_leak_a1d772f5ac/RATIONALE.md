# block_storage_leak_a1d772f5ac

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a1d772f5acd411ffd3b06312d9174733677554af ("fix block storage leak"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/reclaim_space/reclaim_space_drop_table_optimistic.test

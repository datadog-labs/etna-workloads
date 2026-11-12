# validity_column_update_check_zonemap_9ace902689

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9ace9026899b28c47533e969ed5e02ce31dd8e35 ("Fix validity column update check in zonemap"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/wal/wal_null_update_row_group_pruning.test

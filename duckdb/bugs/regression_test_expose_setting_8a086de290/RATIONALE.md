# regression_test_expose_setting_8a086de290

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 8a086de2901d5987330c7309e9b81fa66431bf1b ("regression test and expose setting"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/wal/wal_torn_uncommitted_row_group.test

# indexed_delete_column_resolution_9a01408078

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9a01408078f2e53054283d4c1731c654e7b9d4fa ("Fix indexed DELETE column resolution"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/delete/test_delete_indexed.test

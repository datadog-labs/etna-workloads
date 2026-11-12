# internal_around_alter_table_add_63c2483d76

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 63c2483d7638b6c57164a171df4ea8a877d7924e ("Fix internal issue around alter table add column that did not exist"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/peg_parser/fuzzer/internal_0227.test

# alter_table_alter_column_using_09c4abc4b6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 09c4abc4b695a2a5f83e5a10995996e2863fa896 ("Fix ALTER TABLE ALTER column USING NULL"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/alter/alter_type/test_alter_type_using_not_null.test

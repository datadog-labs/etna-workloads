# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4aa6fa3cd0a2422f1bb47db837b82f2b53d4c065 ("Include schema/table publications even with exclude options in dump."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/pg_dump/pg_dump.c

Failing oracle cases:
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_dump_test_schema: should dump ALTER PUBLICATION pub1 ADD TABLE test_second_table`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_dump_test_schema: should dump ALTER PUBLICATION pub1 ADD TABLE test_seventh_table (col3, col2) WHERE (col1 = 1)`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_dump_test_schema: should dump ALTER PUBLICATION pub1 ADD TABLE test_sixth_table (col3, col2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_dump_test_schema: should dump ALTER PUBLICATION pub1 ADD TABLE test_table`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_dump_test_schema: should dump ALTER PUBLICATION pub3 ADD TABLE test_table`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_dump_test_schema: should dump ALTER PUBLICATION pub3 ADD TABLES IN SCHEMA dump_test`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_dump_test_schema: should dump ALTER PUBLICATION pub4 ADD TABLE test_second_table WHERE (col2 = 'test');`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_dump_test_schema: should dump ALTER PUBLICATION pub4 ADD TABLE test_table WHERE (col1 > 0);`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_test_table: should dump ALTER PUBLICATION pub1 ADD TABLE test_table`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_test_table: should dump ALTER PUBLICATION pub3 ADD TABLE test_table`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_test_table: should dump ALTER PUBLICATION pub4 ADD TABLE test_table WHERE (col1 > 0);`

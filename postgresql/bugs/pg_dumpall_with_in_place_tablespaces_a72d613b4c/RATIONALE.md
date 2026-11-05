# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a72d613b4c91462d9405c4e1b05c42d33013c333 ("Fix pg_dumpall with in-place tablespaces"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/pg_dump/pg_dumpall.c

Failing oracle cases:
- `src/bin/pg_dump|t/002_pg_dump.pl|pg_dumpall_dbprivs: should dump CREATE TABLESPACE regress_dump_tablespace`
- `src/bin/pg_dump|t/002_pg_dump.pl|pg_dumpall_exclude: should dump CREATE TABLESPACE regress_dump_tablespace`
- `src/bin/pg_dump|t/002_pg_dump.pl|pg_dumpall_globals: should dump CREATE TABLESPACE regress_dump_tablespace`
- `src/bin/pg_dump|t/002_pg_dump.pl|pg_dumpall_globals_clean: should dump CREATE TABLESPACE regress_dump_tablespace`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 13a67ce6034ed674a4e797c6f1545831189be02e ("Convert newlines to spaces in names written in v11+ pg_dump comments."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/pg_dump/dumputils.c, src/bin/pg_dump/dumputils.h, src/bin/pg_dump/pg_backup_archiver.c, src/bin/pg_dump/pg_dump.c, src/bin/pg_dump/pg_dumpall.c

Failing oracle cases:
- `src/bin/pg_dump|t/002_pg_dump.pl|clean: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|clean_if_exists: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|column_inserts: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_gzip_custom: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_gzip_dir: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_gzip_plain: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_lz4_custom: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|createdb: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|data_only: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_custom_format: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_dir_format: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_parallel: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_tar_format: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_dump_test_schema: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_measurement: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_measurement_data: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_test_table: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_test_table_data: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|inserts: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_large_objects: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_owner: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_policies: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_policies_restore: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_privs: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_schema: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_statistics: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_subscriptions: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_subscriptions_restore: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_table_access_method: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_toast_compression: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|pg_dumpall_dbprivs: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|pg_dumpall_exclude: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|pg_dumpall_globals: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|pg_dumpall_globals_clean: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/002_pg_dump.pl|section_data: should not dump newline of role or table name in comment`
- `src/bin/pg_dump|t/003_pg_dump_with_server.pl|newline in dbname: no comment escape`

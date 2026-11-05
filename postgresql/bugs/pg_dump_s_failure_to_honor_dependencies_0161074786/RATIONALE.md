# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 01610747867ff26ca62d099e83e62d97730c40c1 ("Fix pg_dump's failure to honor dependencies of SQL functions."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/bin/pg_dump/pg_dump.c, src/bin/pg_dump/pg_dump.h, src/bin/pg_dump/pg_dump_sort.c

Failing oracle cases:
- `src/bin/pg_dump|t/002_pg_dump.pl|binary_upgrade: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|clean: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|clean_if_exists: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_gzip_custom: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_gzip_dir: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_gzip_plain: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_lz4_custom: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|createdb: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_custom_format: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_dir_format: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_parallel: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_tar_format: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_measurement: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_measurement_data: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_test_table: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_test_table_data: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_large_objects: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_owner: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_policies: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_policies_restore: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_privs: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_statistics: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_subscriptions: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_subscriptions_restore: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_table_access_method: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_toast_compression: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|only_dump_test_schema: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|pg_dumpall_dbprivs: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|pg_dumpall_exclude: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|schema_only: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|section_post_data: should dump Check ordering of a function that depends on a primary key`
- `src/bin/pg_dump|t/002_pg_dump.pl|test_schema_plus_large_objects: should dump Check ordering of a function that depends on a primary key`

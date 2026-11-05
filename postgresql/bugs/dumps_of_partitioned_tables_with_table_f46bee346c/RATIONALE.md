# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f46bee346c3b6aab0a0f3f39dc734732b79ce1ed ("Fix dumps of partitioned tables with table AMs"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/pg_dump/pg_backup_archiver.c, src/bin/pg_dump/pg_backup_archiver.h, src/bin/pg_dump/pg_dump.c

Failing oracle cases:
- `src/bin/pg_dump|t/002_pg_dump.pl|binary_upgrade: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|clean: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|clean_if_exists: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_gzip_custom: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_gzip_dir: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_gzip_plain: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_lz4_custom: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|createdb: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_custom_format: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_dir_format: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_parallel: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_tar_format: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_measurement: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_measurement_data: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_test_table: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_test_table_data: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_large_objects: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_owner: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_policies: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_policies_restore: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_privs: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_statistics: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_subscriptions: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_subscriptions_restore: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_toast_compression: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|only_dump_test_schema: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|pg_dumpall_dbprivs: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|pg_dumpall_exclude: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|schema_only: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|section_pre_data: should dump CREATE TABLE regress_pg_dump_table_part`
- `src/bin/pg_dump|t/002_pg_dump.pl|test_schema_plus_large_objects: should dump CREATE TABLE regress_pg_dump_table_part`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 13380e1476490932c7b15530ead1f649a16e1125 ("Don't print extra parens around expressions in extended stats"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/ruleutils.c

Failing oracle cases:
- `src/bin/pg_dump|t/002_pg_dump.pl|binary_upgrade: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|clean: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|clean_if_exists: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_gzip_custom: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_gzip_dir: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_gzip_plain: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_lz4_custom: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|createdb: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_custom_format: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_dir_format: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_parallel: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_tar_format: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_measurement: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_measurement_data: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_test_table: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_test_table_data: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_large_objects: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_owner: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_policies: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_policies_restore: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_privs: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_statistics: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_subscriptions: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_subscriptions_restore: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_table_access_method: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_toast_compression: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|only_dump_test_schema: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|pg_dumpall_dbprivs: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|pg_dumpall_exclude: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|schema_only: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|section_post_data: should dump CREATE STATISTICS extended_stats_expression`
- `src/bin/pg_dump|t/002_pg_dump.pl|test_schema_plus_large_objects: should dump CREATE STATISTICS extended_stats_expression`
- `src/test/regress||create_table_like`
- `src/test/regress||stats_ext`

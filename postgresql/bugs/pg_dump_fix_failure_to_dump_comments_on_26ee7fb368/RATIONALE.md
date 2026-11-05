# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 26ee7fb3684e5809d663f74847fb405f5a84d1af ("pg_dump: fix failure to dump comments on constraints in some cases."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/pg_dump/pg_dump.c

Failing oracle cases:
- `src/bin/pg_dump|t/002_pg_dump.pl|binary_upgrade: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|clean: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|clean_if_exists: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_gzip_custom: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_gzip_dir: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_gzip_plain: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_lz4_custom: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|createdb: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_custom_format: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_dir_format: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_parallel: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_tar_format: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_measurement: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_measurement_data: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_test_table: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|exclude_test_table_data: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_large_objects: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_owner: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_policies: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_policies_restore: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_privs: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_statistics: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_subscriptions: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_subscriptions_restore: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_table_access_method: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|no_toast_compression: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|only_dump_test_schema: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|pg_dumpall_dbprivs: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|pg_dumpall_exclude: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|schema_only: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|section_pre_data: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`
- `src/bin/pg_dump|t/002_pg_dump.pl|test_schema_plus_large_objects: should dump COMMENT ON CONSTRAINT ON DOMAIN (2)`

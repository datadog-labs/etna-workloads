# do_properly_handle_filesystem_level_3caa7b778a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 3caa7b778a67a9e38a4fbf13a7fecf3374b92621 ("Do properly handle FileSystem level case-insensivity"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/parquet/parquet_hive_null.test

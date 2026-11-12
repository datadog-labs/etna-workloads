# update_some_error_messages_c322dde05e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c322dde05e55fef8b521246dc2f2c48740caf932 ("Update some error messages"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/partitioned/hive_partitioned_write.test
- test/sql/copy/partitioned/order_by_without_partition.test
- test/sql/copy/partitioned/partition_by_syntax.test

# drop_column_corrupting_per_column_85cb40224a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 85cb40224add0c405a95b501f9fb760213594d28 ("Fix DROP COLUMN corrupting per-column metadata block bookkeeping"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/metadata/partial_column_metadata_reuse_drop_column.test

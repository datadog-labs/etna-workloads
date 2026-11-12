# preserve_transient_block_reuse_across_be546f89c4

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit be546f89c4eb93e0d5b19f72fd56dbcc53d13048 ("Preserve transient block reuse across row-group transitions"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/ctas_transient_row_groups.test_slow

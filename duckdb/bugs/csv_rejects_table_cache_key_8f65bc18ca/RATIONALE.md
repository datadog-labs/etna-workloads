# csv_rejects_table_cache_key_8f65bc18ca

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 8f65bc18ca9cdda28049a1c09b3f03e4790b7761 ("Fix CSV rejects table cache key collision"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/rejects/csv_rejects_cache_key_collision.test

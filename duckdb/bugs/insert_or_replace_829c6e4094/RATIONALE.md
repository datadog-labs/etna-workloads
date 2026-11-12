# insert_or_replace_829c6e4094

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 829c6e4094b3d59bcdc1645db7b0bac3e0e0ff90 ("fix insert or replace"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/upsert/insert_or_replace/generated_column.test

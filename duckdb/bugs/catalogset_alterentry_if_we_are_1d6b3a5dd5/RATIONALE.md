# catalogset_alterentry_if_we_are_1d6b3a5dd5

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1d6b3a5dd5cc61aff2a266787953ac225c334626 ("For CatalogSet::AlterEntry - if we are doing an alter without a transaction present, we can directly destroy the child entry instead of leaving it dangling"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/index/art/storage/test_art_duckdb_versions.test

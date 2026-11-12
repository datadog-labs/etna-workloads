# duckdb_ubs_keep_coalesce_catalog_2eefd4c100

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 2eefd4c100ead1e62401b01eb9e55e9658139ec0 ("duckdb-ubs: keep coalesce a catalog lookup on the plain path, reject modifiers on the chain"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/parser/parser_rewrites_method_chain.test

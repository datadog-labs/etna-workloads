# register_catalog_read_table_functions_d12ac36618

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d12ac36618687e5f8a302aa490e00f172ab5d53a ("Register catalog read for table functions that bind a catalog entry"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/prepared/prepare_catalog_table_functions.test

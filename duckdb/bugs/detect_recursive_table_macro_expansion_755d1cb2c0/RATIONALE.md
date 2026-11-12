# detect_recursive_table_macro_expansion_755d1cb2c0

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 755d1cb2c03f1ae28bb2fa01599190666ab4c118 ("Detect recursive table macro expansion"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/catalog/function/test_recursive_table_macro.test

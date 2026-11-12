# positional_column_references_macro_arguments_56c9a78e3f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 56c9a78e3f85e3812372bb09ebb0975a1ddc2c7c ("Fix positional column references in macro arguments"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/catalog/function/test_macro_positional_reference.test

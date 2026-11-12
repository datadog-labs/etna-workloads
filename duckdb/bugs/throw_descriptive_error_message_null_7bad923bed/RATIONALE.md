# throw_descriptive_error_message_null_7bad923bed

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 7bad923bed727eef4c83467948be113019da4c77 ("Fix #13227 - throw a descriptive error message on NULL value inputs to COLUMNS()"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/parser/test_columns.test

# don_t_allow_duplicate_options_27c03d0fdc

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 27c03d0fdce8abcec20c86a2e09ad45e942315e5 ("Don't allow duplicate options"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/export/export_database.test
- test/sql/peg_parser/transformer/attach_statement.test

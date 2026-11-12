# missing_foreign_key_error_message_b0b2e70b63

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit b0b2e70b638657291eb6379f5960663235dc03d2 ("Fix missing foreign key error message"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/constraints/foreignkey/fk_19469.test

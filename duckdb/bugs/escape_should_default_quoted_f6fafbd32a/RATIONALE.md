# escape_should_default_quoted_f6fafbd32a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f6fafbd32ab91112262676f752dbfcec47aaff68 ("Escape should default to quoted"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/struct.test

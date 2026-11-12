# silent_truncation_very_long_integer_fd20b1b501

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit fd20b1b501982f375eb0bea30a00c6121d56f500 ("Fix silent truncation of very long integer literals into HUGEINT"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/hugeint/test_hugeint_conversion.test

# multiple_column_collations_are_not_19169003ae

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 19169003ae810a6c0a8365123cca90969917b514 ("Multiple column collations are not allowed"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/collate/test_unsupported_collations.test

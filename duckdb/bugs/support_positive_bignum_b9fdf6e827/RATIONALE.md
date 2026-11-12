# support_positive_bignum_b9fdf6e827

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit b9fdf6e8275377c75f7afc5cdc223eb86e4b0272 ("support positive bignum"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/auto/test_large_integer_detection.test

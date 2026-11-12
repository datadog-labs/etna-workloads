# fuzzer_39_correlated_columns_not_6baa6c9bfc

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 6baa6c9bfcdf3e98e95ef3d12aab396e0c8d9d0c ("Fix fuzzer 39: correlated columns not supported in LIMIT/OFFSET"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/fuzzer/pedro/nested_limit_subquery.test

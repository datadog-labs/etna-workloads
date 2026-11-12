# throw_error_reading_corrupt_statistics_0bab1fdb0a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 0bab1fdb0a73c269f0b779f3345cd9dd836b4079 ("Fix #14430 - throw an error when reading corrupt statistics in the perfect hash aggregate"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/parquet/corrupt_stats.test

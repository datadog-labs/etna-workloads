# single_entry_missing_parquet_a70b819397

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a70b8193971e0d4015c5dd1cd6b90d3eab9021f7 ("single entry of missing parquet"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/zstd_crash.test

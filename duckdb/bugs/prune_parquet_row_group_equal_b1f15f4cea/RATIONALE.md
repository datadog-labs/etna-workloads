# prune_parquet_row_group_equal_b1f15f4cea

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit b1f15f4cea26c816a3129e6e789a1b9abc4acd2e ("Prune parquet row group for equal between"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/parquet/bloom_filters.test

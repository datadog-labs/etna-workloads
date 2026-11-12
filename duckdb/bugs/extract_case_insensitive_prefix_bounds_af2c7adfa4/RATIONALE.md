# extract_case_insensitive_prefix_bounds_af2c7adfa4

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit af2c7adfa4833bbcd33cd3c3796c9dd93185b037 ("Extract case-insensitive prefix bounds"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/parquet/parquet_expression_filter_pruning.test

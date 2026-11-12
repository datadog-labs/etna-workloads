# filter_combiner_not_pruning_unsatisfiable_0639f07470

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 0639f074709420ea5aa9bfb1958c6f36e186bbf8 ("Fix filter combiner not pruning unsatisfiable bounds at same constant"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/transitive_filters.test
- test/sql/copy/parquet/parquet_hive.test

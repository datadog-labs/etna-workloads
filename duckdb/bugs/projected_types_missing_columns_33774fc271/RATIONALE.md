# projected_types_missing_columns_33774fc271

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 33774fc271c6c7548698396e4f5c07b5350c46ab ("Fix projected types for missing columns"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/parquet/union_by_name_struct_projection.test

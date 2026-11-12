# columnindex_path_preservation_different_cast_fd836f16c6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit fd836f16c612e84dfbca1bbcd4123d9337cfc4a2 ("fixes to ColumnIndex path preservation with different cast types, projection eligibility (in RemoveUnusedColumns) uses unique paths instead of child paths"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/types/variant/variant_struct_field_subquery.test
- test/sql/types/struct/struct_cast_parent_path_order.test
- test/sql/types/variant/variant_cast_parent_path_order.test
- test/sql/types/variant/variant_struct_cast_parent_projection.test
- test/sql/types/variant/variant_struct_field_subquery_cast_parent.test

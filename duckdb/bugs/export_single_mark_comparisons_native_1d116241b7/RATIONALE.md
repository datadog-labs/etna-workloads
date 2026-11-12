# export_single_mark_comparisons_native_1d116241b7

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1d116241b7266290eb060e43481f8dca8764137a ("Export single MARK comparisons with native NULL semantics"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/sql_export/mark_condition_shapes.test
- test/sql/sql_export/mark_nested_comparison_roundtrip.test
- test/sql/sql_export/mark_results.test

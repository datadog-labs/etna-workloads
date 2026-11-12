# preserve_nested_result_collations_exported_6d6d57a709

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 6d6d57a7099ca75bf8f3f4384291e889ecacaba9 ("Preserve nested result collations in exported expressions"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/sql_export/nested_result_collation.test

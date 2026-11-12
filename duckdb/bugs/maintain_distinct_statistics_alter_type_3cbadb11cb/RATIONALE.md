# maintain_distinct_statistics_alter_type_3cbadb11cb

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 3cbadb11cb3c7d9eaa94a79476bd9b5c8c8fdb76 ("Maintain distinct statistics on ALTER TYPE and ADD COLUMN"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/alter/add_col/test_add_col_distinct_stats.test
- test/sql/alter/alter_type/alter_type_distinct_stats.test

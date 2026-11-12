# add_columns_expansion_support_distinct_9c2a76414b

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9c2a76414bbd01fe59e1588b08dbb20d28341e0d ("Add COLUMNS() expansion support to DISTINCT ON"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/aggregate/distinct/test_distinct_on_columns.test

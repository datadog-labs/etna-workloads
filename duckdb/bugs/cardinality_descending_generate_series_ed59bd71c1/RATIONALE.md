# cardinality_descending_generate_series_ed59bd71c1

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ed59bd71c187052a113aafd1a521f27a1ad0c766 ("Fix cardinality for descending generate_series"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/table_function/test_range_function.test

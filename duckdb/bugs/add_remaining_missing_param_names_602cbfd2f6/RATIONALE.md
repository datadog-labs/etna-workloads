# add_remaining_missing_param_names_602cbfd2f6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 602cbfd2f67742eef552b4a29ee94be1e586c418 ("Add remaining missing param names: finalize, combine, setseed, getenv"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/table_function/duckdb_functions.test_slow

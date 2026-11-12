# some_more_erros_2e2ab7ab15

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 2e2ab7ab158521d51868e427a653f189f50e14f1 ("Fix some more erros"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/generated_columns/virtual/create_table.test
- test/sql/generated_columns/virtual/update.test

# only_rewrite_row_number_over_bd0f404286

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit bd0f404286c4811725f1e4322a1fb9bf6c9a6c3e ("Only rewrite ROW_NUMBER() OVER () onto a scan's virtual row_number for base tables"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/row_number_virtual_column.test

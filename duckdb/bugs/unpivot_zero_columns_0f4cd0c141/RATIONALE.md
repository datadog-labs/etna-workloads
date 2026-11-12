# unpivot_zero_columns_0f4cd0c141

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 0f4cd0c1413236bb9c782898654592be3ee95841 ("Fix for unpivot on zero columns"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/pivot/unpivot_no_columns.test

# row_group_pruning_boolean_columns_f6adf01a34

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f6adf01a3451cd8d0fd47f4e714a0bdbc349baad ("Row-group pruning on boolean columns via NumericStats zonemap"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/boolean_row_group_pruning.test

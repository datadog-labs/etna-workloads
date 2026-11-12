# column_pruning_sibling_inputs_beside_229f908731

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 229f908731472d2a4738f93ab1c9255e883dbd74 ("Fix column pruning of sibling inputs beside materialized CTEs"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/materialized_cte_sibling_column_pruning.test

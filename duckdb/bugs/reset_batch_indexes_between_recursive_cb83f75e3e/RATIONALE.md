# reset_batch_indexes_between_recursive_cb83f75e3e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit cb83f75e3e087f0d9bb7b693368032d1a978fd5e ("Reset batch indexes between recursive CTE iterations"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/cte/recursive_cte_batch_index.test

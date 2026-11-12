# asof_join_over_except_all_03dcdeed86

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 03dcdeed86dd23080fe5a3223d7700323f988b35 ("Fix ASOF join over EXCEPT ALL / INTERSECT ALL children"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/join/asof/test_asof_join_setops.test

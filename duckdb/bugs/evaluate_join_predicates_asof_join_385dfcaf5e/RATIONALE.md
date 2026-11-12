# evaluate_join_predicates_asof_join_385dfcaf5e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 385dfcaf5e3e0c6250b7576e285850d072b7b60e ("Evaluate the join predicates of an ASOF JOIN on an IS NOT DISTINCT FROM key"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/join/asof/test_asof_join_not_distinct_predicate.test

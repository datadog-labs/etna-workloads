# do_not_plan_nested_loop_e2897af66b

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e2897af66bc86e0479ec2865c5c90f3d1f24acd8 ("Do not plan a nested loop join without a comparison condition"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/statistics/statistics_join_arbitrary_condition.test

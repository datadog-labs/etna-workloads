# do_not_push_down_prefix_e90ad3cff6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e90ad3cff6fe4209fbca60be7fcae8df889a1f8d ("Do not push down a prefix filter when the pattern is NULL"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/pushdown/prefix_pushdown_null_constant.test

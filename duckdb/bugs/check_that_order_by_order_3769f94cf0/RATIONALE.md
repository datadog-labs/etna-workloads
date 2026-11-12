# check_that_order_by_order_3769f94cf0

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 3769f94cf0170c87a5e91e0cf2343b690e9fb971 ("Check that the ORDER BY 'order' field of to_aggregate_state is a string"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/aggregate/aggregate_state_export/ordered_aggregate_export_state.test

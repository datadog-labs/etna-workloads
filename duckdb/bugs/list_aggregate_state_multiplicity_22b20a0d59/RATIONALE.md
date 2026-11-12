# list_aggregate_state_multiplicity_22b20a0d59

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 22b20a0d591f08478ba88c0a1dbe91f39b863c7e ("Fix LIST aggregate state multiplicity"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/general/test_24806.test
- test/sql/aggregate/aggregate_state_export/test_combine_aggr.test

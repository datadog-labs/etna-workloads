# skip_common_subplans_whose_primary_d5eb0327d0

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d5eb0327d0ea6cd470355eb80845a9c448baf69d ("Skip common subplans whose primary no longer exposes required bindings"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/test_common_subplan_nested_bindings.test

# keep_plan_alive_executor_initialization_b86337f079

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit b86337f079a05573f0f4494af044e2eb39d08472 ("Keep the plan alive when executor initialization throws"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/general/test_26274.test

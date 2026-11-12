# finalize_retained_results_task_1b4bb70940

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1b4bb70940b9ead967cf446236bbfe48cdd42c93 ("Finalize retained results in a task"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_query_result_format.cpp::A throwing CreateCollection on an empty result surfaces as the result's error
- cpp:test/api/test_query_result_format.cpp::A throwing Finalize does not deadlock Connection::Query
- cpp:test/api/test_query_result_format.cpp::A throwing Finalize surfaces from Submit and Complete without escaping and a second Complete keeps it

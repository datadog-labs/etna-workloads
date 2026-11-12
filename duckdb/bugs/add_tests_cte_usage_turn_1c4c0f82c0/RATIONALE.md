# add_tests_cte_usage_turn_1c4c0f82c0

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1c4c0f82c0e990cc98f6d4ff3edc5f3f94d7bcd9 ("add tests for CTE usage and turn the exception into not-implemented to disable serialization in this path, without breaking the query entirely"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/arrow/arrow_roundtrip.cpp::Arrow scan view supports repeated CTE references
- cpp:test/arrow/arrow_roundtrip.cpp::Arrow scan view supports serializer verification

# add_missing_expression_traversal_merge_a45a33fc9d

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a45a33fc9d2baaf7eb050dacefee25ad4070f3dc ("Add missing expression traversal in merge into binding"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/general/test_20991.test

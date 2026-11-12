# common_aggregate_ctes_49a9a3a391

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 49a9a3a391360be2f97de3b9b415a222cb6ececd ("Issue #23383: Common Aggregate CTEs"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/expression/test_common_aggregate.test

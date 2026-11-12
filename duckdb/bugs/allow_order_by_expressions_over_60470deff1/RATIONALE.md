# allow_order_by_expressions_over_60470deff1

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 60470deff1bf27973c0e2935ade39211307137bf ("Allow ORDER BY expressions over the result of a set operation"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/order/test_order_by.test
- test/sql/setops/union_order_by_expression.test

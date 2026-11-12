# lead_lag_argument_order_by_5e2d737191

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 5e2d7371916f3c2a4ce4320b2d863aad3b918f59 ("Fix LEAD/LAG with an argument ORDER BY over a frame that excludes the own row"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_leadlag_orderby.test

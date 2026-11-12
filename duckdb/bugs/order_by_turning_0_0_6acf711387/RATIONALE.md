# order_by_turning_0_0_6acf711387

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 6acf711387d2bf6c23fafb8a8257cb15f64bb18e ("Fix ORDER BY turning -0.0 into 0.0 for FLOAT/DOUBLE columns"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/order/order_by_negative_zero.test

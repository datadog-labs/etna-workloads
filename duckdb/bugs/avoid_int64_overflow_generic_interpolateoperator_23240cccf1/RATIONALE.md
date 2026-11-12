# avoid_int64_overflow_generic_interpolateoperator_23240cccf1

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 23240cccf1e30057c6c61f71b170b8a6cdd4256f ("fix: avoid int64 overflow in generic InterpolateOperator for fill()"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_fill_orderby.test

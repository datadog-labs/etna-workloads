# range_zero_7099a85961

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 7099a8596192169015e8b688bf911efbcc7d8076 ("Issue #23664: RANGE ZERO"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_boundary_expr.test

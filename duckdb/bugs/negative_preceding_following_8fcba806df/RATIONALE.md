# negative_preceding_following_8fcba806df

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 8fcba806df8f6f8ab7a79cd35a05896ac02105b1 ("Issue #24307: Negative PRECEDING FOLLOWING"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_boundary_expr.test

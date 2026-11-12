# optimizer_restrict_equal_or_null_cc71908bf2

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit cc71908bf28e10d8e12e253d8052678d4ba36b05 ("Optimizer: restrict equal-or-null rewrite in joins"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/expression/test_equal_or_null_optimization.test

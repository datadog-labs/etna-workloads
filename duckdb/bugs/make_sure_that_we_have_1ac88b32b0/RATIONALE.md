# make_sure_that_we_have_1ac88b32b0

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1ac88b32b0a6bacc6114b44388e4442b33d39dfe ("Make sure that we have a column on the LHS, not an expression."), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/date_trunc_simplification.test

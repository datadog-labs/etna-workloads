# push_down_scalar_functions_queries_59ff8f18a5

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 59ff8f18a5ca4bb576da8dd2dc0bd58fb35f5f50 ("push down scalar functions for queries with LIMIT"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/pushdown/scalar_function_pushdown_limit.test

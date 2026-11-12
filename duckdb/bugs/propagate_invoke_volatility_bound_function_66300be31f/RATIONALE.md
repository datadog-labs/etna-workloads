# propagate_invoke_volatility_bound_function_66300be31f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 66300be31f39d9c3c4c510226a62eac9408d16d6 ("Propagate invoke volatility to bound function"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/generic/invoke.test

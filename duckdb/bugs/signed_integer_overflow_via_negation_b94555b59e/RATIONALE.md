# signed_integer_overflow_via_negation_b94555b59e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit b94555b59e58941bf42da1aeb8f3251850b85e8f ("Fix signed integer overflow via negation of INT64_MIN interval microseconds"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/test_interval_negation_overflow.test

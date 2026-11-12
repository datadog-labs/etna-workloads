# negate_operator_wrap_around_be3a89fcd3

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit be3a89fcd34d17fcc0469f78820f484afddd7658 ("Fix negate operator wrap around"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/uhugeint/test_uhugeint_arithmetic.test

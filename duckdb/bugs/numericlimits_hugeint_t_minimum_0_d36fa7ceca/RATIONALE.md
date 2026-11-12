# numericlimits_hugeint_t_minimum_0_d36fa7ceca

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d36fa7cecad54c8d579ee1b43150d2007e3fdae4 ("Fix NumericLimits<hugeint_t>::Minimum() * 0 case"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/hugeint/test_hugeint_arithmetic.test

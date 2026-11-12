# several_integer_overflows_hugeint_add_4da6176fe1

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 4da6176fe13765a5bd34ae3f2276a76035c17300 ("Fix several integer overflows in hugeint add/subtract"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/hugeint/test_hugeint_arithmetic.test

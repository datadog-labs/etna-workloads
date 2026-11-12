# missing_setsizeandfinalize_bignum_add_zero_baaefc49d9

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit baaefc49d9fd4bf6833e1ba621c3e71badf9dd61 ("Fix missing SetSizeAndFinalize in BIGNUM Add for zero result case"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/bignum/test_bignum_subtract.test

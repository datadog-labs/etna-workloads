# fuzzer_35_correctly_check_overflows_31e22a0ba2

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 31e22a0ba28d00e29c86070d73971790b702dbc8 ("Fix fuzzer issue 35: correctly check overflows on casts from float/double to unsigned integers"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/fuzzer/pedro/floating_point_conversion_overflow.test

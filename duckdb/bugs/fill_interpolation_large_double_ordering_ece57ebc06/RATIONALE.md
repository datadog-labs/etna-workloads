# fill_interpolation_large_double_ordering_ece57ebc06

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ece57ebc0663b2b94ab3a3b4861404b50d5470f7 ("fix fill() interpolation for large DOUBLE ordering spans"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_fill_orderby.test

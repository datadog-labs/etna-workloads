# support_empty_string_cast_bit_02ac3177b3

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 02ac3177b34655f9d1c1bf8afd70b19e7eb7119f ("Support empty string cast to BIT"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/cast/test_bit_cast.test
- test/sql/types/bit/test_bit.test

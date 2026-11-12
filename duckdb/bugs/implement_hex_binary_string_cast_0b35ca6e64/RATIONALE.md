# implement_hex_binary_string_cast_0b35ca6e64

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 0b35ca6e6496d0716bc85c0d71e7824b2288867c ("Implement hex/binary string cast for HUGEINT/UHUGEINT"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/hugeint/test_hugeint_conversion.test
- test/sql/types/uhugeint/test_uhugeint_conversion.test

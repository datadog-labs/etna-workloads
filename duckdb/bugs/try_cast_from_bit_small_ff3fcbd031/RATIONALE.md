# try_cast_from_bit_small_ff3fcbd031

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ff3fcbd0312b8ceccedd15e87aa5e9c7bbe5554e ("Fix TRY_CAST from BIT to small integer types throwing instead of returning NULL"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/bit/bit_try_cast.test

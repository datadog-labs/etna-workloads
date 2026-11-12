# remap_struct_leaving_rows_uninitialized_253e849d36

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 253e849d366837cc9533be3c0541265176e408ce ("Fix remap_struct leaving rows uninitialized for constant MAP/LIST input"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/struct/remap_struct_constant_nested.test

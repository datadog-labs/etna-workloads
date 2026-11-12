# wrong_results_out_bounds_read_8f611cea6b

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 8f611cea6b867d4a163f4dcdca07f34a87b23bfa ("Fix wrong results and an out-of-bounds read in the LIST->ARRAY cast"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/nested/array/array_cast.test

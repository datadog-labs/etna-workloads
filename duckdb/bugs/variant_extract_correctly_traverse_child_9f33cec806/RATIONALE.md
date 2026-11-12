# variant_extract_correctly_traverse_child_9f33cec806

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9f33cec806ca7ca24e928f0dc467eeb83c2bb07e ("In variant_extract correctly traverse child stats during stats propagation"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/types/variant/variant_extract_stats.test

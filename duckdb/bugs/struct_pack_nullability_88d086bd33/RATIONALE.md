# struct_pack_nullability_88d086bd33

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 88d086bd33cc1699f5e01ae15aa6071014bb5d89 ("Fix struct_pack nullability"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/statistics/statistics_filter_pruning.test

# geometry_row_group_pruning_nulls_2b623b60ca

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 2b623b60ca5aef62e83b3ee932f4ca6f103a2be7 ("fix geometry row group pruning with nulls/emtpy"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/geo/geometry_intersection_filter_parquet.test
- test/sql/types/geo/geometry_stats_prune_null.test

# preserve_grouping_bindings_aggregate_rewrites_428e638246

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 428e638246d0c41f5f8eea320da183120eda17d5 ("Preserve GROUPING bindings in aggregate rewrites"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/general/test_23940.test

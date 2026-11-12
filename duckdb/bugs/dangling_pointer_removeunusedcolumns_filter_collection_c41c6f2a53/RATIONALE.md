# dangling_pointer_removeunusedcolumns_filter_collection_c41c6f2a53

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c41c6f2a53f5c0e1ce39b2765c1e3b05c9e6b4d3 ("Fix dangling pointer in RemoveUnusedColumns filter collection (#25430)"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/struct/struct_projection_pushdown_optimizer_bug.test

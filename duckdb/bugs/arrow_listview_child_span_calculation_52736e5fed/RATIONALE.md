# arrow_listview_child_span_calculation_52736e5fed

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 52736e5fed8e7602eeb5a9c397571f57f787161f ("Fix Arrow ListView child span calculation"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/arrow/arrow_list_view_nested_offset.cpp::Arrow scan of ListView with overlapping child ranges

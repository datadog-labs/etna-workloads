# column_data_allocator_8cbf98c7d1

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 8cbf98c7d131cb4cb434ba377f2929014393888b ("Fix column data allocator"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/common/test_column_data_allocator.cpp::ColumnDataAllocator copy constructor preserves managed_result_set

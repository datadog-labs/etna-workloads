# Rationale

Hunk: src/storage/table/row_group_collection.cpp, `RowGroupCollection::InitializeScan`.
Traces to the fix's removal of `D_ASSERT(row_group);` (and its added comment). I re-added `D_ASSERT(row_group);` after `auto row_group = state.GetRootSegment();`. A collection with no committed row groups has a null root, so assert-enabled builds throw an internal error instead of proceeding to the null-tolerant loop and LocalStorage scan.

Oracle result (./bin/etna-check):
FAIL cpp:test/api/test_data_table_scan_without_row_groups.cpp::Test scanning a table that has no committed row groups
  ... {"exception_type":"INTERNAL","exception_message":"Assertion triggered in file ".../row_group_collection.cpp" on line ...
1 of 1 oracle units fail

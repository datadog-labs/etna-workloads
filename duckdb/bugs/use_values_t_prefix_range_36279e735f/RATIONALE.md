# Rationale

File: src/planner/filter/table_filter_prefix_range_function.cpp, `PrefixRangeBitmap::LookupKeys` (no-selection overload).

Today's code already uses `Values<T>` (the fix's main change), so the old UnifiedVectorFormat code can't be restored verbatim. I restored the bug the PR describes: the no-selection overload ignores `count`.
- Removed `D_ASSERT(count <= keys.size())` (fix hunk 1).
- Both the dense call and the sparse loop now use `keys.size()` instead of `count`, so a vector holding more rows than `count` is scanned to its end and writes past `result_sel`.

Oracle result:
FAIL cpp:test/sql/filter/prefix_range_filter_lookup.cpp::Prefix range filter lookup is bounded by the filter count
  Assertion triggered in selection_vector.hpp line 125: idx < capacity
1 of 1 oracle units fail

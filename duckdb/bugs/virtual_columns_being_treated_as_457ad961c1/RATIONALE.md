# Rationale

File: src/optimizer/type_pushdown.cpp, `Resolve()` (plus removal of helper `IsRealGetColumn`).
Reverses the fix's cpp hunks:
- Removed the `IsRealGetColumn` helper (hunk 1 of the fix).
- Both lookups (direct GET and via projection) go back to the old `IsVirtualColumn(binding.column_index)` /
  `IsVirtualColumn(get_binding.column_index)` check, which tests a ColumnBinding index (an index into the GET's
  column ids) against the virtual-column sentinel. It never fires, so virtual columns like `filename` become
  pushdown candidates and `returned_types` gets indexed with the wrong index.

The header hunk (the D_ASSERT in type_pushdown.hpp) was left as is. Restoring the old `continue` there would mask the bug.
In this debug build the assertion fires instead of an out-of-range access.

## Oracle
```
FAIL     test/optimizer/pushdown/type_pushdown_virtual_column.test
         Query failed with internal exception! (test/optimizer/pushdown/type_pushdown_virtual_column.test:10)!
         INTERNAL Error: Assertion triggered in file ".../type_pushdown.hpp" on line 124: !analysis.get.GetColu...
1 of 1 oracle units fail
```

# Rationale
All changes in src/src/function/scalar/map/map_contains.cpp, reverting the fix's three hunks:
1. Removed `#include "duckdb/function/function_binder.hpp"` (include hunk).
2. Removed `TypeHasCollation` and `BindMapContainsExpression` (the rewrite to map_keys + list_contains for collated keys).
3. Removed `fun.SetBindExpressionCallback(BindMapContainsExpression)` in `MapContainsFun::GetFunction`.
Result: map_contains uses plain ListSearchOp again and ignores collations.

Oracle:
```
FAIL     test/issues/general/test_24328.test
         Wrong result in query! (test/issues/general/test_24328.test:8)!
1 of 1 oracle units fail
```

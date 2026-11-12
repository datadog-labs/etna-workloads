# Rationale

Hunks (both undo the upstream fix ad02ae84):

1. `src/function/scalar/comparison/between.cpp`, `BetweenFun::GetFunction`: removed
   `between_fun.SetNullHandling(FunctionNullHandling::SPECIAL_HANDLING);` (fix hunk 1). With default NULL
   handling the executor short-circuits to NULL when any argument is a CONSTANT NULL vector, so the result
   depends on vector representation (e.g. cross-product constant vectors) rather than Kleene logic.

2. `src/optimizer/statistics/expression/propagate_between.cpp`, `PropagateBetween`: restored the old
   FALSE_OR_NULL branch (fix hunk 2): fold unconditionally to `constant_or_null(false, input, lower, upper)`
   regardless of the other comparison's result, and including both bounds as NULL guards.

## Oracle
Result of `./bin/etna-check`: see output appended below.

```
build ok; running oracle tests ...
FAIL     test/sql/join/test_between_null_bound_join.test
         test/sql/join/test_between_null_bound_join.test:17
         Mismatch on row 1, column count_star(): 100 <> 2300
1 of 1 oracle units fail
```

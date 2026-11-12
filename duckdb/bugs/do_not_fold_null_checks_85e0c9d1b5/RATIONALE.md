# Rationale

File: src/src/optimizer/statistics/expression/propagate_operator.cpp

Today's code already had a partial guard (`CanFoldNullCheck`, which only checks `IsVolatile()` and a VARIANT-cast helper `ContainsThrowingVariantCast`). I re-introduced the bug by undoing the fix's hunks:

1. Removed the helpers `ContainsThrowingVariantCast` and `CanFoldNullCheck`. This corresponds to the fix's `CanFoldNullCheck` hunk at the top of the file.
2. Removed the `if (!CanFoldNullCheck(expr)) return nullptr;` guard in `OPERATOR_IS_NULL`. This corresponds to the fix's second hunk.
3. Removed the same guard in `OPERATOR_IS_NOT_NULL`. This corresponds to the fix's third hunk.

With the guards gone, `x IS (NOT) NULL` is folded to a constant whenever the stats prove (non-)nullness. That happens even if the child is volatile or can throw, so the child is dropped from the plan and its error never surfaces.

## Oracle result
```
FAIL     test/sql/optimizer/null_check_statistics_propagation.test
         test/sql/optimizer/null_check_statistics_propagation.test:12
         EXPLAIN SELECT s::VARIANT IS NOT NULL FROM t;  -> Projections: true (expected IS NOT NULL kept)
1 of 1 oracle units fail
```

# Rationale

Today's code differs from the fix's parent: the fix added a duplicate-binding check for the non-primary subplans inside `SelectPrimarySubplan`-adjacent logic. In v2.0.0 the duplicate-binding check lives in the pruning loop in `src/optimizer/common_subplan_optimizer.cpp` (the function that filters `subplans`, just before `SelectPrimarySubplan(subplan_info)`). It checks every subplan's `canonical_bindings` for duplicates and sets `bail`.

Hunk: I removed that `for (auto &subplan : subplan_info.subplans) { column_binding_set_t subplan_bindings; ... }` loop. This corresponds to the fix's added duplicate-detection hunk (`subplan_column_binding_set` / `bail = true` on duplicate). Without it, a subplan whose bindings collapse onto the same canonical binding is no longer rejected, so it is materialized as a CTE and two columns map to one materialized column, which is the original wrong result.

Oracle result (etna-check):
    1 of 1 oracle units fail
    test/optimizer/issue_25819.test: expected n_0_1, n_0_2, n_1_2; actual n_0_0, n_1_1

# Rationale

Changes are all in `src/backend/optimizer/plan/subselect.c`. Each traces to the subselect.c hunks of fix_impl.patch.

1. `build_subplan()`: removed `IsA(arg, GroupingFunc)` from the check that runs `SS_process_sublinks` on a PlaceHolderVar/Aggref plan-parameter argument. A GroupingFunc passed down to a subplan no longer has its SubLinks processed.
2. `process_sublinks_mutator()`: removed the `else if (IsA(node, GroupingFunc))` branch that returns early for outer-level GroupingFuncs (`agglevelsup > 0`). The mutator now recurses into the arguments of an outer GroupingFunc, so its SubLinks are handled at the wrong query level.

Together these restore the missing GroupingFunc handling in sublink processing.

Failing oracle case: `src/regress||groupingsets` (src/test/regress||groupingsets).

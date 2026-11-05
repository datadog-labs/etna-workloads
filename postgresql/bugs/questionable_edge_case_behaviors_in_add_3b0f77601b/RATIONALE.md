# Rationale

All changes are in src/backend/optimizer/util/pathnode.c and revert fix.patch.

1. compare_path_costs_fuzzily(): when total costs are fuzzily equal, the startup-cost comparisons again require the other path to be unparameterized (`path2->param_info == NULL` / `path1->param_info == NULL`). This traces to the hunk that removed those checks. With them back, a parameterized path can no longer win on startup cost, which brings back the old edge-case behavior.
2. add_path_precheck(): the loop-exit test goes back to an exact total-cost comparison (`total_cost <= old_path->total_cost`). The startup test goes back to the exact `startup_cost >= old_path->startup_cost || required_outer`. The `consider_startup` variable and the STD_FUZZ_FACTOR comparisons are gone. This traces to the add_path_precheck hunks. The precheck again disagrees with add_path's fuzzy comparisons, so paths get rejected or kept inconsistently.

Failing oracle case: src/test/regress||join

# Rationale
- File/function: src/backend/optimizer/plan/planner.c, consider_groupingsets_paths()
- Traces to the single hunk of fix_impl.patch (and fix.patch). I removed the `l_start != NULL &&` guard before `pathkeys_contained_in(root->group_pathkeys, path->pathkeys)` in the hash-agg branch.
- Why it brings the bug back: with only unsortable grouping sets, rollups is empty (l_start == NULL) and group_pathkeys is NIL, so the contained_in test is vacuously true. The code then calls lfirst_node(RollupData, l_start) on NULL and crashes.

Failing oracle case: src/test/regress||groupingsets

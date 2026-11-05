# Rationale
Reverses fix dc1057fcd878 (three hunks):
1. src/backend/optimizer/path/allpaths.c, set_subquery_pathlist: removed the `rel->consider_parallel && bms_is_empty(required_outer)` guard around partial subquery-scan path generation (allpaths.c hunk). Partial paths are now built even if the outer rel isn't parallel-safe or has lateral/required_outer.
2. src/backend/optimizer/prep/prepunion.c, recurse_set_operations: removed `rel->consider_parallel && bms_is_empty(rel->lateral_relids)` from the partial path condition (prepunion.c hunk).
3. pathnode.c add_partial_path: the fix's added Asserts are left in place (removing them left the oracle passing, as the bogus path silently lost on cost); they now trip on the bogus partial path.
Result: bogus parallel subquery scan paths are generated.
Failing oracle case: src/test/regress||select_parallel (fails: assertion failure / crash in add_partial_path).

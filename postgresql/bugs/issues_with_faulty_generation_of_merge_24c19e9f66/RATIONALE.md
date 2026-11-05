# Rationale

Hunk 1: src/backend/optimizer/path/pathkeys.c, `find_var_for_subquery_tle`.
Traces to fix.patch's pathkeys.c hunks (new find_var_for_subquery_tle used by convert_subquery_pathkeys).
The reltarget search is removed: any non-resjunk subquery TLE is treated as available to the outer
query and a Var is built directly (as the pre-fix `makeVarFromTargetEntry` code did). Pathkeys
therefore can reference subquery columns (e.g. q2) that the subquery scan does not emit, producing
faulty Merge Append plans.

Hunk 2: src/backend/optimizer/plan/createplan.c, `create_merge_append_plan`.
Traces to the createplan.c hunk adding the `tlist_was_changed && (flags & (CP_EXACT_TLIST|CP_SMALL_TLIST))`
projection injection. Removed (always `return plan;`), so extra sort columns are not stripped.

Failing oracle case: src/test/regress||union
(Hunk 2 alone did not make it fail; with hunk 1 it fails.)

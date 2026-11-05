# Rationale

One hunk: src/backend/optimizer/plan/planner.c, grouping_planner().
Traces to the planner.c hunks of fix.patch. In the fix, the inherited-UPDATE/DELETE/MERGE
branch sets `rootRelation = parse->resultRelation`, and the single-rel branch sets it to 0.
I reverted this to the old logic: rootRelation is set after both branches, and only when the
target is a RELKIND_PARTITIONED_TABLE. For a plain inheritance parent, rootRelation is therefore 0.
The executor then treats the first leaf result rel as the root, which is wrong when the
parent is excluded from the plan. This brings the bug back.

Oracle case expected to fail: src/test/regress||inherit

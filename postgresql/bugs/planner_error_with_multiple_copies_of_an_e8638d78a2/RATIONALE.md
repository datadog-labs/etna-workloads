# Rationale

Reverted the fix so rejected subplans are dropped immediately, per AlternativeSubPlan copy.

Changed file: src/backend/optimizer/plan/setrefs.c (the pathnodes.h fields `isAltSubplan`/`isUsedSubplan` are left unused, which doesn't change behavior).

1. `set_plan_references`: removed the workspace allocation for isAltSubplan/isUsedSubplan and the post-pass that NULLs unused subplans (fix hunks 1-2 of setrefs.c).
2. `fix_alternative_subplan`: restored the old loop that sets `glob->subplans` entries to NULL immediately for the discarded subplans, and removed the isAltSubplan/isUsedSubplan marking (fix hunks 3-4).

Why this brings the bug back: with multiple copies of the same AlternativeSubPlan, the first copy to be resolved NULLs out subplans that another copy may choose. The other copy then references a subplan whose list entry is NULL, giving a planner error.

Oracle case expected to fail: src/test/regress||subselect

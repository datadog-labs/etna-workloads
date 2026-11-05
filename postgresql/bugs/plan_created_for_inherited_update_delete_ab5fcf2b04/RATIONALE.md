# Rationale

## src/backend/optimizer/plan/planner.c, grouping_planner
Traces to the fix.patch hunk in planner.c (inheritance_planner, `if (subpaths == NIL)` branch).
inheritance_planner no longer exists; its role is now in grouping_planner. The fix made the
"every child rel excluded" case build a one-element ModifyTable (resultRelations, returningLists, etc.
from the top target rel). The change restores the old behaviour: when resultRelations == NIL the
dummy plan is returned without a ModifyTable node (new flag skip_modifytable skips create_modifytable_path).
Result: RETURNING output columns are wrong, and statement-level triggers do not fire.

## Failing oracle cases
- src/test/regress||inherit (FAIL)
- src/test/regress||triggers (FAIL)

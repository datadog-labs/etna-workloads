# Rationale

Hunk: src/backend/optimizer/path/allpaths.c, find_window_run_conditions().
Traces to the fix.patch hunk adding `*run_cond_attrs = bms_add_member(...)` after the
run condition is appended. Removing it means attributes used in a window run condition
are never passed as extra_used_attrs to remove_unused_subquery_outputs(), so the window
function output column is judged unused and replaced by NULL, breaking the run condition.

Failing oracle case (expected): src/test/regress||window

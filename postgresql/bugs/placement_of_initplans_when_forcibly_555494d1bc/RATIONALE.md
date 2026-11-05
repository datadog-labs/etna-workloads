# Rationale
Changed: src/src/backend/optimizer/plan/createplan.c, `materialize_finished_plan()`.
Traces to the createplan.c hunk of fix.patch: removed the "horrid kluge" that moves
subplan->initPlan to the new Material node (matplan->initPlan = subplan->initPlan; subplan->initPlan = NIL).
(The planner.c hunk was already folded into this function in current code.) Without it, initPlans
stay on the node below the Material, so SS_finalize_plan fails/misplaces them when a subplan is forcibly
materialized; the cost-move code now sees an empty initPlan list.

Failing oracle case: src/test/regress||subselect

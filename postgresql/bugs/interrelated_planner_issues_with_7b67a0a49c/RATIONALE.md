# Rationale

File: src/backend/optimizer/plan/createplan.c, function materialize_finished_plan().
Traces to the planner.c hunk of fix.patch (the "horrid kluge" that moves initPlans from the
formerly-top plan node to the new Material node for scrollable cursors). In current code
the kluge lives in materialize_finished_plan, so I removed it there, along with the
matching cost move. Without it the initPlans stay on the node below the Material node, so
SS_finalize_plan fails ("plan should not reference subplan's variable" / param
out-of-scope errors) for scroll cursors over plans with initPlans.

The other fix hunks are comment-only, and the Gather/initPlan check already differs in
current code, so I left them alone.

Failing oracle case: src/test/regress||portals

# Rationale

Hunk: src/backend/executor/nodeModifyTable.c, ExecInitModifyTable (WCO init loop).
Traces to the single hunk of fix_impl.patch: the fix changed the parent passed to
ExecInitQual for `wco->qual` from the subplan (`mt_plans[i]`) to `&mtstate->ps`.
Today's code has a single subplan, so the reverse is passing `outerPlanState(mtstate)`
instead of `&mtstate->ps`. This restores the wrong parent for WCO quals (SubPlans in
them get the subplan as parent instead of the ModifyTable node).

Failing oracle case: src/test/regress||updatable_views

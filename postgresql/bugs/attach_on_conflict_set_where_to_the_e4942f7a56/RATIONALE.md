# Rationale
File: src/backend/executor/nodeModifyTable.c, function ExecInitModifyTable (ON CONFLICT setup).
Traces to the fix_impl.patch hunk that changed the planstate passed to ExecInitExpr for node->onConflictWhere from mt_plans[0] to &mtstate->ps.
In current code the ExecInitQual call for onConflictWhere uses &mtstate->ps; the bug version uses the subplan state (outerPlanState(&mtstate->ps)) instead, so the ON CONFLICT DO UPDATE ... WHERE qual is attached to the wrong planstate.
Failing oracle case: src/test/regress||insert_conflict

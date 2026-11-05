# Rationale

File/function: src/backend/commands/trigger.c, ExecBRDeleteTriggers and ExecBRUpdateTriggers.

Traces to the fix.patch hunk in GetTupleForTrigger. There, for MERGE, a traversed (concurrently updated) tuple makes the function return TM_Updated and leave the recheck to the caller. In current code that behaviour is selected by the `do_epq_recheck` argument, which the callers set to `!is_merge_delete` and `!is_merge_update`. I changed both callers to pass `true`.

Effect: with a BEFORE ROW trigger, MERGE UPDATE/DELETE runs EvalPlanQual inside the trigger code. This skips MERGE's own rechecking of the WHEN clauses, so a different action can't be chosen. That is the original bug.

Failing oracle case: src/test/isolation||merge-match-recheck. (merge-delete still passes.)

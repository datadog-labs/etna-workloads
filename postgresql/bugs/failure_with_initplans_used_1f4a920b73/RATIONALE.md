# Rationale
File: src/backend/executor/execMain.c

- EvalPlanQualStart: removed the ExecSetParamPlanMulti(planTree->extParam, ...) call (and its comment) before the param values are copied to the recheck EState. Traces to the fix.patch execMain.c hunk in EvalPlanQualStart. Without it, unevaluated InitPlan outputs are copied down with no value and the execPlan link is dropped, so conditionally-used initplans fail during EPQ rechecks.
- EvalPlanQualBegin: removed the ExecSetParamPlanMulti(rcplanstate->plan->extParam, ...) call (the old `planstate` variable is now `rcplanstate`) before parent params are recopied. Traces to the matching EvalPlanQualBegin hunk. Without it, initplans reset after EvalPlanQualStart are not re-evaluated.

Failing oracle case: src/test/isolation||eval-plan-qual

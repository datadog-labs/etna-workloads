# Re-introducing the MULTIEXPR_SUBLINK / partitioned-target bug

The fix moved MULTIEXPR SubPlan execution into dedicated "setup steps" at the start of an expression. That ran them once, before any referencing Params, and kept them out of the resjunk tlist evaluation. This change restores the older design, where MULTIEXPR SubPlans are evaluated as resjunk tlist items and then lazily via `execPlan`.

Hunks (all trace to fix_impl.patch):
- `execExpr.c`, `ExprSetupInfo`, `expr_setup_walker`, `ExecPushExprSetupSteps`: removed the `multiexpr_subplans` collection and the setup-step emission. This reverses the execExpr.c setup-step hunks.
- `execExpr.c`, `ExecInitExprRec` (T_SubPlan): MULTIEXPR no longer emits a dummy NULL const. It is compiled like an ordinary SubPlan again, which reverses the "Real execution ... already done" hunk.
- `execExpr.c`, `ExecBuildUpdateProjection`: restored the loop that evaluates the remaining resjunk tlist columns. This reverses the hunk that removed the loop and added the "we don't bother evaluating resjunk columns" comment.
- `nodeSubplan.c`, `ExecScanSubPlan`: restored the MULTIEXPR shortcut. It marks the setParams' `execPlan` and returns NULL. The per-tuple and empty-result MULTIEXPR handling is removed.
- `nodeSubplan.c`, `ExecInitSubPlan`: dropped the `parParam == NIL` condition, so MULTIEXPR setParams get `execPlan` set at init.
- `nodeSubplan.c`, `ExecSetParamPlan`: dropped the "correlated subplans should not be executed" error. The old parParam/args evaluation loop is not restored, because the current code evaluates args through EEOP_PARAM_SET in `ExecInitSubPlanExpr`.

Why this brings back the bug: with partitioned or inherited UPDATE targets, the MULTIEXPR SubPlan is lazily evaluated and its parent-param handling is wrong (stale or incorrect results).

Failing oracle case: `src/test/regress||inherit`.

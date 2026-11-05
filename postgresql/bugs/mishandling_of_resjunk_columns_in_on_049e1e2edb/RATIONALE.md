# Rationale

File/function: src/backend/executor/execExpr.c, ExecBuildUpdateProjection().

Traces to the fix.patch hunk in execExpr.c that makes ExecBuildUpdateProjection evaluate
resjunk tlist entries when evalTargetList is true ("must evaluate any resjunk columns too
(This matters for things like MULTIEXPR_SUBLINK SubPlans)", plus the walker over the whole targetList).
In current code the junk entries' MULTIEXPR SubPlans are executed via the setup steps found by
expr_setup_walker over the whole targetList. The change walks only non-resjunk entries, so
the MULTIEXPR SubPlan living in a resjunk ON CONFLICT DO UPDATE tlist entry is never run and its
output Params are never set: `SET (b, a) = (SELECT ...)` yields wrong/NULL/stale values.

Failing oracle case: src/test/regress||update

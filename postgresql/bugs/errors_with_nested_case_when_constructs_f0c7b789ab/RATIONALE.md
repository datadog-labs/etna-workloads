# Rationale

Changed hunk: src/backend/optimizer/util/clauses.c, `inline_function()`.
Traces to the fix.patch hunk in inline_function that added
`if (contain_context_dependent_node((Node *) args)) goto fail;`.
I removed that check, so a SQL function whose arguments contain a bare
CaseTestExpr (from a nested CASE/WHEN) is inlined again. The CaseTestExpr
then ends up inside a different CASE context and sees the wrong test value.

The execQual.c ExecEvalCase hunk (the aliasing of caseValue_isNull) has no
equivalent today, because expressions are now compiled to ExprState steps.
I did not change anything for that hunk.

Failing oracle case: src/test/regress||case

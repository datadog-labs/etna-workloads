# Rationale

Hunk: src/backend/executor/nodeValuesscan.c, ExecInitValuesScan (condition guarding init-time eval-state build for rows with SubPlans).

Traces to fix.patch hunk in ValuesNext(): the fix made the expressions' SubPlans link into the node (parent = &node->ss.ps) instead of building them with parent NULL. In current code that is done by building eval state at plan startup for rows containing SubPlans (contain_subplans). Adding `false &&` disables that, so such rows fall back to ValuesNext's ExecInitExprList(exprlist, NULL), the pre-fix behaviour, where a SubPlan with no parent fails (e.g. LATERAL sub-selects in multi-row VALUES).

Failing oracle case: src/test/regress||subselect

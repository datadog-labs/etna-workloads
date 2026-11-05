# Rationale

Hunk: src/backend/executor/execExpr.c, isAssignmentIndirectionExpr()
Traces to the fix_impl.patch hunk that adds the `CoerceToDomain` branch (look through the domain coercion via `cd->arg`). The comment hunk was not reverted.
I removed that branch. When assigning to an element of an array of domain-over-composite, the refassgnexpr is a CoerceToDomain wrapping the CaseTestExpr-based indirection. Without the branch it is not recognized as an assignment indirection expression, so the old array element value is not passed in, and the assignment gives wrong results or errors.

Failing oracle case: src/test/regress||domain

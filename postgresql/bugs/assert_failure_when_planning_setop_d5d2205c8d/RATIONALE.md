# Rationale

## Changed hunk
File: src/backend/optimizer/plan/planner.c, function grouping_planner().

Traces to the fix.patch hunk in grouping_planner() that replaced the
`root->parent_root->parse->setOperations` check with `qp_extra.setop = setops`.

The setop context is again derived from `root->parent_root`'s setOperations
instead of from the explicit `setops` argument. A CTE subquery is planned with
the set-operation query as its parent_root, so it wrongly inherits the parent's
SetOperationStmt. That brings back the assert failure. The `setops` parameter
is still passed down but is now unused.

## Failing oracle cases
- src/test/regress||union

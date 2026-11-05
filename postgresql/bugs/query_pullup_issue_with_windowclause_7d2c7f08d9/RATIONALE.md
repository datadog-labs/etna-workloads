# Rationale

Changed hunk: `src/backend/optimizer/util/clauses.c`, `eval_const_expressions_mutator` (case T_WindowFunc).
Traces to the fix.patch hunk that adds `newexpr->runCondition = expr->runCondition;` there.
I removed that line. The rebuilt WindowFunc then loses its runCondition during constant folding.
The pushed-down qual can therefore be dropped from the subquery without a run condition replacing it, and the window plans and results change.

The rest of fix.patch (moving runCondition from WindowClause to WindowFunc) is already in REL_18_6 as the base design. I did not reverse that part, because doing so would be a large rewrite rather than a minimal change.

Failing oracle case: src/test/regress||window

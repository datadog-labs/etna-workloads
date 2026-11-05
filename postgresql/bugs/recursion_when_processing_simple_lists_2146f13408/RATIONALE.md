# Rationale
- src/backend/parser/gram.y, makeAndExpr() and makeOrExpr(): traces to the fix.patch gram.y hunk that adds these functions. The "flatten on sight" branch is removed. The branch appended the right operand to an existing left-hand AND (or OR) BoolExpr. Without it, "a AND b AND c" parses into a nested binary tree again. That puts back the deep recursion on long lists, and stored view and rule trees keep the nested form.

Failing oracle case: src/test/regress||rules

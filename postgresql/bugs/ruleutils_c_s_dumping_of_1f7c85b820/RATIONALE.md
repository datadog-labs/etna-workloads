# Rationale
File: src/backend/utils/adt/ruleutils.c, function get_rule_expr (case T_ScalarArrayOpExpr).
Traces to the single fix_impl.patch hunk: removed the block that appends "::type" after a bare
scalar sub-SELECT (EXPR_SUBLINK) operand. Without it, "x op ANY (SELECT ...)" is dumped without the
dummy coercion and gets reparsed as an ANY SubLink instead of a ScalarArrayOpExpr.

Failing oracle case: src/test/regress||create_view

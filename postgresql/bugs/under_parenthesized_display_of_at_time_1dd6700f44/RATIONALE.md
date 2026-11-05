# Rationale

File: src/backend/utils/adt/ruleutils.c, function isSimpleNode(), two hunks (T_FuncExpr case under the parent-node switch for OpExpr children, and the one for the other node types).
Traces to the first two hunks of fix_impl.patch. I removed `COERCE_SQL_SYNTAX` from the funcformat checks, so a SQL-syntax function parent (e.g. AT TIME ZONE) is again treated as supplying its own parentheses. Operands that need parentheses (e.g. `a + b AT TIME ZONE ...`) are then printed without them, so the display is under-parenthesized.

The get_func_sql_syntax hunks were not reverted, since those already used get_rule_expr_paren in the current code; the isSimpleNode change is what removes the parentheses.

Oracle case expected to fail: src/test/regress||create_view

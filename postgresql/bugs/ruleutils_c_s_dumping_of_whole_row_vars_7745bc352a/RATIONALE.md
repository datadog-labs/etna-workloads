# Rationale
File: src/backend/utils/adt/ruleutils.c (the get_rule_expr_toplevel helper is left in place, since other callers still use it).

1. `get_values_def()`: the column printing call is changed from `get_rule_expr_toplevel(col, ...)` back to `get_rule_expr(col, ...)`. This traces to the fix.patch hunk in get_values_def. Whole-row Vars in VALUES() are then deparsed with istoplevel=false, so they print as `foo.*`, which the parser expands into multiple columns.
2. `get_rule_expr()`, case T_RowExpr: `get_rule_expr_toplevel(e, context, true)` is changed back to `get_rule_expr(e, ...)`. This traces to the fix.patch hunk in the RowExpr case. Whole-row Vars inside ROW() lose their decoration and are expanded when the dump is reloaded.

Failing oracle case: src/test/regress||create_view

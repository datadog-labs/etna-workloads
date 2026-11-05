# Rationale

Fix 43c2175121c8 added get_rule_list_toplevel() so whole-row Vars are dumped properly inside VALUES lists and ROW comparisons. The bug is back because those callers no longer use it.

All hunks are in src/backend/utils/adt/ruleutils.c.

1. `get_insert_query_def` (the single-VALUES case) traces to the fix hunk that replaced `get_rule_expr((Node *) strippedexprs, ...)` with `get_rule_list_toplevel(strippedexprs, ...)`. It now calls `get_rule_expr` on the list again. A whole-row Var in `INSERT ... VALUES (...)` is then printed without the toplevel treatment, so it appears as `tbl.*` instead of `tbl`.
2. `get_rule_expr`, case `T_RowCompareExpr`, traces to the fix hunk that replaced the two loops with `get_rule_list_toplevel` for `largs` and `rargs`. It uses the original inline loops with `get_rule_expr` again. Whole-row Vars inside the ROW(...) comparison are then printed in the wrong form.

The `get_rule_list_toplevel` helper is kept, because another caller (line ~7534, added after the fix) still uses it.

Oracle case expected to fail: src/test/regress||create_view

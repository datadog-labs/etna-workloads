# Rationale

## src/backend/utils/adt/ruleutils.c, get_rule_sortgroupclause()
Traces to the fix.patch hunk that replaced `else if (!expr || IsA(expr, Var)) get_rule_expr(...)`
with a branch that sets `context->varInOrderBy = true` and calls `get_variable()`.
I restored the old behaviour: a plain Var in an ORDER BY or GROUP BY item is deparsed through
`get_rule_expr()` with `varInOrderBy` never set. The name-conflict check in `get_variable()`
(which only runs when `varInOrderBy` is set) is therefore dead code. A Var whose column name
matches a different SELECT-list output name is printed unqualified. When the view is reparsed,
`findTargetlistEntrySQL92` resolves the name to the output column instead of the Var, so the
ORDER BY list is mis-deparsed.

The other hunks of the fix are refactoring (exprkind, context fields) or the check itself. I left
them in place because the current code has changed shape there.

## Failing oracle cases
- src/test/regress||create_view

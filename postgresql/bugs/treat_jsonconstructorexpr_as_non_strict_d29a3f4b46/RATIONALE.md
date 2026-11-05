# Rationale
- File: src/backend/optimizer/util/clauses.c, function contain_nonstrict_functions_walker.
- Traces to the fix_impl.patch hunk adding `if (IsA(node, JsonConstructorExpr)) return true;`. In the current code that check is an `else if` branch; I removed it.
- Effect: JsonConstructorExpr is again treated as strict when its arguments are strict. The planner can then wrongly assume a NULL input gives a NULL result, for example when it reduces outer joins or pulls up subqueries.

Failing oracle case: src/test/regress||subselect

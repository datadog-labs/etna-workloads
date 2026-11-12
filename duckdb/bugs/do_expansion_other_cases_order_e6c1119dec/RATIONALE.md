# Rationale

Today's code already has the fix under different names: `Binder::NormalizeFilterStarExpressions(SelectNode&)` in
`src/planner/binder/query_node/bind_select_node.cpp`. It corresponds to the fix's per-site `BindFilterStarExpressions`
calls in `PrepareModifiers` (DISTINCT ON, ORDER BY) and `BindSelectNode` (QUALIFY, HAVING).

Hunk changed: in `NormalizeFilterStarExpressions`, I removed the loop over `statement.modifiers`
(DISTINCT ON targets and ORDER BY expressions) and the `having` / `qualify` calls. Only the select-list
normalization stays. This restores the pre-fix behaviour: `FILTER (WHERE COLUMNS(*) ...)` is expanded only in the
select list, so the same aggregate written in ORDER BY, DISTINCT ON, HAVING or QUALIFY is expanded differently.

## Oracle result
```
FAIL     test/sql/filter/test_columns_filter.test
         test/sql/filter/test_columns_filter.test:26 ::  1. test/sql/filter/test_columns_filter.test:26
         Wrong result in query! ...
         Mismatch on row 1, column g(index 1)
         2 <> 1
1 of 1 oracle units fail
```

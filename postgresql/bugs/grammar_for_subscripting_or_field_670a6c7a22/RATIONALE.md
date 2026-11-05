# Rationale

File: src/backend/parser/gram.y, nonterminal c_expr.
Traces to the fix.patch hunk adding the `select_with_parens indirection` production to c_expr.
I removed that production (the SubLink wrapped in A_Indirection). Subscripting or field selection applied to a parenthesized sub-SELECT, such as `(select array[1,2])[1]` or `(select row)).f`, no longer parses. The `'(' a_expr ')' opt_indirection` production can't match it because select_with_parens eats the parens.

Failing oracle case: src/test/regress||subselect

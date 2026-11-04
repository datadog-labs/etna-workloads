# Rationale

Fix hunk: in `sql/src/expr/mod.rs`, `SQLExpr::Function` with `FunctionArguments::None` and a multi-part name was rerouted to `sql_compound_identifier_to_expr`. This worked around sqlparser-rs #1909, where `t.user` parses as a function.

In 55.2.0 the workaround lives in `datafusion/sql/src/expr/function.rs` (`sql_function_to_expr`, the `function_without_parentheses` block). I changed that block so it only handles single identifiers. The compound-identifier branch (`ids.len() > 1` -> `sql_compound_identifier_to_expr`) is removed. This is the behaviour before the fix: a qualified name that parses as a function is never turned back into a column.

Failing oracle cases in `select.slt`:
- `select t_with_user.user from t_with_user;` fails with "Invalid function 't_with_user.user'".
- The same error occurs for the `where t_with_user.user = 'foo'` query.
- The same error occurs for `t_with_current_time.current_time`.

`check.sh` also printed a `Dictionary(Int32, Utf8) = Utf8` planning error at select.slt:283. That error is not related to this change.

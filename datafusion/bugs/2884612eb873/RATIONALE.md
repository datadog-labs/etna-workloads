# Rationale

Changes (both under datafusion/sql/src/expr/):

1. `function.rs` (`sql_function_to_expr`): removed the `if function_without_parentheses { ... }` fallback
   before the "Could not find the relevant function" error. This reverses the fix's added hunk that
   lowers a paren-less reserved function (e.g. `user`) to a column when no function matches.
   The `function_without_parentheses` field is still populated, as in the fix's pre-state it did not exist; it is just unused.
2. `mod.rs` (`SQLExpr::Function` arm): restored the pre-fix workaround, which only handles
   *compound* names (`t.user`) with `FunctionArguments::None`, so the pre-fix behaviour
   (qualified works, unqualified does not) is exact. Re-added the `FunctionArguments` import.

## Oracle
select.slt fails on `select user from t_with_user;` and
`select * from t_with_user where user = 'foo';` with "Invalid function 'user'. Did you mean 'upper'?",
the issue #14141 symptom. (The qualified `t_with_user.user` cases still pass.)
Failures at select.slt lines 277/283 (dictionary comparison) are unrelated to this change.

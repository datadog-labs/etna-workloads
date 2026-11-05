# Rationale

Reverts d9809bf8694c in src/pl/plpgsql/src:

- pl_exec.c `exec_stmt_call`: the Assert and `make_callstmt_target` are again inside the `expr->plan == NULL` block (fix hunk 1). If `exec_prepare_plan` fails after saving the plan, a retry skips target creation, so `stmt->target` stays unset.
- pl_exec.c `exec_stmt_execsql`: the `mod_stmt` computation is again inside `expr->plan == NULL` (fix hunks 3/4). After a failed first prepare, `mod_stmt` is never computed. Removed the `mod_stmt_set` field.
- plpgsql.h `PLpgSQL_stmt_execsql`: removed `mod_stmt_set` (fix hunk 7).
- pl_gram.y `make_execsql_stmt`: `palloc0` back to `palloc` (fix hunk 6), so `mod_stmt` is uninitialized.

The comment-only hunks were not reverted.

Failing oracle case: src/pl/plpgsql/src||plpgsql_simple (see the oracle output).

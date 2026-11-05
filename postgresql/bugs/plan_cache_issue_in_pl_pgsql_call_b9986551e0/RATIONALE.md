# Rationale

Only file changed: `src/pl/plpgsql/src/pl_exec.c`. It traces to the `pl_exec.c` hunks in fix.patch.

Today's code no longer has the PG_TRY or `plan` local. `exec_stmt_call` uses `SPI_execute_plan_extended` with a procedure-lifespan resowner, and `exec_prepare_plan` always calls `SPI_keepplan`. I therefore re-expressed the bug in its pre-fix form.

- `exec_prepare_plan` now takes a `keepplan` parameter and calls `SPI_keepplan` only when it is true. Every existing caller passes `true`. This is the hunk in `exec_stmt_call` that passes `estate->atomic`.
- `exec_stmt_call` passes `estate->atomic`. In non-atomic context the plan is therefore not saved.
- The fix's cleanup is absent: there is no reset of `expr->plan` to NULL after execution, on success or error. This matches the fix's PG_TRY/PG_CATCH and post-call hunks. `expr->plan` therefore dangles into freed SPI memory the next time the statement runs.

Failing oracle case: `src/pl/plpgsql/src||plpgsql_call`

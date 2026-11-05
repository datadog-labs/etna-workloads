# Rationale

Changes are all in src/pl/plpython/plpy_main.c, tracing to the plpy_main.c hunks of fix_impl.patch.
I did not touch the plpython_inline_handler hunk or the plpy_procedure.c comment hunk.
The inline handler's callback never needed the exec context, and the comment change doesn't affect behavior.

- `plpython3_call_handler`: the error-context callback is again registered before `PG_TRY` and popped by hand after it.
  This reverses the fix hunks for the call handler.
  Because the PG_CATCH block pops the execution context and then re-throws, the callback is still on `error_context_stack` while the error is reported.
  It then runs against a context that no longer exists.
  It reads the wrong context, and so reports the wrong function name or none.
- `plpython_error_callback`: it again calls `PLy_current_execution_context()` instead of using `arg`.
  This reverses the fix hunk for the callback.
  It picks up whatever context is on top of the stack, not the one that belongs to the failing call.

Failing oracle case: src/pl/plpython||plpython_error

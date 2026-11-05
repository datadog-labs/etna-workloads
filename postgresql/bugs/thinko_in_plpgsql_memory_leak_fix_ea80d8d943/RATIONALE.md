# Rationale

File: src/pl/plpgsql/src/pl_exec.c, function make_callstmt_target (the CALL target-building code was split out of exec_stmt_call).

fix.patch hunk: exec_stmt_call, which changed get_eval_mcontext() to get_stmt_mcontext() for the context holding the CALL "target" row.

In the current code the early switch to eval_mcontext is already present, and the long-lived row is allocated in fn_cxt. So the fixed behaviour now comes from where the row is allocated. I changed that allocation (`row` and `row->varnos`) from fn_cxt to get_eval_mcontext(estate). The cached stmt->target then lives in the eval_mcontext, which is destroyed at transaction end. A CALL to a procedure with OUT/INOUT args that does COMMIT therefore leaves a dangling target, as in the original bug.

Failing oracle case: src/pl/plpgsql/src||plpgsql_call

# Rationale

File: src/pl/plpgsql/src/pl_exec.c, function exec_stmt_call().

Traces to the fix.patch hunk(s) that moved the argument examination (building the
output-argument DTYPE_ROW target) to just after the CALL plan is produced, before
the procedure is invoked. Pre-fix code built the target only after the call
had executed (inside the `SPI_processed == 1` block). Today that logic lives in
make_callstmt_target(); the expand_function_arguments() part of the fix now lives
in analyze.c, so it was left untouched.

The change removes the early `make_callstmt_target()` call and calls it after
SPI_execute_plan_extended(), inside the SPI_processed == 1 branch. This brings
back the bug: non-writable OUT/INOUT argument errors are raised only after the
procedure has already run (with its side effects), and the plan is examined
after the procedure ran, when it may have been invalidated or flushed.

Failing oracle case: src/pl/plpgsql/src||plpgsql_call

# Rationale

Fix hunk reversed: `Python/sysmodule.c` `call_trampoline` — removal of
`if (result == NULL) PyTraceBack_Here(frame);`. In v3.15.2 `call_trampoline`
no longer has that call; legacy tracing is dispatched via PEP 669 and the C
trace function (`tstate->c_tracefunc`) is invoked from three places. When the
trace function fails, each now adds the frame to the traceback itself again,
before returning the error (the eval loop's `error:` label then adds it a
second time, so the frame appears twice, as before the fix):

- `Python/instrumentation.c` (`_Py_call_instrumented_line`, the direct
  `c_tracefunc(... PyTrace_LINE ...)` call): `PyTraceBack_Here(frame_obj)` on error.
- `Python/legacy_tracing.c` `call_trace_func` (call/return/etc. events): same.
- `Python/legacy_tracing.c` `trace_line` (jump events): same.

Oracle: `test_settrace_error` and `test_testcapi_settrace_error` (all TestCase
variants) fail with "Traceback has frame more than once". Verified with a
local build (`test_sys_settrace` FAILURE; reproducer prints 2 instead of 1).

Note: `./check.sh` printed "0 failing" because its harness builds a
sqlite-style `testfixture` rather than CPython, so it does not exercise this.

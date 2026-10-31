Reproducer: registers a sys.monitoring CALL callback, then calls a Python function via `f(*args)` (CALL_FUNCTION_EX).
Clean: the callback sees `(f, 1)` first, so output is `[(True, 1), (False, 0)]`.
Buggy: CALL is not emitted for Python functions/methods under INSTRUMENTED_CALL_FUNCTION_EX, so only the later `set_events` call is seen: `[(False, 0)]`.

# Re-injected: PY_THROW callback missing the exception argument (GH-107724)

Changes (all under tree/):
- Python/ceval.h `monitor_throw`: calls `_Py_call_instrumentation_exc0(...)` instead of `do_monitor_exc(..., PY_MONITORING_EVENT_PY_THROW)`. Reverses the ceval.c hunk (the function now lives in ceval.h).
- Python/instrumentation.c, Include/internal/pycore_instruments.h: restored `_Py_call_instrumentation_exc0` (reverses the removal hunks). It calls the callback with only (code, offset).
- Python/legacy_tracing.c: `sys_profile_throw`/`sys_trace_throw` assert `nargs == 2` instead of 3, matching the 2-arg throw callback (the fix's legacy_tracing hunks used sys_trace_func2 vs func3; the handlers were since renamed, so only the arity assertion is restored).

Oracle failures: test_monitoring (3 errors, e.g. TestLocalEvents.test_local_py_throw_disable, ExceptionMonitoringTest.test_throw) fail with
`TypeError: callback() missing 1 required positional argument: 'exc'`.

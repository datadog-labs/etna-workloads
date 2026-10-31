# Rationale

Both changes are in `Python/legacy_tracing.c`. They reverse the two hunks of the fix (gh-110514), which added `PY_THROW` to `sys.setprofile`.

1. `setup_profile_callbacks()`: removed the `set_callbacks(... sys_profile_throw, PyTrace_CALL, PY_MONITORING_EVENT_PY_THROW ...)` registration. This reverses the fix's first hunk, which added the `PY_THROW` callback. In v3.15.2 the callback is `sys_profile_throw`, and the code has moved from `_PyEval_SetProfile`.
2. `set_monitoring_profile_events()`: removed `(1 << PY_MONITORING_EVENT_PY_THROW)` from the event mask. This reverses the fix's second hunk. The profiler no longer subscribes to throw events.

## Oracle failure
`ProfileHookTestCase.test_unfinished_generator` fails. When an unfinished generator is garbage collected, it throws into the frame. The profiler no longer sees the second `call` event for `f`, so the expected `(2, 'call', f_ident)` is missing from the received events.

`sys_profile_throw` is now an unused static function, so the build may warn about it.

# Rationale

Fix hunk reversed: the early exit added to `_Py_Instrument` in
`Python/instrumentation.c`:

    if (code->_co_firsttraceable >= code_len) { return 0; }

This stops instrumentation data being created for shim code objects. They are
statically allocated, so instrumenting them crashes (GH-108390,
`test_108390`).

In v3.15.2 the same logic lives in `force_instrument_lock_held`, as a check of
`code->co_flags & CO_NO_MONITORING_EVENTS`. I removed that check, so shim
code objects are instrumented again. That is the pre-fix behaviour.

The other hunks of the fix are not reversed:

- The local/global monitor type split and the `set_local_events` rejection of
  non-local events were redesigned upstream. In 3.15, RAISE and similar events
  can be set per code object, so that mechanism no longer exists.
- The `_PyMonitoring_SetLocalEvents` shim check is still in place. I left it
  alone because reverting it would not reintroduce the crash.

## Oracle results

`./check.sh` reports 10 of 99 oracle cases failing, and the run does not
complete because of a crash. The failing cases are `TestRegressions.test_108390`,
`test_gh108976`, `test_130279`, `test_134879`, `test_call_function_ex`,
`test_instruction_explicit_callback`, `TestSetGetEvents.test_global`,
`TestSetGetEvents.test_local`, `TestTier2Optimizer.test_monitoring_already_opimized_loop`
and `TestUninitialized.test_get_local_events_uninitialized`.

`test_108390` is the case the fix added. It sets events from `__init__` after
the specialised class-call path has run, which instruments the shim code. This
crashes the interpreter.

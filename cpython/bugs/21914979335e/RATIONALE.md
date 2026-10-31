# Rationale

The v3.15.2 tree already contains `make_pre_finalization_calls()` (loop) and the
`_PyThreadState_WHENCE_THREADING_DAEMON` plumbing, so the fix hunks cannot be
reversed verbatim. Two changes restore the pre-fix behaviour that threads
started from an atexit callback / pending call during finalization are not
waited for (they end up effectively daemon and are killed).

1. `Lib/threading.py` `_shutdown()`: reverses the fix hunk that changed
   `return` to `return _thread_shutdown()` when `_shutdown()` was already called.
   Restored to the plain `return`, so later loop iterations no longer wait for
   non-daemon threads started in the meantime.

2. `Python/pylifecycle.c` `make_pre_finalization_calls()`: removed
   `interp_has_threads(interp)` from `should_continue`. This is the fix's
   added check that makes the pre-finalization loop run again when non-daemon
   threads exist; pre-fix code had no such re-check, so finalization proceeded
   with the thread still running. (`interp_has_threads` is left defined but unused.)

## Oracle failures
- `test_atexit.FunctionalTest.test_thread_created_in_atexit`: stdout is `24\n`
  instead of `24\n42\n` (thread not joined).
- `test_atexit.FunctionalTest.test_thread_created_in_atexit_subinterpreter`: reads
  `b'spanish'` instead of `b'spanishinquisition'`.

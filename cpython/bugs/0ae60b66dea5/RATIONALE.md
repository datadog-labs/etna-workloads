# Rationale

Fix: GH-113486, no spurious PY_UNWIND events for the `_Py_InitCleanup` shim frame
(flag `CO_NO_MONITORING_EVENTS`).

## Changes
1. `tree/Python/ceval.h`, `do_monitor_exc()`: removed the
   `if (_PyFrame_GetCode(frame)->co_flags & CO_NO_MONITORING_EVENTS) return 0;`
   early return. This reverses the fix's `Python/ceval.c` hunk (the function has since
   moved to `ceval.h`). Exception events (RAISE/UNWIND/...) are again reported for the
   shim frame of `CALL_ALLOC_AND_ENTER_INIT`.
   The flag and the other hunks (`code.h`, `specialize.c`, `_Py_Instrument` early
   exit) are left in place, since reverting them is not needed; the shim has no
   `_co_monitoring`, so the unguarded event dispatch dereferences NULL.
2. `tree/Python/ceval.c`: a comment only, next to `_PyEval_NoToolsForUnwind`. It is
   needed because `Python/ceval.h` is not a make dependency of `ceval.o`, so an
   incremental build would not otherwise recompile the change. No behaviour change.

## Oracle
`test_no_unwind_for_shim_frame` and most of `test_monitoring` fail: the interpreter
crashes (incomplete run) when the exception from `B.__init__` unwinds through the
shim frame and an event is fired for it, instead of producing only one unwind event.

# Rationale

Fix hunks reversed, all in `Python/pylifecycle.c` `new_interpreter()`:

1. The fix replaced `PyInterpreterState_New()` (which calls `Py_ExitStatusException()` on
   failure, killing the process when out of memory) with `_PyInterpreterState_New()`
   plus `goto error`. I restored the old call, the old `if (interp == NULL)` early return,
   and the original placement of the `save_tstate`/`tstate` declarations. In v3.15.2 the
   code differs only in the removed `check_enabled` atomic store, so the hunk maps directly.
2. The error path: restored the unconditional `else { PyInterpreterState_Delete(interp); }`
   (the fix added `else if (interp != NULL)`).

Oracle: `test_stress.StressTests.test_create_interpreter_no_memory` fails. With
`set_nomemory(0, 1)`, `_interpreters.create()` hits the allocation failure inside
`PyInterpreterState_New()`, which exits/crashes the process instead of raising
`InterpreterError`. The run crashes.

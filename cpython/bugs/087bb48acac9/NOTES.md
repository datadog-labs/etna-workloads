Calls `_interpreters.exec` with `shared={"\ud82a": 0}` (key can't be UTF-8 encoded).
Clean: raises UnicodeEncodeError (printed). Buggy: the assert `!_PyErr_Occurred(tstate)`
in `_run_in_interpreter` fires, so the process aborts (exit -6).

repro.py runs `_testcapi.run_in_subinterp` with code that starts a daemon thread
sleeping in the subinterpreter, so Py_EndInterpreter is called while that
thread is still alive.

- clean: prints `done`, exit 0.
- buggy: `Fatal Python error: Py_EndInterpreter: not the last thread`, abort (SIGABRT).

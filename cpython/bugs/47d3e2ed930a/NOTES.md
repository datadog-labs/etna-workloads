Runs `[0]*sys.maxsize` in a subinterpreter via `_testcapi.run_in_subinterp`.
Clean: prints a MemoryError traceback to stderr, then "done", exit 0.
Buggy: segfaults (exit -11), because the subinterpreter's static last-resort MemoryError has uninitialized `args` and printing it crashes.

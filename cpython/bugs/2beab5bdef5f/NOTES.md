Reproducer: sets `__defaults__` with more entries than the function has parameters, then calls it 1025 times so the call gets specialized.
Clean prints `done` (exit 0). Buggy aborts on the assertion `defcount <= code->co_argcount` in `specialize_py_call` (exit -6).

# gh-109894 reintroduced

Two changes, both reversing hunks of fix.patch:

1. `Include/internal/pycore_runtime_init.h`: removed `.args = &_Py_SINGLETON(tuple_empty)` from
   `last_resort_memory_error` (reverses the header hunk). `args` is NULL again, so printing the
   last-resort MemoryError dereferences NULL.
2. `Objects/exceptions.c` `_PyExc_InitGlobalObjects()`: restored the early return for
   non-main interpreters (reverses the exceptions.c hunk). Subinterpreters no longer preallocate
   MemoryErrors, so `PyErr_NoMemory()` falls back to the last-resort object.

Both are needed: with only one reverted, either the freelist or the initialised `args` hides the bug.
The v3.15.2 code is otherwise the same as the pre-fix code at these sites.

## Oracle
`test_exceptions.ExceptionTests.test_memory_error_in_subinterp` fails: the child process
crashes (fatal error with a traceback in `PyErr_Display`) instead of printing a MemoryError.

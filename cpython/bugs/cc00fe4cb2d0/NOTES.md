Reproducer: copies an empty dict via `d.copy()` while `_testcapi.set_nomemory(0)` forces allocation failure.
Clean: raises MemoryError (prints "MemoryError"). Buggy: the debug assert in
`copy_lock_held_untracked` dereferences the NULL result (`_PyObject_GC_IS_TRACKED(NULL)`) and crashes (SIGSEGV).

# Rationale

Changed `PyObject_ClearWeakRefs()` in `Objects/weakrefobject.c`, in the branch taken when `PyTuple_New(num_weakrefs * 2)` fails.

The fix replaced `_PyErr_ChainExceptions1(exc); return;` with a call that clears the weakrefs, then reports the error as unraisable, then restores the saved exception. In v3.15.2 that code is `_PyWeakref_ClearWeakRefsNoCallbacks(object)` followed by `PyErr_FormatUnraisable(...)` and `PyErr_SetRaisedException(exc)`. I put the pre-fix code back: `_PyErr_ChainExceptions1(exc); return;`.

This is equivalent to the pre-fix behaviour. The MemoryError from the failed allocation is left set, and the weakrefs are not cleared. Raising an exception from the deallocator is the bug the fix removed.

## Oracle failure
`test_weakref.ReferencesTestCase.test_no_memory_when_clearing` fails. The subprocess dies with `Fatal Python error: _Py_Dealloc: Deallocator of type 'TestObj' raised an exception` and a MemoryError object. The other 135 cases pass.

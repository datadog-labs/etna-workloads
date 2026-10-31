Reproducer: stores TypeVar objects in a WeakValueDictionary, so each gets a weakref. Each TypeVar is then freed while the weakref is still alive.
The bug is that typevar_dealloc no longer calls PyObject_ClearWeakRefs.
Clean: prints `0` then `ok`, exit 0. Buggy: segfaults (exit -11).

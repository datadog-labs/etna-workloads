Reproducer: a generic class `MyClass[V]` with a metaclass whose `__prepare__` returns a dict subclass whose `__missing__` raises RuntimeError for "T". The inner `class Inner[U](T)` looks up `T` via LOAD_FROM_DICT_OR_GLOBALS, and the lookup raises.

Clean: prints `RuntimeError`, exit 0.
Buggy: the error path of LOAD_FROM_DICT_OR_GLOBALS decrefs the wrong object and leaves the stack wrong. The debug build aborts with "_Py_NegativeRefcount: object has negative ref count" (exit -6).

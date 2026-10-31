Calls `_testcapi.create_managed_weakref_nogc_type()`, which builds a heap type with
Py_TPFLAGS_MANAGED_WEAKREF but no Py_TPFLAGS_HAVE_GC.

Clean: raises SystemError ("... has the Py_TPFLAGS_MANAGED_WEAKREF flag but not Py_TPFLAGS_HAVE_GC flag").
Buggy: the check is gone, so the type is created and the script prints "created ManagedWeakrefNoGCType".

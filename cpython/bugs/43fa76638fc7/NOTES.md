Runs the test's child script (50 weakrefs with callbacks, `_testcapi.set_nomemory(0)`, `del obj`) in a subprocess and prints whether stderr contains "_Py_Dealloc: Deallocator of type 'TestObj'".
Clean: False. Buggy: True (the failed tuple allocation in PyObject_ClearWeakRefs leaves an exception set during dealloc).

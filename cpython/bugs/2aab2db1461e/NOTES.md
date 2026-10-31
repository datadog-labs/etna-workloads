Calls PyErr_Occurred (restype=py_object) with no exception set, so it returns NULL. Clean: prints ValueError('PyObject is NULL'), exit 0. Buggy: segfault (exit -11) from Py_DECREF(NULL) in GetResult.

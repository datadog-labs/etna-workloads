Calls `_testcapi.pytype_getmodulebydef(int)` (PyType_GetModuleByDef on a static type).
Clean: raises TypeError "No superclass of 'int' has the given module".
Buggy: returns NULL without setting an exception (SystemError / assert in debug build).

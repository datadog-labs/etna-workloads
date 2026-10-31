Takes the implicit staticmethod `__new__` from a class `__dict__` (its `sm_dict` is still NULL) and does `del obj.__annotations__`.
Clean: AttributeError is raised, then `{}` is printed. Buggy: the NULL dict is used directly, so a C assertion fails
(`_PyType_LookupStackRefAndVersion: Assertion '!PyErr_Occurred()' failed`, exit -6).

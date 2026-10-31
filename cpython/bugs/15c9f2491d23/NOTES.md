Prints `bytes.maketrans.__module__` (a builtin staticmethod).
Clean: 'builtins'. Buggy: None, because the injection stops passing the type's module to PyCFunction_NewEx for METH_STATIC methods.

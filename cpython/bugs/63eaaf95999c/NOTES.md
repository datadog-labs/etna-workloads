Compiles `class i: [__classdict__ for x in y]` (and the `__conditional_annotations__` variants, one with a lambda) via exec.
Clean: NameError (y undefined at runtime). Buggy: SystemError from _PyST_GetScope at compile time, since the symtable inlining no longer drops these names as free through a class scope.

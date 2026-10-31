Reproducer: `inspect.ismethoddescriptor` on an instance of a class defining `__get__` and `__delete__` (no `__set__`).
Clean prints False (data descriptor); buggy prints True because the `__delete__` check was removed.

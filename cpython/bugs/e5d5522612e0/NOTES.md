Reproducer: desugared `test_mixed_staticmethod_hierarchy`. C.some (staticmethod) calls
zero-arg `super().some(cls)` where the second super arg is a type; B.some is a plain function
that forwards to A.some (staticmethod). Called in a loop so the specializing LOAD_SUPER_ATTR kicks in.

Clean: prints `('A', (), {})`. Buggy: `('A', (<class '__main__.C'>,), {})` — the specialized
super-method lookup checks `cls->tp_getattro` instead of `Py_TYPE(self)->tp_getattro`, so a
non-classmethod is treated as a found method and an extra argument is passed.

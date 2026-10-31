# Rationale

Fix hunk reversed: `Lib/functools.py` `partial.__new__`, `hasattr(func, "func")` -> `isinstance(func, partial)`.
(The C hunk, `Py_TYPE(func)->tp_call == partial_call` -> `PyObject_TypeCheck`, is not reversed: the C code
in v3.15.2 already differs, and the fix's own rationale was to align the Python version with C.)

In v3.15.2 the shared helper `_partial_new` in `Lib/functools.py` does `isinstance(func, base_cls)`.
I changed it so that for `partial` (base_cls is partial) the check is `hasattr(func, "func")` again, the
pre-fix duck-typed test. The `partialmethod` branch keeps `isinstance`, as it did before the fix
(reverting it too would break `partialmethod(partial(...))` at import time of test_functools, because the
C partial has a `func` attribute but no `_phcount`).

Oracle failures: `TestPartialPy.test_nested_optimization_bug` and
`TestPartialPySubclass.test_nested_optimization_bug` fail with RecursionError. A `Builder` whose `__getattr__`
returns `partial(self, tag)` makes `hasattr(self, "func")` true, so the object is wrongly treated as a partial
and flattened.

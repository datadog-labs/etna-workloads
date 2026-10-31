Defines a PEP 695 generic runtime protocol `P[T]` with one method and calls `issubclass(C, P)`.
Clean: prints `['meth']`, `[]`, `True`. Buggy: `__type_params__` is no longer excluded from protocol
attrs, so it is treated as a non-method member and issubclass() raises TypeError.

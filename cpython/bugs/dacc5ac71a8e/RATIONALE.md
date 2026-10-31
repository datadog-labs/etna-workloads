# Rationale

Changed `tree/Lib/inspect.py`, `ismethoddescriptor()`: the return expression is back to
`hasattr(tp, "__get__") and not hasattr(tp, "__set__")`. This reverses the fix's
`Lib/inspect.py` hunk, which added `and not hasattr(tp, "__delete__")`. Objects with
`__get__` and `__delete__` but no `__set__` (data descriptors) are again reported as method descriptors.

The docstring and docs hunks are left alone. They are not behaviour.

Failing oracle case: `TestIsMethodDescriptor.test_custom_descriptors` fails with
`True is not false : __get__ and __delete__ => not a method descriptor`.

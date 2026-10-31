Reproducer forces the pure-Python `functools.partial` (blocks `_functools`) and
builds `partial(self, tag)` inside a `__getattr__` on a callable object.
Clean: prints `('m', (1, 2), {'a': 2})`. Buggy: the `hasattr(func, "func")`
check triggers `__getattr__('func')`, recursing until RecursionError (exit 1).

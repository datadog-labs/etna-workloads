Reproducer: prints `inspect.signature` of a class wrapped with `warnings.deprecated` (whose `__new__` is a functools.wraps thin wrapper).
Clean: `(x, y)`. Buggy: `(*args, **kwargs)`, because the class-signature lookup no longer unwraps `__new__`/`__init__` wrapper chains.

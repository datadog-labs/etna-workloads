Reproducer: `inspect.signature()` of a class whose `__init__` is a `@classmethod` wrapping a `functools.wraps` decorated function.
Clean prints `(b)`. Buggy prints `(cls, b)`, because the injected code unwraps the bound method after binding and so no longer drops `cls`.

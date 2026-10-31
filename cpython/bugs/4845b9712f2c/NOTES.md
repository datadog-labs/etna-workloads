Decorates a function with `reprlib.recursive_repr()` and checks `wrapper.__wrapped__ is f`.
Clean prints `True`; buggy raises AttributeError because `__wrapped__` is no longer set.

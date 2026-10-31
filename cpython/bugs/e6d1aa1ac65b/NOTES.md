repro.py: a contextmanager raises an exception with `__context__` explicitly set to None, used directly and via ExitStack.enter_context.
Clean: both print `None` for `__context__`. Buggy: the ExitStack variant rewrites the context to the outer exception (prints `Exception('inner')`).

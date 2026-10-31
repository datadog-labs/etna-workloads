Runs the upstream test's code in a subprocess: `threading.x = sys.modules[__name__]` plus a `threading._DummyThread()`.
At shutdown, `_DeleteDummyThreadOnDel.__del__` runs after threading's globals are cleared.
Clean: empty stderr. Buggy (default args removed from `__del__`): "Exception ignored ... TypeError: 'NoneType' object does not support the context manager protocol". Only the last stderr line is printed (the rest has addresses/paths).

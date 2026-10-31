Reproducer for gh-99184: repr() of a weakref to an object whose `__getattr__` raises
KeyError (a dict subclass doing `self[x]`) for `__name__`.
Clean: the special-method lookup skips instance `__getattr__`, so repr works and prints True.
Buggy: the attribute lookup calls `__getattr__`, and the KeyError escapes from repr().

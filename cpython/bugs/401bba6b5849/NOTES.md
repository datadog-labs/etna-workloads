Blocks the C `_functools` module (`sys.modules['_functools'] = None`) so `functools` uses the pure-Python `partial`, then evaluates `functools.partial[int]`.
Clean: prints `functools.partial[int] (<class 'int'>,) ()`. Buggy: `TypeError: type 'partial' is not subscriptable` (`__class_getitem__` missing).

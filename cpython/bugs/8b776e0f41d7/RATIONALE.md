# Rationale

Fix hunk reversed: the `if not args: raise TypeError(... requires at least 1 positional argument)`
guard added to the `singledispatchmethod` `_method` closure in `__get__`.

In v3.15.2 that logic lives in `_singledispatchmethod_get.__call__` (Lib/functools.py).
I removed the same guard there, so an empty `*args` goes straight to
`args[self._dispatch_arg_index]` and raises `IndexError` (the "index out of bounds"
from the NEWS entry) instead of `TypeError`.

The plain `singledispatch` wrapper check is untouched. The fix only touched a blank line there.

Oracle failure: `TestSingleDispatch.test_invalid_positional_argument_singledispatchmethod`
fails with `IndexError: tuple index out of range` from `A().t()`.

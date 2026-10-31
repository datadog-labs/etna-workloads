# Rationale (gh-125767: pickling/copying of super objects)

The fix's implementation hunks are in Lib/ and still apply, so they were reversed directly:

- `Lib/copy.py`: removed `super` from `_copy_atomic_types`. This reverses the `weakref.ref, super` hunk. `copy.copy(super_obj)` goes back to the generic `__reduce_ex__` path, which copies the instance that super() wraps.
- `Lib/copyreg.py`: removed `pickle_super` and `pickle(super, pickle_super)`. This reverses the `copyreg` hunk. Pickling and deep copying a super object again fall back to `object.__reduce_ex__`, which is forwarded to the wrapped instance.

Oracle cases that fail: `test_shallow_copying` (`copy.copy(s)` returns an `E` instance, not `s`), `test_deep_copying` and `test_pickling` (the result is the wrapped instance or an error, not a super object). Overall the run shows 4 failures and 10 errors.

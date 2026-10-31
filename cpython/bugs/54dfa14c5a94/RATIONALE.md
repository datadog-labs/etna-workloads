# Rationale (gh-101765)

The fix moved `_PyEval_GetBuiltin(&_Py_ID(iter))` out of the `Py_BuildValue(...)` argument list, so it runs before the iterator's pointers are read. I put it back inside the argument list in these functions:

- `Objects/iterobject.c`: `iter_reduce` and `calliter_reduce` (fix hunks for iterobject.c).
- `Objects/unicodeobject.c`: `unicodeiter_reduce`.
- `Objects/bytesobject.c`: `striter_reduce`.
- `Objects/bytearrayobject.c`: `bytearrayiter_reduce`.

In each, the builtin lookup can run arbitrary `__eq__` code through a custom key in `builtins.__dict__`. That code can exhaust the iterator. The arguments `it->it_seq` and `it->it_index` are evaluated before the call (unspecified C order; right-to-left on gcc), so the pre-exhaustion state is returned.

I left tuple, list, genericalias and the other reduce functions with the fixed ordering. The reverted functions are enough to bring the bug back.

Failing oracle case: `test_iter.TestCase.test_reduce_mutating_builtins_iter`. `run_iter("xyz")` returns `(iter, ('xyz',), 0)` instead of `(iter, ('',))`.

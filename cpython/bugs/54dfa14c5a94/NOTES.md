`repro.py` swaps the `iter` key in `builtins.__dict__` for an object whose `__eq__` exhausts the iterator.
It then calls `__reduce__` on iterators over a str, a `__getitem__` class, bytes, bytearray and a callable with a sentinel.

- Clean: `__reduce__` looks up `iter` first, so it sees the exhausted iterator and returns `(iter, ('',))` or `(iter, ((),))`.
- Buggy: the iterator state is read before the `_PyEval_GetBuiltin` call, so the result is stale, e.g. `(iter, ('xyz',), 0)`.
  (These outputs include object addresses; the clean output is deterministic.)

# Reproducer notes

`repro.py` builds `deque([A()])` where `A.__eq__` clears the deque (`d.clear()`)
and returns `NotImplemented`, then calls `d.index(0)`.

`deque.index()` iterates over the underlying block list, comparing each
element to the target with `PyObject_RichCompareBool`. The comparison can run
arbitrary Python code (here, `A.__eq__`), which mutates the deque out from
under the iteration (`d.clear()` frees the deque's blocks). After the
comparison, `index()` checks a saved `state` counter against the deque's
current state and raises `RuntimeError("deque mutated during iteration")` if
they differ — this is what happens on `python-clean`.

The injected bug removes the `Py_NewRef`/`Py_DECREF` pair around the borrowed
`item` reference before the comparison. Without that extra reference, once
`d.clear()` drops the deque's own reference to the single element, `item`
becomes a dangling pointer to freed memory, and `PyObject_RichCompareBool`
operates on it (use-after-free) instead of safely completing before the
mutated-state check can catch it.

## Observed difference

- `bin/python-clean`: exits 0, prints `RuntimeError deque mutated during iteration`.
- `bin/python-buggy`: crashes with SIGSEGV (exit status -11) under the
  use-after-free, instead of raising `RuntimeError`.

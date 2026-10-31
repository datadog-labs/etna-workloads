# Reproducer notes

`repro.py` exercises `collections.Counter.update()` (which internally calls
`_count_elements`) with a key whose current value is an `int` subclass that
overrides `__add__` to clear the `Counter` and return `NotImplemented`. This
forces `PyNumber_Add` to run arbitrary Python code that frees the dict's
value slots while `_count_elements` still holds a borrowed reference to the
old value (`oldval`), re-triggering the GH-143004 use-after-free fixed by
`fix.patch` (upstream commit 86d904588e8c).

Observed difference:

- `bin/python-clean` (fix applied): prints `1` and exits with status 0.
- `bin/python-buggy` (`injection.patch` applied, which removes the
  `Py_INCREF`/`Py_DECREF` guarding `oldval`): crashes with a segmentation
  fault (exit status 139), since `oldval` has already been deallocated by
  the time `PyNumber_Add` returns and is dereferenced further (it's a
  debug build, so the use-after-free manifests as a crash rather than
  silently using freed memory).

# Reproducer notes

`repro.py` is a direct translation of the upstream regression test
`test_lt_operator_modifying_operand` added by `fix.patch` (gh-120298).

It builds `a = [[Evil()]]`, a list whose only element is itself a
single-element list containing an `Evil` instance. `Evil.__lt__` clears
its `other` argument (shrinking/freeing that inner list's storage) and
returns `NotImplemented`. Evaluating `a[0] < a` makes `list_richcompare`
compare the lists' last common item, `a[0][0]` vs `a[0]`: this calls
`Evil.__lt__(a[0][0], a[0])`, which clears `a[0]` out from under the
comparison, invalidating the `ob_item` pointers that were already read out
of the list objects before the user `__lt__` ran.

- On `bin/python-clean` (with the fix: the item pointers are Py_INCREF'd
  before the call and Py_DECREF'd after), the list comparison falls through
  and raises `TypeError` as expected (no working `__lt__`/`__gt__` leaves
  both sides `NotImplemented`), so the script prints `TypeError raised` and
  exits 0.
- On `bin/python-buggy` (`injection.patch` reverts the fix), the item
  pointers are read and then dereferenced via `PyObject_RichCompare` only
  *after* `__lt__` has already cleared/freed the owning list's storage,
  producing a use-after-free. Under the pydebug build this trips a debug
  assertion / invalid memory access and the interpreter crashes with
  SIGSEGV (exit status -11) instead of raising `TypeError`.

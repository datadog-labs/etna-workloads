# Rationale

Fix hunk (Python/import.c): in the lazy-import filter call, a NULL `fromlist`
(from `__lazy_import__(name)` with no fromlist) was replaced by `Py_None`
before being put in the `args[]` passed to the filter. Without it, a NULL
pointer reached `PyObject_Vectorcall` and crashed.

In v3.15.2 the normalisation moved earlier (`fromlist = Py_NewRef(... : Py_None)`
before the filter), so the fix hunk can't be reversed directly. Instead I
save the raw argument as `orig_fromlist` and pass it to the filter in
`args[]`. The rest of the function still uses the normalised `fromlist`, as
before. A NULL fromlist therefore reaches the user filter again, which is
the pre-fix behaviour.

Oracle: with a user-defined filter set, `__lazy_import__` without a fromlist
crashes the interpreter. `test_dunder_lazy_import_with_custom_filter` fails,
and the test run aborts, so the remaining cases are reported failing.

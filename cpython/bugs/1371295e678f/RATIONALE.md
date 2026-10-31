# Rationale

## Bug

gh-126366: `yield from` on an object whose `__iter__` raises crashed the
interpreter, because the non-generator branch of the GET_ITER-for-yield-from
path converted the result of `PyObject_GetIter()` into a stack reference and
then checked the *stack reference* for "null", instead of checking the
`PyObject *` result directly for `NULL`. When `__iter__` raised, `GetIter`
returned `NULL`, but wrapping `NULL` in `PyStackRef_FromPyObjectSteal` does
not necessarily produce the "null" stackref value the old check looked for,
so the error path was skipped and execution continued with a bogus iterator
while an exception was already set.

## Fix hunks reversed

The fix (`Python/bytecodes.c`, mirrored in the generated
`Python/executor_cases.c.h` / `Python/generated_cases.c.h`) reorders the
code to check `PyObject_GetIter()`'s raw `PyObject *` result for `NULL`
*before* wrapping it in a stackref, and only wraps it afterwards.

In v3.15.2 this logic has been refactored into a shared helper,
`_PyEval_GetIter()` in `Python/ceval.c`, called from the `_GET_ITER` op
(used for both plain `GET_ITER` and the yield-from use via `oparg`). The
tail of that function was:

```c
PyObject *iter_o = PyObject_GetIter(PyStackRef_AsPyObjectBorrow(iterable));
PyStackRef_CLOSE(iterable);
if (iter_o == NULL) {
    return PyStackRef_ERROR;
}
return PyStackRef_FromPyObjectSteal(iter_o);
```

This already has the correct "check raw pointer first" structure the fix
restores, so simply reversing the historical diff would do nothing (other
code already covers the case). The bug is reintroduced by removing exactly
the `iter_o == NULL` check that the fix relies on, so a `NULL` result from
`PyObject_GetIter()` is now unconditionally handed to
`PyStackRef_FromPyObjectSteal`, which is the same "NULL iterator with an
exception already set is allowed to flow onward" defect the fix closed:

```c
PyObject *iter_o = PyObject_GetIter(PyStackRef_AsPyObjectBorrow(iterable));
PyStackRef_CLOSE(iterable);
return PyStackRef_FromPyObjectSteal(iter_o);
```

Every changed line traces back to the hunk in `Python/bytecodes.c` (and its
generated mirrors) that introduced the `iter_o == NULL` check; this is the
same code path, just reached via `_PyEval_GetIter` instead of being inlined
in the bytecode handler (the bytecode handler now just calls
`_PyEval_GetIter`).

## Result

`./check.sh` on the modified tree reports the oracle file crashing: the
interpreter run for `Lib/test/test_yield_from.py` aborts (illegal
instruction / crash) partway through, and all 36 remaining oracle cases
(including the fix's own regression test,
`TestInterestingEdgeCases.test_throws_in_iter`, which specifically exercises
`__iter__` raising inside `yield from`) are reported as failing because the
run never completes. This matches the original bug report: a crash caused
by `__iter__` raising during `yield from`.

# Rationale

Fix hunk reversed: `partial_repr` in Modules/_functoolsmodule.c (gh-144475).
The fix takes strong references to `pto->fn`, `pto->args` and `pto->kw` before
building the repr, and releases them at `done:`. In v3.15.2 that code was
still present (with a critical section added around the kw loop), so I reverted
only the reference management:

- Removed `Py_NewRef` on fn/args/kw. They are now borrowed pointers read
  straight from `pto` (the old code used `pto->fn`, `pto->args`, `pto->kw`
  directly). Local aliases are kept so the rest of the function is unchanged.
- Removed the matching `Py_DECREF(fn/args/kw)` at `done:`.

An element's `__repr__` can call `partial.__setstate__`, which replaces and
frees the tuple, dict and function that the loop is still using, giving a
use-after-free.

## Oracle
`TestPartialC.test_repr_safety_against_reentrant_mutation` and
`TestPartialCSubclass.test_repr_safety_against_reentrant_mutation` fail. The
interpreter crashes in the run, so the remaining C partial tests are reported
as failing too (incomplete run).

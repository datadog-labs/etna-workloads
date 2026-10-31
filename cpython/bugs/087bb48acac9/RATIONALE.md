# Rationale

Fix (gh-127196) changed `_run_in_interpreter` in Modules/_interpretersmodule.c: when
`_PyXI_Enter` fails *before* switching interpreters (e.g. `shared` has a key that
can't be encoded, giving UnicodeEncodeError), an exception is set. The old code
did `assert(!PyErr_Occurred())`, which fails; the fix returns -1 with the error.

In v3.15.2 the function was restructured: the failure path in
`_run_in_interpreter` (Modules/_interpretersmodule.c) already returns -1 with the
exception propagated. I restored the pre-fix wrong assumption there by adding
`assert(!_PyErr_Occurred(tstate));` on that path (the equivalent of the removed
assert), i.e. asserting that no exception is pending when `_PyXI_Enter` fails.

Oracle: on a debug build, `test_invalid_shared_encoding` aborts with an assertion
failure (crash), killing the whole test process, so all oracle cases of
test__interpreters are reported failing (incomplete run: crash).

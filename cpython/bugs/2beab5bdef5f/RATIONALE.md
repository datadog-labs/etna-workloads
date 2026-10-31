# Rationale

Fix GH-105840 changed `specialize_py_call` in Python/specialize.c. It computed `defcount`, dropped
`assert(defcount <= argcount)`, and added a `min_args < 0` bail-out.

In v3.15.2 the `min_args`/`nargs` check no longer exists, because CALL_PY_GENERAL handles any arg count.
The only part of the fix that can be reverted is therefore the pre-fix assertion. I re-added it in
`specialize_py_call`, together with the `defcount` computation it needs:

    int defcount = ...PyTuple_GET_SIZE(func->func_defaults);
    assert(defcount <= code->co_argcount);

When `__defaults__` is longer than `co_argcount` (the fix's case), specializing a call now aborts on the assertion. This is the original failure.

Oracle: `test_too_many_defaults_0/1/2` fail. The interpreter aborts on the assertion, so the rest of the run is incomplete and the other test_opcache cases are reported as failing too.

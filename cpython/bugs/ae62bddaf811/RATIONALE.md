# Rationale

## Objects/funcobject.c, `_PyFunction_FromConstructor`
Reverses the fix hunk that changed `op->func_defaults = NULL; op->func_kwdefaults = NULL;`
to `Py_XNewRef(constr->fc_defaults/fc_kwdefaults)`. The constructor is restored to
ignoring `fc_defaults`/`fc_kwdefaults`, so `PyEval_EvalCodeEx` (which passes them via
`PyFrameConstructor`) builds a function with no defaults or kwdefaults.

The fix's ceval.c hunk (removing a duplicated `PyTuple_SET_ITEM` kwnames loop) is not
reintroduced; the duplicate loop would leak refs and is not part of the defaults bug.

## Oracle failures
`test_with_default` fails (`f() missing 1 required positional argument: 'a'`) and
`test_with_kwarg_default` fails (`missing 1 required keyword-only argument: 'a'`).

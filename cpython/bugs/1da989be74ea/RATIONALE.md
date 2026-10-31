# Rationale

Fix: gh-138479, `_Py_subs_parameters` (Objects/genericaliasobject.c) must check that `__typing_subst__` returns a tuple when the argument is an unpacked TypeVarTuple.

## Changes (Objects/genericaliasobject.c, `_Py_subs_parameters`)
- Removed the `if (!PyTuple_Check(arg)) { ... PyErr_Format(TypeError ...) }` block in the `if (unpack)` branch. This reverses the fix's first hunk. The code is the same as before the fix: the result of `__typing_subst__` goes straight to `PyTuple_GET_ITEM`/`PyTuple_GET_SIZE` and `tuple_extend`.
- Removed the `assert(newargs == NULL)` in the `jarg < 0` path. This reverses the fix's second hunk. It is a debug-only assertion.

## Oracle
`test.test_typing.GenericTests.test_return_non_tuple_while_unpacking` fails. `__typing_subst__` returns `42`, which is read as a tuple, so the interpreter crashes. The test run is incomplete, and about 512 of the 732 oracle cases show as failing for that reason.

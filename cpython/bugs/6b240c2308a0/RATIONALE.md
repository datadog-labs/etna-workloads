# Rationale

## Hunk changed
`Objects/typeobject.c`, `type_get_type_params`: removed the
`if (type == &PyType_Type) { return PyTuple_New(0); }` special case. This
reverses the single implementation hunk of the fix. The code was moved but is
otherwise identical to the pre-fix function. Without the special case,
`type.__type_params__` looks up `type.__dict__['__type_params__']`, which is
the getset descriptor itself, so the descriptor is returned instead of `()`.

## Oracle failures
`test.test_type_params.TypeParamsAccessTest.test_type_special_case` fails:
`<attribute '__type_params__' of 'type' objects> != ()`. The functools
`test_update_type_wrapper` case guards the same defect.

# gh-128632: `__classdict__` allowed as a type parameter name

## Change
`tree/Python/symtable.c`, `symtable_visit_type_param_bound_or_default`: removed the
early check that rejects the name `__classdict__` with
"reserved name '__classdict__' cannot be used for type parameter". This reverses the
fix's main symtable.c hunk (the signature change `void *key` -> `type_param_ty tp`
is a refactor needed only by the error location; left as-is, it is harmless).
Without the check, a type param named `__classdict__` collides with the implicit
`__classdict__` cell/free var, which is the original bug (wrong freevar index; crash
or assertion in a debug build).

The assert added in assemble.c is only a diagnostic and was not touched.

## Oracle failures
`test_syntax.test_disallowed_type_param_names` fails (for both the LazyImportRestrictionTestCase
variant and the plain one): `compile("class A[__classdict__]: pass")` no longer raises SyntaxError.

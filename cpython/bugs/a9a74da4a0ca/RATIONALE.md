# Rationale

Fix: gh-119311/gh-119395 added `ste_mangled_names` and `_Py_MaybeMangle`, so that
inside the type-parameter scope of a generic class only the type parameter names
are mangled. In v3.15.2 the surrounding code (symtable `st_private` ordering,
codegen passing the class name as private) is already in its fixed form, and the
fix's call-site hunks are already in place, so reversing them does not apply.

Changed: `Python/symtable.c`, `_Py_MaybeMangle`: removed the `ste_mangled_names`
check, so every name in the type-param scope is mangled with the class name
(the pre-fix behaviour, where `_Py_Mangle` was called unconditionally). This
reverses the new function's filtering (the `_Py_MaybeMangle` hunk, which also
governs the callers changed in compile.c and symtable.c hunks).

Failing oracle cases: the run reports 2 errors in test_type_params, including
`TypeParamsManglingTest.test_no_mangling_in_nested_scopes`
(`NameError: name '_Y__X' is not defined`): private names in the bases/bounds
of a generic class are wrongly mangled. I did not identify the second failing
case by name.

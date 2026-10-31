# Rationale

Fix gh-137814 added `ste_function_name` to annotation symtable entries so `compiler_set_qualname` (Python/compile.c) can prefix `__annotate__` with the owning function's name. In v3.15.2 all fix hunks still apply, so reverse hunks were not needed except the one that populates the field.

## Change
- `Python/symtable.c`, `symtable_visit_annotations`: removed `Py_XSETREF(st->st_cur->ste_function_name, Py_NewRef(function_ste->ste_name));` (reverses the fix's last symtable.c hunk). `ste_function_name` stays NULL, so the (now dead) compile.c branches don't fire and the qualname is built from the enclosing scope only, as before the fix.

## Oracle
`RegressionTests.test_annotate_qualname` fails: `'Outer.__annotate__' != 'Outer.method.__annotate__'`.

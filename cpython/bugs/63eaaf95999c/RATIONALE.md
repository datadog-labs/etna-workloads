# Rationale

Single file changed: `tree/Python/symtable.c`, `inline_comprehension()`.

v3.15.2 already contained the fix's logic (plus a later `is_free_in_any_child` refinement). I reverted only the fix's three hunks:

1. Removed the `remove_dunder_classdict` and `remove_dunder_cond_annotations` flags (fix hunk 1).
2. Narrowed the class-scope FREE special case back to `__class__` only. `__classdict__` and `__conditional_annotations__` no longer have scope set to GLOBAL_IMPLICIT or get discarded from `comp_free` (fix hunk 2). The `is_free_in_any_child` check is kept because it is unrelated later code.
3. Removed the `PyDict_DelItemString` calls for `__classdict__` and `__conditional_annotations__` (fix hunk 3).

The result is the pre-fix behaviour: those names stay free through a class-scope inlined comprehension, which gives a SystemError.

## Oracle failures
`test_references___classdict__`, `test_references___conditional_annotations__` and `test_references___conditional_annotations___nested` fail. The first two fail because the name is a freevar of the class code and the compiler can't resolve it. The nested test fails with `SystemError: _PyST_GetScope(name='__conditional_annotations__') failed: unknown scope`.

# Rationale

Changed `inline_comprehension` in `Python/symtable.c` (one hunk). The fix added
special handling when `__class__` is free in an inlined comprehension and unbound in
the enclosing class: set `scope = GLOBAL_IMPLICIT`, drop `DEF_FREE`, discard from
`comp_free`, and delete it from `comp->ste_symbols`. In v3.15.2 this logic is
generalised to `__class__`/`__classdict__`/`__conditional_annotations__`, and the
`ste_free` update no longer exists. I restored the pre-fix behaviour for `__class__`
only: the `scope = GLOBAL_IMPLICIT` override is skipped for `__class__`, so it is
copied into the class scope as FREE. `drop_class_free` then removes it from the free
set, leaving a FREE symbol without a recorded scope.

## Oracle failures
`test_references___class__`, `test_references_super`, `test_references___class___enclosing`,
`test_references___class___nested`, `test_super_and_class_cell_in_sibling_comps` fail with
`SystemError: _PyST_GetScope(name='__class__') failed: unknown scope`. This is the
compilation crash the fix addressed.

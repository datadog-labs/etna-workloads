# Rationale

Only the `Objects/moduleobject.c` hunk of the fix is reversed. The compiler/symtable hunks
(module-level annotations treated as conditional) are already present in v3.15.2 and I left them alone.

## Objects/moduleobject.c, `module_get_annotations`
Reverses the fix hunks that (a) looked up `__spec__` and computed `is_initializing` via
`_PyModuleSpec_IsInitializing`, and (b) guarded the cache write with `!is_initializing`.
I removed the `__spec__` lookup block and restored `if (annotations) {`, so `__annotations__` is again
cached in the module dict even while the module is still being imported. This is the pre-fix code.

## Oracle failure
`test_type_annotations.TypeAnnotationTests.test_partially_executed_module` fails:
`partialexe.a.__annotations__` is `{'v1': int}` instead of `{'v1': int, 'v2': int}`. Accessing
`__annotations__` mid-import caches the partial result, and it is never refreshed once the module finishes.
The other oracle cases pass.

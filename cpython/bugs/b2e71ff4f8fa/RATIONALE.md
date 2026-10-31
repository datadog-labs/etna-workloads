# gh-120161 reintroduced

v3.15.2 finalizes the datetime static types from the runtime (`_PyTypes_FiniExtTypes()` in `finalize_interp_types()`). The bug returns when that finalization happens in an atexit hook instead.

- `Python/pylifecycle.c`: removed the `_PyTypes_FiniExtTypes(interp)` call from `finalize_interp_types()`. This reverses the fix's pylifecycle hunk.
- `Objects/typeobject.c`, `Include/internal/pycore_typeobject.h`: re-added exported `_PyStaticType_FiniForExtension()` (the function the fix replaced with `_PyTypes_FiniExtTypes`). The new `_PyTypes_FiniExtTypes` is left in place but is now unused.
- `Modules/_datetimemodule.c`: restored the `_globals` interp counter, `callback_for_interp_exit()`, and the `PyUnstable_AtExit` registration, now in `_PyDateTime_InitTypes()`, since `init_static_types` no longer exists. This reverses the fix's `_datetimemodule.c` hunks.

Result: the types are finalized very early (atexit), while a subclass such as `tzutc` is still alive until the final GC. check.sh gives `Assertion managed_static_type_index_is_set(self) failed` in `managed_static_type_index_get`, which fails `ExtensionModuleTests.test_gh_120161` (datetimetester: 1 failure).

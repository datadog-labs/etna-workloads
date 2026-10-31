# Rationale

v3.15.2 already contains the fix's `running` flag and BEGIN/END_USING_* macros, so the fix hunks do not reverse cleanly. I removed the reentrancy guard calls in `Modules/_pickle.c`:

- `_pickle_Pickler_dump_impl`: removed `BEGIN_USING_PICKLER(self, NULL)` (reverses the dump hunk).
- `_pickle_Pickler___init___impl`: removed `BEGIN_USING_PICKLER(self, -1)`.
- `_pickle_Unpickler_load_impl`: removed `BEGIN_USING_UNPICKLER(self, NULL)`.
- `_pickle_Unpickler___init___impl`: removed `BEGIN_USING_UNPICKLER(self, -1)`.

The `running` field and macros stay, so the `__sizeof__` tests still pass. The END macros just reset the flag to 0, which is harmless. Concurrent calls from `__reduce__` or a reducer no longer raise RuntimeError, as before the fix.

Failing oracle cases: test_concurrent_pickler_dump, test_concurrent_pickler_dump_and_init, test_concurrent_unpickler_load and test_concurrent_unpickler_load_and_init (RuntimeError not raised). test_unpickle_module_race also fails in 3 variants; I did not look into why.

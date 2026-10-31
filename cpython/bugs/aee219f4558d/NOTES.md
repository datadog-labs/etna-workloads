Loads the `_testsinglephase_circular` module from `_testsinglephase`'s shared library. Its PyInit_* imports a helper module that imports the same extension again (gh-123880).

- clean: prints the helper module name and `True`, exit 0.
- buggy: aborts with `Assertion 'value == NULL' failed` in `_extensions_cache_set` (exit -6). Without the debug assert, it would raise SystemError "already cached".

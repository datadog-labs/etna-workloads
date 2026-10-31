# Rationale

Fix gh-132775 (hunks in `Python/crossinterp.c`, `_PyPickle_Loads` and helpers) replaced
"set the missing attribute on the real `__main__`" with "swap a hidden module (the
script run via runpy) in as `__main__` during the retry unpickle, then restore".
v3.15.2 still has the fixed design, so I reverted its effect, not its text:

- `apply_isolated_main()` no longer calls `_PyImport_SetModule(__main__, loaded)`.
  It copies the loaded script's names into the real `__main__` dict (missing names only),
  which is what the pre-fix `_unpickle_context_set_module` / `_handle_unpickle_missing_attr`
  did (`PyObject_SetAttrString(mod.module, attrname, value)`).
- `restore_main()` no longer swaps back, since nothing was swapped.

Result: functions passed to `Interpreter.call()` leak their script's globals into the
other interpreter's `__main__`, and the unpickled function's `__globals__` is the real `__main__`.

Failing oracle cases (2 in test_interpreters.test_api): `test_func_in___main___hidden`
and the global-state test (`test_func_in___main___uses_globals`-style), where the
other interpreter's `__main__` unexpectedly contains `count`, `inc`, `get_count`.
The refcount-leak hunks and the assert were not touched.

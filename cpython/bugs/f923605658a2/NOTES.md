repro.py calls `gc.get_referents()` on an untracked capsule (`_datetime.datetime_CAPI`).

- clean: prints `False` and `0`, exit status 0.
- buggy: `capsule_traverse` asserts `traverse_func != NULL`. The interpreter aborts with `Assertion 'capsule->traverse_func != NULL' failed` (SIGABRT, status -6).

`gc.get_referents()` calls tp_traverse even on untracked objects. The fix makes `capsule_traverse` tolerate a NULL `traverse_func`.

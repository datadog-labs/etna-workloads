# Rationale (gh-130555, dict.clear() UAF with embedded values)

Only file changed: `tree/Objects/dictobject.c`, `clear_lock_held()`.

v3.15.2 already had the fix's shape (`clear_embedded_values`, with atomic stores for free-threading), so the fix hunks could not be reversed textually.

- Hunk "add `clear_embedded_values()`": removed the helper. It snapshotted the values into `refs[]`, NULLed the slots and set `size = 0` *before* any DECREF.
- Hunk "`else if (oldvalues->embedded)` branch": removed it and restored the old single `else` branch. The values are decref'd one by one while the dict still looks populated. `size = 0` is only set after the loop, for embedded values. For non-embedded values `set_values`/`set_keys` still run after the loop, as in the pre-fix code.
- The per-slot `FT_ATOMIC_STORE_PTR_RELEASE` NULLing (added since the fix) is kept; it is harmless to the bug. The non-embedded `set_values(NULL)`/`set_keys(EMPTY)` ordering is also restored to after the loop, as before the fix.

A destructor run by `Py_XDECREF` can therefore re-enter the dict (`del`, insert forcing the dict to combined form, last reference dropped via a cycle). It then sees stale keys and values, and `oldvalues` can be freed while `clear_lock_held` is still using it.

## Oracle results
`./check.sh`: the run crashes (the interpreter aborts), so most of test_dict is reported as failing. The targeted cases `test_clear_reentrant_embedded`, `test_clear_reentrant_cycle`, `test_clear_reentrant_force_combined` and `test_clear_reentrant_delete` are among the failures.

# gh-142783 zoneinfo use-after-free (reintroduced)

All changes are in `tree/Modules/_zoneinfo.c`; v3.15.2 already had the fix, so each hunk is reversed by hand.

- `get_weak_cache`: the fix returns a new reference (`Py_INCREF` for the base type, plain `GetAttrString` result otherwise). I restored the old borrowed-reference version: no INCREF, and `Py_XDECREF(cache)` on the getattr result.
- `zoneinfo_ZoneInfo_impl`: removed the four `Py_DECREF(weak_cache)` calls (three error paths plus the success path). The v3.15.2 `PyObject_TypeCheck` error path also has one, and I removed that too. Without the INCREF in `get_weak_cache`, these DECREFs would be unbalanced.
- `zoneinfo_ZoneInfo_clear_cache_impl`: removed the `Py_DECREF(weak_cache)` calls on the `pop`/`iter` error paths and the final one.

Together these restore the borrowed-reference contract. With a descriptor `_weak_cache` whose `__get__` returns a fresh `{}`, the getattr result is freed right after the XDECREF. `weak_cache` then dangles, and `.get`/`.setdefault`/`.clear` run on freed memory.

Oracle result: `test_weak_cache_descriptor_use_after_free` fails with a crash. The run aborts, so the remaining C zoneinfo cases are reported as failing too (182 of 226).

# Reproducer notes

`repro.py` is a trimmed-down version of the new upstream test
`test.test_array.MiscTest.test_fromlist_reentrant_index_mutation`.

It calls `array.array(typecode).fromlist(lst)` for `typecode` in `"I"`,
`"L"`, `"Q"`, where `lst` holds a single `Evil` instance. `Evil.__index__`
clears `lst` (dropping the last reference to itself) and then returns a
non-int (`"not an int"`), so `_PyNumber_Index` raises `TypeError`.

- On `bin/python-clean` (fix applied): the `*_setitem` helpers in
  `arraymodule.c` keep an extra reference on `v` (`Py_INCREF(v)` /
  `Py_DECREF(v)`) around the `_PyNumber_Index(v)` call, so the `Evil`
  object stays alive long enough for the call to safely fail with
  `TypeError: Evil.__index__() must return an int, not str`, printed for
  each typecode.
- On `bin/python-buggy` (bug injected): the extra reference is gone, so
  when `__index__` clears `lst` the only reference to `v`/`Evil` drops to
  zero and the object is freed while `_PyNumber_Index` is still using it
  (and `fromlist`'s iteration still holds a now-dangling borrowed
  reference). This causes a use-after-free; the debug build's asserts
  catch the corruption and the process segfaults (exit status -11)
  instead of printing anything.

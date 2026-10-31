# repro.py

Translates `test.test_memoryview.*.test_hash_use_after_free` (added by
`fix.patch`) into a standalone script, using only the `array.array` variant
since the bug is in `memoryview.__hash__` itself, not in the backing buffer
type.

It defines an `array.array` subclass `E` whose `__hash__` releases the
memoryview over it (`mv.release()`) and clears the array's own storage
(`self.clear()`) as a side effect of being re-entrantly hashed from inside
`memory_hash()`. It then takes a read-only `memoryview` of an `E` instance
and calls `hash(mv)` and `mv.__hash__()`.

`memory_hash()` computes the hash of the exporting object (`view->obj`) by
calling `PyObject_Hash(view->obj)` *before* re-validating that the
memoryview is still valid. Since that call can run arbitrary Python code
(here, `E.__hash__`), it can release the buffer and free the underlying
array storage out from under the memoryview while `memory_hash()` is still
about to read bytes from it.

- **python-clean** (fix applied): `self->exports` is incremented before
  calling `PyObject_Hash(view->obj)`, which makes `mv.release()` raise
  `BufferError: memoryview has 1 exported buffer` instead of actually
  releasing the buffer. Both `hash(mv)` and `mv.__hash__()` fail with that
  `BufferError`, caught and printed by the script.
- **python-buggy** (bug re-introduced): there is no such guard, so
  `mv.release()` succeeds inside `E.__hash__`, the array's backing buffer is
  released and freed, and `memory_hash()` goes on to compute a hash over the
  now-freed memory. Both calls return a hash value (`OK <hash>`) instead of
  raising, i.e. a classic use-after-free that `python-clean` detects and
  rejects.

Output differs deterministically between the two interpreters (checked with
`PYTHONHASHSEED=0`): `python-clean` prints two `BufferError` lines,
`python-buggy` prints two `OK <hash>` lines, both with exit status 0 (no
crash under this non-ASan debug build, but the result is silently wrong).

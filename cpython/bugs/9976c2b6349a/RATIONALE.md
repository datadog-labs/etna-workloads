# gh-143195 re-injected

The fix's hunks still applied cleanly in spirit to v3.15.2 (with `FT_ATOMIC_ADD_SSIZE` in memoryview), so I removed the guards directly.

- `Objects/bytearrayobject.c` `bytearray_hex_impl`: removed the `ob_exports++/--` around `_Py_strhex_with_sep()` (reverses the bytearray hunk). Without it, `sep.__len__` can `ba.clear()` and free the buffer, which is then used (UAF) instead of raising BufferError.
- `Objects/memoryobject.c` `memoryview_hex_impl`: removed the `exports` increment/decrement around the contiguous-path `_Py_strhex_with_sep()` call (reverses the memoryview hunk).

Oracle: the new `test_hex_use_after_free` tests fail (test_memoryview: BufferError not raised by hex; test_bytes equivalent), and the 6 failures in test_memoryview are the hex tests across the buffer-source variations.

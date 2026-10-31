# NOTES

`repro.py` reproduces gh-143003: a shared-buffer overflow in
`bytearray.extend()` when the iterable's `__length_hint__()` lies and
returns 0 for a non-empty iterator.

`bytearray_extend_impl` starts with `buf_size = 0` (the shared, static,
zero-length buffer used by all empty bytearrays) and pre-sizes the new
buffer using the iterator's length hint. With `EvilIter.__length_hint__`
returning 0 while the iterator actually yields two bytes (`b'42'`), the
loop never resizes `buf` before writing into it.

- In the fixed/clean interpreter, `buf[len++] = value;` runs *after* the
  resize check, so the write only happens once `buf` is guaranteed big
  enough (and the `addition = len ? len >> 1 : 1` ensures growth even
  from `len == 0`). The overflowing bytes never get written, so the
  shared empty bytearray buffer is left untouched.
- In the buggy interpreter (injection.patch reverts the fix), the write
  `buf[len++] = value;` happens *before* the resize check, and
  `addition = len >> 1` is 0 while `len == 0`, so the first byte is
  written straight into the shared static zero-length buffer, corrupting
  its trailing NUL terminator.

`repro.py` then calls `float(bytearray())` on a *separate*, freshly
created empty bytearray. Because all empty bytearrays share the same
static backing buffer, that corrupted NUL byte is visible there too.
`float()`'s fast path for ASCII-digit-looking buffers asserts that the
buffer is NUL-terminated at `s[orig_len]`.

Observed difference:
- `bin/python-clean`: exits 0, prints
  `ValueError could not convert string to float: bytearray(b'')`.
- `bin/python-buggy`: aborts (exit status -6 / SIGABRT) with
  `Python/pystrtod.c:354: _Py_string_to_number_with_underscores:
  Assertion `s[orig_len] == '\0'' failed.`

# Reproducer notes

`repro.py` creates a `BytesIO` and calls `.write()` with an object `B`
whose `__buffer__` callback closes the `BytesIO` as a side effect before
returning the actual bytes to write.

`PyObject_GetBuffer()` on `B()` runs `__buffer__`, which calls
`memio.close()`, freeing the internal buffer. Control then returns to
`bytesio_write()`/`_pyio.BytesIO.write`, which (on the buggy build) already
did its `closed` check *before* calling `PyObject_GetBuffer`, so it goes on
to use the now-freed buffer.

- `python-clean` (fixed: checks `closed` only after obtaining the buffer,
  so the close that happens inside `__buffer__` is observed before any
  write happens): prints `ValueError I/O operation on closed file.` and
  exits 0.
- `python-buggy` (checks `closed` before calling `PyObject_GetBuffer`):
  segfaults, exiting with status -11 (SIGSEGV), due to the use-after-free
  of the BytesIO's internal buffer.

This matches upstream fix commit 6d54b6ac7d57 / gh-143378, and covers the
`test_write_concurrent_close` case (the C `_io.BytesIO` variant; the
`_pyio.BytesIO` had an analogous but non-crashing ordering bug — the C
extension is where the use-after-free actually manifests).

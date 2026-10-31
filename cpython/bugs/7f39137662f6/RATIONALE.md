# Rationale

Fix hunk reversed: `Lib/gzip.py` `_WriteBufferStream` (the weakref hunk). The import reorder is cosmetic and left alone; `weakref` stays imported but is unused.

- `__init__`: `self.gzip_file = weakref.ref(gzip_file)` -> `self.gzip_file = gzip_file`, a strong reference again. This restores the GzipFile -> BufferedWriter -> _WriteBufferStream -> GzipFile reference loop.
- `write`: drops the dereference and the "lost gzip_file" check, and calls `self.gzip_file._write_raw(data)` directly.

With the loop back, a GzipFile wrapping a temporary fileobj is collected by gc, and the fileobj can be closed before the GzipFile is finalized. That raises an unraisable `ValueError: I/O operation on closed file` in the finalizer.

Oracle case failing: `test.test_gzip.TestGzip.test_refloop_unraisable`. It fails with the unraisable ValueError, which is what the fix guards against.

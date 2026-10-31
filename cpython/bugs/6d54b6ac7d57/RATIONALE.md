# gh-143378 reintroduced: BytesIO write/writelines validate state before PyObject_GetBuffer

## Hunks changed
1. `tree/Modules/_io/bytesio.c`, `write_bytes_lock_held()`: reverses the fix's C hunk.
   `check_closed()` and `check_exports()` run again *before* `PyObject_GetBuffer()`.
   The `__buffer__` hook can then close the BytesIO or export a buffer after the
   checks. The write then proceeds on a stale or invalid `self->buf` (use-after-free).
   `writelines()` goes through the same helper, so it is covered too.
2. `tree/Lib/_pyio.py`, `BytesIO.write()`: reverses the fix's Python hunk.
   The closed check goes back to the top, before `memoryview(b)`. It no longer
   runs after the buffer is acquired. Behaviour is equivalent to the pre-fix code.
   v3.15.2 had since added a blank line and an early `return 0` inside the `with`, so
   the hunk does not reverse cleanly, but the effect is the same.

## Oracle failures
`./check.sh` reports 146 of 188 oracle cases failing. The interpreter crashed
mid-run (incomplete run), so most of those are cases that never ran. The direct
failures are the new tests `test_write_concurrent_close`,
`test_write_concurrent_export`, `test_writelines_concurrent_close` and
`test_writelines_concurrent_export` (C and Py variants). Without the fix, `write()`
and `writelines()` do not raise ValueError or BufferError. The C implementation crashes.

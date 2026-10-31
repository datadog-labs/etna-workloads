# Notes

`repro.py` reproduces gh-143195: a use-after-free in `bytearray.hex(sep)`
when `sep.__len__` is re-entrant and mutates the bytearray being hexlified.

It creates a 1-byte `bytearray`, then calls `ba.hex(sep)` with a `bytes`
subclass `S` whose `__len__` calls `ba.clear()` (freeing the bytearray's
internal buffer) before returning `1`. `bytearray.hex()` computes a
pointer/length into the bytearray's buffer up front, then calls
`len(sep)` while building the separated hex output, so the buffer can be
freed mid-call.

The fix (`bytearray_hex_impl` in `Objects/bytearrayobject.c`) guards
against this by incrementing `self->ob_exports` around the
`_Py_strhex_with_sep` call, which makes `bytearray.clear()` raise
`BufferError` instead of actually releasing the buffer while it is
"exported".

Observed difference (`PYTHONHASHSEED=0`, both exit status 0):

- `bin/python-clean` (fix present): raises `BufferError`, so the script
  prints `BufferError`.
- `bin/python-buggy` (fix reverted): `ba.clear()` succeeds, the
  bytearray's buffer is freed, and `hex()` goes on to read the freed
  memory, producing a different (stale/garbage) result —
  `no exception: 'dd'`.

The difference is deterministic across runs because the freed 1-byte
allocation is consistently reused the same way by the allocator in this
build; no crash/assert was needed to show divergence, but the resulting
output demonstrates the underlying use-after-free.

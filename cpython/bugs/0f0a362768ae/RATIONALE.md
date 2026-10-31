# Rationale

Fix: gh-140607, validate the count returned by `readinto` in `RawIOBase.read`.

## Hunks reversed
- `Modules/_io/iobase.c` (`_io__RawIOBase_read_impl`): removed the
  `bytes_filled < 0 || bytes_filled > n` check and its ValueError. The fix
  added this check. Code now resizes the bytearray straight to the untrusted
  count (v3.15.2 uses `PyByteArray_Resize` + `take_bytes` instead of
  `PyBytes_FromStringAndSize`, but the missing check has the same effect:
  an oversized count grows the buffer with uninitialised bytes, and a negative
  count raises SystemError instead of ValueError).
- `Lib/_pyio.py` (`RawIOBase.read`): removed
  `if n < 0 or n > len(b): raise ValueError(...)`. Without it, `del b[n:]`
  silently accepts out-of-range counts.

## Oracle failures
`CIOTest.test_RawIOBase_read_bounds_checking` and
`PyIOTest.test_RawIOBase_read_bounds_checking` fail ("ValueError not raised",
or a wrong exception type in C for negative counts).
